var express = require('express');
var app = express();
var conn = require('./dbConfig');
var crypto = require('crypto');
var fs = require('fs');
var path = require('path');
var session = require('express-session');
var multer = require('multer');

var applicationDocumentsDir = path.join(__dirname, 'uploads', 'application-documents');
var knowledgeFilesDir = path.join(__dirname, 'uploads', 'knowledge-files');
try {
    fs.mkdirSync(applicationDocumentsDir, { recursive: true });
    fs.mkdirSync(knowledgeFilesDir, { recursive: true });
} catch (error) {
    console.error('Private upload directory creation failed:', error.message);
}

var allowedDocumentTypes = [
    'Passport',
    'Academic Transcript',
    'English Language Result',
    'Offer / Admission Document',
    'Financial Document',
    'Other'
];
var allowedDocumentReviewStatuses = ['Received', 'Reviewed', 'Needs Replacement'];
var allowedDocumentExtensions = {
    '.pdf': 'application/pdf',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png'
};

var documentUpload = multer({
    storage: multer.diskStorage({
        destination: applicationDocumentsDir,
        filename: function (request, file, callback) {
            callback(null, crypto.randomUUID() + path.extname(file.originalname).toLowerCase());
        }
    }),
    limits: { fileSize: 10 * 1024 * 1024 },
    fileFilter: function (request, file, callback) {
        var extension = path.extname(file.originalname).toLowerCase();
        if (!allowedDocumentExtensions[extension] || allowedDocumentExtensions[extension] !== file.mimetype) {
            return callback(new Error('UNSUPPORTED_DOCUMENT_TYPE'));
        }
        callback(null, true);
    }
});

var allowedKnowledgeResourceTypes = {
    provider: ['School Brochure', 'Programme Guide', 'Fee Schedule', 'Scholarship Guide', 'Application Form', 'Agent Guide', 'Policy / Handbook', 'Other'],
    general: ['Immigration', 'Compliance', 'Training Support', 'Other']
};
var allowedKnowledgeExtensions = {
    '.pdf': 'application/pdf',
    '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    '.pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png'
};

var knowledgeFileUpload = multer({
    storage: multer.diskStorage({
        destination: knowledgeFilesDir,
        filename: function (request, file, callback) {
            callback(null, crypto.randomUUID() + path.extname(file.originalname).toLowerCase());
        }
    }),
    limits: { fileSize: 25 * 1024 * 1024 },
    fileFilter: function (request, file, callback) {
        var extension = path.extname(file.originalname).toLowerCase();
        if (!allowedKnowledgeExtensions[extension] || allowedKnowledgeExtensions[extension] !== file.mimetype) {
            return callback(new Error('UNSUPPORTED_KNOWLEDGE_FILE_TYPE'));
        }
        callback(null, true);
    }
});

app.set('view engine', 'ejs');

app.use('/public', express.static('public'));
app.use(express.urlencoded({ extended: false }));
app.use(session({
    secret: process.env.SESSION_SECRET || 'edubridge-local-session',
    resave: false,
    saveUninitialized: false
}));

var notificationTypes = {
    NEW_RECOMMENDATION: 'NEW_RECOMMENDATION',
    RECOMMENDATION_RESPONSE: 'RECOMMENDATION_RESPONSE',
    APPLICATION_STATUS_CHANGED: 'APPLICATION_STATUS_CHANGED',
    DOCUMENT_UPLOADED: 'DOCUMENT_UPLOADED',
    DOCUMENT_REVIEW_UPDATED: 'DOCUMENT_REVIEW_UPDATED',
    NEW_AGENT_REVIEW: 'NEW_AGENT_REVIEW'
};

function insertNotification(notification, callback) {
    var validType = Object.keys(notificationTypes).some(function (key) {
        return notificationTypes[key] === notification.type;
    });

    if (!validType) {
        return callback(new Error('Invalid notification type'));
    }

    var sql = `
        INSERT INTO notifications
            (recipientUserId, actorUserId, type, title, message, linkPath)
        VALUES (?, ?, ?, ?, ?, ?)
    `;

    conn.query(sql, [
        notification.recipientUserId,
        notification.actorUserId || null,
        notification.type,
        notification.title,
        notification.message,
        notification.linkPath || null
    ], callback);
}

function rollbackWithError(response, message, error) {
    console.error(message + ':', error.message);
    conn.rollback(function () {
        response.status(500).send(message);
    });
}

var allowedContentResourceTypes = ['YouTube', 'Official Link'];

function getYouTubeVideoId(resourceUrl) {
    try {
        var parsedUrl = new URL(resourceUrl);
        var hostname = parsedUrl.hostname.toLowerCase();
        if (parsedUrl.protocol !== 'https:' || !['youtube.com', 'www.youtube.com', 'youtu.be'].includes(hostname)) {
            return null;
        }

        var videoId = hostname === 'youtu.be'
            ? parsedUrl.pathname.split('/').filter(Boolean)[0]
            : parsedUrl.searchParams.get('v') || parsedUrl.pathname.match(/^\/(?:embed|shorts)\/([^/?#]+)/)?.[1];

        return videoId && /^[A-Za-z0-9_-]{11}$/.test(videoId) ? videoId : null;
    } catch (error) {
        return null;
    }
}

function normalizeContentResource(resource) {
    if (!resource || !allowedContentResourceTypes.includes(resource.resourceType)) {
        return null;
    }

    if (resource.resourceType === 'YouTube') {
        var videoId = getYouTubeVideoId(resource.resourceUrl);
        if (!videoId) {
            return null;
        }
        return Object.assign({}, resource, {
            videoId: videoId,
            embedUrl: 'https://www.youtube.com/embed/' + videoId
        });
    }

    try {
        var officialUrl = new URL(resource.resourceUrl);
        if (officialUrl.protocol !== 'https:') {
            return null;
        }
        return Object.assign({}, resource, { externalUrl: officialUrl.toString() });
    } catch (error) {
        return null;
    }
}

app.use(function (request, response, next) {
    response.locals.loggedin = request.session.loggedin;
    response.locals.username = request.session.username;
    response.locals.userRole = request.session.userRole;
    response.locals.unreadNotificationCount = 0;
    response.locals.useAppShell = Boolean(
        request.session.loggedin &&
        request.path !== '/' &&
        request.path !== '/login' &&
        request.path !== '/register' &&
        request.path.indexOf('/invite/') !== 0
    );
    var pageTitles = {
        '/membersOnly': 'Dashboard',
        '/students': 'Students',
        '/students/new': 'Students',
        '/applications': 'Applications',
        '/notifications': 'Notifications',
        '/programmes': 'Programmes',
        '/favourites': 'Favourites',
        '/training': 'Training Centre',
        '/knowledge': 'Knowledge Base',
        '/admin': 'Admin'
    };
    response.locals.pageTitle = pageTitles[request.path] || (
        request.path.indexOf('/applications/') === 0 ? 'Applications' :
          (request.path.indexOf('/programmes/') === 0 ? 'Programmes' :
              (request.path.indexOf('/students/') === 0 ? 'Students' :
                  (request.path.indexOf('/training/') === 0 ? 'Training Centre' :
                      (request.path.indexOf('/knowledge/') === 0 ? 'Knowledge Base' : 'EduBridge'))))
      );
    if (!request.session.loggedin) {
        return next();
    }

    conn.query(`
        SELECT COUNT(*) AS unreadNotificationCount
        FROM notifications
        WHERE recipientUserId = ? AND readAt IS NULL
    `, [request.session.userId], function (error, rows) {
        if (error) {
            console.error('Notification unread count query failed:', error.message);
            return next();
        }

        response.locals.unreadNotificationCount = rows[0].unreadNotificationCount;
        next();
    });
});

function requireLogin(request, response, next) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    next();
}

function requireAgent(request, response, next) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    if (
        request.session.userRole !== 'agent' &&
        request.session.userRole !== 'admin'
    ) {
        return response.status(403).send('You do not have permission to view this page.');
    }

    next();
}

function requireAgentFavourite(request, response, next) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    if (request.session.userRole !== 'agent') {
        return response.status(403).send('Only agents can use favourites.');
    }

    next();
}

function loadAgentFavouriteIds(request, itemType, itemIds, callback) {
    if (request.session.userRole !== 'agent' || itemIds.length === 0) {
        return callback(null, []);
    }

    var placeholders = itemIds.map(function () { return '?'; }).join(', ');
    conn.query(`
        SELECT itemId
        FROM favourites
        WHERE userId = ? AND itemType = ? AND itemId IN (${placeholders})
    `, [request.session.userId, itemType].concat(itemIds), function (error, rows) {
        if (error) return callback(error);
        callback(null, rows.map(function (row) { return row.itemId; }));
    });
}

function toggleFavourite(request, response, itemType, itemId, tableName, idColumn, redirectPath) {
    if (!Number.isInteger(itemId) || itemId < 1) {
        return response.status(404).send('Favourite item not found.');
    }

    conn.query(`SELECT ${idColumn} FROM ${tableName} WHERE ${idColumn} = ?`, [itemId], function (itemError, items) {
        if (itemError) {
            console.error('Favourite item lookup failed:', itemError.message);
            return response.status(500).send('Favourite item lookup failed.');
        }

        if (items.length === 0) {
            return response.status(404).send('Favourite item not found.');
        }

        conn.query(`
            SELECT favouriteId
            FROM favourites
            WHERE userId = ? AND itemType = ? AND itemId = ?
        `, [request.session.userId, itemType, itemId], function (favouriteError, favourites) {
            if (favouriteError) {
                console.error('Favourite lookup failed:', favouriteError.message);
                return response.status(500).send('Favourite lookup failed.');
            }

            if (favourites.length > 0) {
                return conn.query('DELETE FROM favourites WHERE favouriteId = ?', [favourites[0].favouriteId], function (deleteError) {
                    if (deleteError) {
                        console.error('Favourite removal failed:', deleteError.message);
                        return response.status(500).send('Favourite removal failed.');
                    }
                    response.redirect(redirectPath);
                });
            }

            conn.query(`
                INSERT INTO favourites (userId, itemType, itemId)
                VALUES (?, ?, ?)
            `, [request.session.userId, itemType, itemId], function (insertError) {
                if (insertError) {
                    console.error('Favourite save failed:', insertError.message);
                    return response.status(insertError.code === 'ER_DUP_ENTRY' ? 409 : 500).send('Favourite save failed.');
                }
                response.redirect(redirectPath);
            });
        });
    });
}

function requireKnowledgeAccess(request, response, next) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    if (request.session.userRole !== 'agent' && request.session.userRole !== 'admin') {
        return response.status(403).send('You do not have permission to view this page.');
    }

    next();
}

function knowledgeFileGroup(request) {
    return request.body.resourceGroup === 'provider' ? 'provider' : 'general';
}

function validateKnowledgeFileMetadata(request, allowMissingFile) {
    var group = knowledgeFileGroup(request);
    var provider = (request.body.provider || '').trim();
    var resourceType = (request.body.resourceType || '').trim();
    var title = (request.body.title || '').trim();
    var description = (request.body.description || '').trim();
    var versionLabel = (request.body.versionLabel || '').trim();
    var errors = [];

    if (!title || title.length > 255) errors.push('Title is required and must be 255 characters or fewer.');
    if (group === 'provider' && (!provider || provider.length > 150)) errors.push('Provider is required and must be 150 characters or fewer.');
    if (group === 'general') provider = null;
    if (allowedKnowledgeResourceTypes[group].indexOf(resourceType) === -1) errors.push('Invalid resource type.');
    if (description.length > 10000) errors.push('Description must be 10000 characters or fewer.');
    if (versionLabel.length > 80) errors.push('Version must be 80 characters or fewer.');
    if (!allowMissingFile && !request.file) errors.push('A file is required.');

    return {
        errors: errors,
        group: group,
        provider: provider,
        resourceType: resourceType,
        title: title,
        description: description,
        versionLabel: versionLabel || null
    };
}

function knowledgeFileType(file) {
    return path.extname(file.originalname).slice(1).toUpperCase();
}

function requireAdmin(request, response, next) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    if (request.session.userRole !== 'admin') {
        return response.status(403).send('You do not have permission to view this page.');
    }

    next();
}

function handleDocumentUpload(request, response, next) {
    documentUpload.single('file')(request, response, function (error) {
        if (!error) {
            return next();
        }

        if (error instanceof multer.MulterError && error.code === 'LIMIT_FILE_SIZE') {
            return response.status(400).send('File exceeds 10 MB.');
        }

        if (error.message === 'UNSUPPORTED_DOCUMENT_TYPE') {
            return response.status(400).send('Unsupported file type.');
        }

        console.error('Application document upload failed:', error.message);
        response.status(400).send('Document upload failed.');
    });
}

function handleKnowledgeFileUpload(request, response, next) {
    knowledgeFileUpload.single('file')(request, response, function (error) {
        if (!error) {
            return next();
        }

        if (error instanceof multer.MulterError && error.code === 'LIMIT_FILE_SIZE') {
            return response.status(400).send('File exceeds 25 MB.');
        }

        if (error.message === 'UNSUPPORTED_KNOWLEDGE_FILE_TYPE') {
            return response.status(400).send('Unsupported Knowledge file type.');
        }

        console.error('Knowledge file upload failed:', error.message);
        response.status(400).send('Knowledge file upload failed.');
    });
}

function removeUploadedFile(file, callback) {
    if (!file || !file.path) {
        return callback();
    }

    fs.unlink(file.path, function (error) {
        if (error && error.code !== 'ENOENT') {
            console.error('Orphan document cleanup failed:', error.message);
        }
        callback();
    });
}

function rollbackAndRemoveFile(response, message, error, file) {
    console.error(message + ':', error.message);
    conn.rollback(function () {
        removeUploadedFile(file, function () {
            response.status(500).send(message);
        });
    });
}

function findScopedApplication(request, callback) {
    var applicationId = Number(request.params.applicationId || request.params.id);
    if (!Number.isInteger(applicationId) || applicationId < 1) {
        return callback(null, null, 404);
    }

    var sql = `
        SELECT a.applicationId, a.ownerUserId,
               owner.agentId, owner.name AS studentName,
               p.programmeName
        FROM applications AS a
        LEFT JOIN users AS owner ON a.ownerUserId = owner.id
        INNER JOIN programmes AS p ON a.programmeId = p.programmeId
        WHERE a.applicationId = ?
    `;
    var values = [applicationId];

    if (request.session.userRole === 'student') {
        sql += ' AND a.ownerUserId = ?';
        values.push(request.session.userId);
    } else if (request.session.userRole === 'agent') {
        sql += `
            AND a.ownerUserId IN (
                SELECT id FROM users WHERE agentId = ?
            )
        `;
        values.push(request.session.userId);
    } else if (request.session.userRole !== 'admin') {
        return callback(null, null, 403);
    }

    conn.query(sql, values, function (error, applications) {
        if (error) {
            return callback(error);
        }
        callback(null, applications[0] || null, applications.length ? null : 403);
    });
}

function requireApplicationScope(request, response, next) {
    findScopedApplication(request, function (error, application, status) {
        if (error) {
            console.error('Application scope query failed:', error.message);
            return response.status(500).send('Application scope query failed');
        }
        if (!application) {
            return response.status(status || 403).send(status === 404 ? 'Application not found' : 'You do not have access to this application.');
        }
        request.scopedApplication = application;
        next();
    });
}

function requireStudentApplicationScope(request, response, next) {
    if (request.session.userRole !== 'student') {
        return response.status(403).send('Only students can upload documents.');
    }
    requireApplicationScope(request, response, next);
}

function queryPromise(sql, values) {
    return new Promise(function (resolve, reject) {
        conn.query(sql, values || [], function (error, results) {
            if (error) return reject(error);
            resolve(results);
        });
    });
}

function getAdminStatistics(callback) {
    Promise.all([
        queryPromise(`
            SELECT COUNT(*) AS total,
                   SUM(role = 'student') AS students,
                   SUM(role = 'agent') AS agents,
                   SUM(role = 'admin') AS admins
            FROM users
        `),
        queryPromise(`
            SELECT status, COUNT(*) AS count
            FROM applications
            GROUP BY status
            ORDER BY status
        `),
        queryPromise(`
            SELECT provider, COUNT(*) AS count
            FROM programmes
            GROUP BY provider
            ORDER BY count DESC, provider
        `),
        queryPromise(`
            SELECT level, COUNT(*) AS count
            FROM programmes
            GROUP BY level
            ORDER BY count DESC, level
        `),
        queryPromise(`
            SELECT
                (SELECT COUNT(*) FROM trainingModules) AS totalModules,
                (SELECT COUNT(*) FROM trainingProgress) AS completionCount,
                (SELECT COUNT(DISTINCT moduleId) FROM trainingProgress) AS completedModuleCount,
                ROUND(
                    (SELECT COUNT(DISTINCT moduleId) FROM trainingProgress) * 100 /
                    NULLIF((SELECT COUNT(*) FROM trainingModules), 0), 1
                ) AS completionRate,
                (SELECT AVG(score) FROM trainingQuizAttempts) AS averageQuizScore,
                (SELECT AVG(totalQuestions) FROM trainingQuizAttempts) AS averageQuizTotal,
                (SELECT AVG(CASE WHEN totalQuestions > 0 THEN score * 100 / totalQuestions END)
                 FROM trainingQuizAttempts) AS averageQuizPercent
        `),
        queryPromise(`
            SELECT
                (SELECT COUNT(*) FROM knowledgeArticles) AS articles,
                (SELECT COUNT(*) FROM knowledgeFaqs) AS faqs,
                (SELECT COUNT(*) FROM knowledgeFiles
                 WHERE status = 'Current'
                   AND (storedFileName IS NOT NULL OR fileUrl LIKE 'https://%')) AS currentDownloadableResources
        `),
        queryPromise(`
            SELECT
                (SELECT COUNT(*) FROM programmeRecommendations) AS recommendations,
                (SELECT COUNT(*) FROM agentReviews) AS reviews,
                (SELECT AVG(rating) FROM agentReviews) AS averageReviewRating,
                (SELECT COUNT(*) FROM applicationDocuments) AS uploadedApplicationDocuments
        `),
        queryPromise(`
            SELECT rating, COUNT(*) AS count
            FROM agentReviews
            GROUP BY rating
            ORDER BY rating
        `)
    ]).then(function (results) {
        callback(null, {
            users: results[0][0],
            applicationStatuses: results[1],
            programmeProviders: results[2],
            programmeLevels: results[3],
            training: results[4][0],
            knowledge: results[5][0],
            engagement: results[6][0],
            reviewRatings: results[7]
        });
    }).catch(function (error) {
        callback(error);
    });
}

    app.get('/', function(request, response) {
        response.render('home', {
            title: 'EduBridge'
        });
    });

    app.get('/login', function(request, response) {
        response.render('login');
    });

    app.get('/register', function(request, response) {
        response.render('register');
    });

    app.get('/admin', requireAdmin, function (request, response) {
        var sql = `
            SELECT
                (SELECT COUNT(*) FROM users) AS userCount,
                (SELECT COUNT(*) FROM programmes) AS programmeCount,
                (SELECT COUNT(*) FROM applications) AS applicationCount,
                (SELECT COUNT(*) FROM trainingModules) AS trainingModuleCount
        `;

        conn.query(sql, function (error, results) {
            if (error) {
                console.error('Admin overview query failed:', error.message);
                return response.status(500).send('Admin overview query failed');
            }

            
        var userSql = `
            SELECT
                u.id,
                u.name,
                u.email,
                u.role,
                u.agentId,
                agent.name AS agentName
            FROM users AS u
            LEFT JOIN users AS agent
                ON u.agentId = agent.id
            ORDER BY u.id
        `;

        conn.query(userSql, function (userError, users) {
            if (userError) {
                console.error('Admin users query failed:', userError.message);
                return response.status(500).send('Admin users query failed');
            }

        var moduleSql = `
            SELECT moduleId, title, description
            FROM trainingModules
            ORDER BY moduleId
        `;

        conn.query(moduleSql, function (moduleError, trainingModules) {
            if (moduleError) {
                console.error('Admin training query failed:', moduleError.message);
                return response.status(500).send('Admin training query failed');
            }

            var articleSql = `
                SELECT articleId, title, category, sourceLabel
                FROM knowledgeArticles
                ORDER BY articleId
            `;

            conn.query(articleSql, function (articleError, knowledgeArticles) {
                if (articleError) {
                    console.error('Admin article query failed:', articleError.message);
                    return response.status(500).send('Admin article query failed');
                }

                conn.query(`
                    SELECT programmeId, programmeName, provider, level, location, duration, studyArea
                    FROM programmes
                    ORDER BY programmeName
                `, function (programmeError, programmes) {
                    if (programmeError) {
                        console.error('Admin programme query failed:', programmeError.message);
                        return response.status(500).send('Admin programme query failed');
                    }

                    var recommendationSql = `
                        SELECT r.recommendationId, r.status, r.reason, r.studentComment, r.createdAt,
                               student.name AS studentName, agent.name AS agentName,
                               p.programmeName, p.provider
                        FROM programmeRecommendations AS r
                        INNER JOIN users AS student ON r.studentUserId = student.id
                        INNER JOIN users AS agent ON r.agentUserId = agent.id
                        INNER JOIN programmes AS p ON r.programmeId = p.programmeId
                        ORDER BY r.createdAt DESC, r.recommendationId DESC
                    `;

                    conn.query(recommendationSql, function (recommendationError, recommendations) {
                        if (recommendationError) {
                            console.error('Admin recommendation query failed:', recommendationError.message);
                            return response.status(500).send('Admin recommendation query failed');
                        }

                        var reviewSql = `
                            SELECT r.reviewId, r.rating, r.comment, r.createdAt,
                                   student.name AS studentName, agent.name AS agentName,
                                   r.applicationId, p.programmeName
                            FROM agentReviews AS r
                            INNER JOIN users AS student ON r.studentUserId = student.id
                            INNER JOIN users AS agent ON r.agentUserId = agent.id
                            INNER JOIN applications AS a ON r.applicationId = a.applicationId
                            INNER JOIN programmes AS p ON a.programmeId = p.programmeId
                            ORDER BY r.createdAt DESC, r.reviewId DESC
                        `;

                        conn.query(reviewSql, function (reviewError, reviews) {
                            if (reviewError) {
                                console.error('Admin review query failed:', reviewError.message);
                                return response.status(500).send('Admin review query failed');
                            }

                            getAdminStatistics(function (statisticsError, statistics) {
                                if (statisticsError) {
                                    console.error('Admin statistics query failed:', statisticsError.message);
                                    return response.status(500).send('Admin statistics query failed');
                                }

                                response.render('admin', {
                                    ...results[0],
                                    userId: request.session.userId,
                                    users: users,
                                    trainingModules: trainingModules,
                                    knowledgeArticles: knowledgeArticles,
                                    programmes: programmes,
                                    recommendations: recommendations,
                                    reviews: reviews,
                                    statistics: statistics
                                });
                            });
                        });
                    });
                });
            });
        });
    });
});
});

app.post('/admin/training', requireAdmin, function (request, response) {
    var title = (request.body.title || '').trim();
    var description = (request.body.description || '').trim();

    if (!title || !description) {
        return response.redirect('/admin');
    }

    var sql = `
        INSERT INTO trainingModules (title, description)
        VALUES (?, ?)
    `;

    conn.query(sql, [title, description], function (error) {
        if (error) {
            console.error('Training module insert failed:', error.message);
            return response.status(500).send('Training module insert failed');
        }

        response.redirect('/admin');
    });
});

app.post('/admin/training/delete', requireAdmin, function (request, response) {
    var moduleId = parseInt(request.body.moduleId, 10);

    if (Number.isNaN(moduleId)) {
        return response.status(400).send('Invalid module ID');
    }

    var deleteProgressSql = `
        DELETE FROM trainingProgress
        WHERE moduleId = ?
    `;

    conn.query(deleteProgressSql, [moduleId], function (progressError) {
        if (progressError) {
            console.error('Training progress delete failed:', progressError.message);
            return response.status(500).send('Training progress delete failed');
        }

        var deleteModuleSql = `
            DELETE FROM trainingModules
            WHERE moduleId = ?
        `;

        conn.query(deleteModuleSql, [moduleId], function (moduleError) {
            if (moduleError) {
                console.error('Training module delete failed:', moduleError.message);
                return response.status(500).send('Training module delete failed');
            }

            response.redirect('/admin');
        });
    });
});

app.post('/admin/training/edit', requireAdmin, function (request, response) {
    var moduleId = parseInt(request.body.moduleId, 10);
    var title = (request.body.title || '').trim();
    var description = (request.body.description || '').trim();

    if (Number.isNaN(moduleId) || !title || !description) {
        return response.redirect('/admin');
    }

    var sql = `
        UPDATE trainingModules
        SET title = ?, description = ?
        WHERE moduleId = ?
    `;

    conn.query(sql, [title, description, moduleId], function (error) {
        if (error) {
            console.error('Training module update failed:', error.message);
            return response.status(500).send('Training module update failed');
        }

        response.redirect('/admin');
    });
});

app.post('/admin/knowledge', requireAdmin, function (request, response) {
    var title = (request.body.title || '').trim();
    var category = (request.body.category || '').trim();
    var content = (request.body.content || '').trim();
    var sourceLabel = (request.body.sourceLabel || '').trim();

    if (!title || !category || !content || !sourceLabel) {
        return response.redirect('/admin');
    }

    var sql = `
        INSERT INTO knowledgeArticles
            (title, category, content, sourceLabel)
        VALUES (?, ?, ?, ?)
    `;

    conn.query(
        sql,
        [title, category, content, sourceLabel],
        function (error) {
            if (error) {
                console.error('Knowledge article insert failed:', error.message);
                return response.status(500).send('Knowledge article insert failed');
            }

            response.redirect('/admin');
        }
    );
});

        function createPasswordHash(password, callback) {
            var salt = crypto.randomBytes(16).toString('hex');

            crypto.scrypt(password, salt, 64, function (error, derivedKey) {
                if (error) {
                    return callback(error);
                }

                var passwordHash = salt + ':' + derivedKey.toString('hex');
                callback(null, passwordHash);
            });
        }

        function verifyPassword(password, storedPassword, callback) {
            var parts = storedPassword.split(':');

            if (parts.length !== 2) {
                return callback(null, false);
            }

            var salt = parts[0];
            var storedHash = Buffer.from(parts[1], 'hex');

            crypto.scrypt(password, salt, storedHash.length, function (error, derivedKey) {
                if (error) {
                    return callback(error);
                }

                if (storedHash.length !== derivedKey.length) {
                    return callback(null, false);
                }

                var passwordMatches = crypto.timingSafeEqual(
                    storedHash,
                    derivedKey
                );

                callback(null, passwordMatches);
            });
}

app.post('/admin/knowledge/delete', requireAdmin, function (request, response) {
    var articleId = parseInt(request.body.articleId, 10);

    if (Number.isNaN(articleId)) {
        return response.status(400).send('Invalid article ID');
    }

    var sql = `
        DELETE FROM knowledgeArticles
        WHERE articleId = ?
    `;

    conn.query(sql, [articleId], function (error) {
        if (error) {
            console.error('Knowledge article delete failed:', error.message);
            return response.status(500).send('Knowledge article delete failed');
        }

        response.redirect('/admin');
    });
});

app.post('/admin/knowledge/edit', requireAdmin, function (request, response) {
    var articleId = parseInt(request.body.articleId, 10);
    var title = (request.body.title || '').trim();
    var category = (request.body.category || '').trim();
    var content = (request.body.content || '').trim();
    var sourceLabel = (request.body.sourceLabel || '').trim();

    if (Number.isNaN(articleId) || !title || !category || !content || !sourceLabel) {
        return response.redirect('/admin');
    }

    var sql = `
        UPDATE knowledgeArticles
        SET title = ?, category = ?, content = ?, sourceLabel = ?
        WHERE articleId = ?
    `;

    conn.query(sql, [title, category, content, sourceLabel, articleId], function (error) {
        if (error) {
            console.error('Knowledge article update failed:', error.message);
            return response.status(500).send('Knowledge article update failed');
        }

        response.redirect('/admin');
    });
});

app.post('/admin/users/:id/role', requireAdmin, function (request, response) {
    var userId = parseInt(request.params.id, 10);
    var role = request.body.role;

    var allowedRoles = ['student', 'agent', 'admin'];

    if (Number.isNaN(userId) || allowedRoles.indexOf(role) === -1) {
        return response.status(400).send('Invalid user or role');
    }

    var sql = `
        UPDATE users
        SET role = ?
        WHERE id = ?
    `;

    conn.query(sql, [role, userId], function (error) {
        if (error) {
            console.error('User role update failed:', error.message);
            return response.status(500).send('User role update failed');
        }

        response.redirect('/admin');
    });
});

app.post('/admin/users/:id/agent', requireAdmin, function (request, response) {
    var studentId = parseInt(request.params.id, 10);
    var agentId = parseInt(request.body.agentId, 10);

    if (Number.isNaN(studentId) || Number.isNaN(agentId)) {
        return response.status(400).send('Invalid user ID');
    }

    var agentSql = 'SELECT id FROM users WHERE id = ? AND role = ?';

    conn.query(agentSql, [agentId, 'agent'], function (agentError, agents) {
        if (agentError) {
            console.error('Agent lookup failed:', agentError.message);
            return response.status(500).send('Agent lookup failed');
        }

        if (agents.length === 0) {
            return response.status(400).send('Selected user is not an agent');
        }

        var updateSql = `
            UPDATE users
            SET agentId = ?
            WHERE id = ? AND role = ?
        `;

        conn.query(updateSql, [agentId, studentId, 'student'], function (updateError) {
            if (updateError) {
                console.error('Student assignment failed:', updateError.message);
                return response.status(500).send('Student assignment failed');
            }

            response.redirect('/admin');
        });
    });
});

app.post('/admin/accounts/:id/delete', requireAdmin, function (request, response) {
    var userId = parseInt(request.params.id, 10);

    if (!Number.isInteger(userId)) {
        return response.status(400).send('Invalid user ID');
    }

    if (userId === request.session.userId) {
        return response.status(403).send('You cannot delete your own account.');
    }

    var dependencySql = `
        SELECT
            (SELECT COUNT(*) FROM applications WHERE ownerUserId = ?) AS applications,
            (SELECT COUNT(*) FROM applicationconversationreads WHERE userId = ?) AS conversationReads,
            (SELECT COUNT(*) FROM applicationmessages WHERE senderUserId = ?) AS messages,
            (SELECT COUNT(*) FROM applicationstatushistory WHERE changedByUserId = ?) AS statusHistory,
            (SELECT COUNT(*) FROM invitations WHERE agentId = ?) AS invitations,
            (SELECT COUNT(*) FROM trainingprogress WHERE userId = ?) AS trainingProgress,
            (SELECT COUNT(*) FROM trainingquizattempts WHERE userId = ?) AS quizAttempts,
            (SELECT COUNT(*) FROM users WHERE agentId = ?) AS assignedStudents
    `;

    conn.query(dependencySql, [userId, userId, userId, userId, userId, userId, userId, userId], function (dependencyError, rows) {
        if (dependencyError) {
            console.error('Account dependency check failed:', dependencyError.message);
            return response.status(500).send('Account dependency check failed');
        }

        var dependencyCount = Object.keys(rows[0]).reduce(function (total, key) {
            return total + Number(rows[0][key]);
        }, 0);

        if (dependencyCount > 0) {
            return response.status(409).send('This account cannot be deleted because it is linked to existing records.');
        }

        conn.query('DELETE FROM users WHERE id = ?', [userId], function (deleteError, result) {
            if (deleteError) {
                console.error('Account delete failed:', deleteError.message);
                return response.status(500).send('Account delete failed');
            }

            if (result.affectedRows === 0) {
                return response.status(404).send('Account not found');
            }

            response.redirect('/admin');
        });
    });
});

app.get('/admin/programmes/:id/edit', requireAdmin, function (request, response) {
    var programmeId = parseInt(request.params.id, 10);

    if (!Number.isInteger(programmeId)) {
        return response.status(400).send('Invalid programme ID');
    }

    var sql = `
        SELECT programmeId, programmeName, provider, level, location, duration, studyArea
        FROM programmes
        WHERE programmeId = ?
    `;

    conn.query(sql, [programmeId], function (error, programmes) {
        if (error) {
            console.error('Programme edit lookup failed:', error.message);
            return response.status(500).send('Programme edit lookup failed');
        }

        if (programmes.length === 0) {
            return response.status(404).send('Programme not found');
        }

        response.render('adminProgrammeEdit', { programme: programmes[0] });
    });
});

app.post('/admin/programmes/edit', requireAdmin, function (request, response) {
    var programmeId = parseInt(request.body.programmeId, 10);
    var programmeName = (request.body.programmeName || '').trim();
    var provider = (request.body.provider || '').trim();
    var level = (request.body.level || '').trim();
    var location = (request.body.location || '').trim();
    var duration = (request.body.duration || '').trim();
    var studyArea = (request.body.studyArea || '').trim();

    if (Number.isNaN(programmeId) || !programmeName || !provider || !level || !location || !duration || !studyArea) {
        return response.redirect('/admin');
    }

    var sql = `
        UPDATE programmes
        SET programmeName = ?, provider = ?, level = ?, location = ?, duration = ?, studyArea = ?
        WHERE programmeId = ?
    `;

    conn.query(sql, [programmeName, provider, level, location, duration, studyArea, programmeId], function (error) {
        if (error) {
            console.error('Programme update failed:', error.message);
            if (error.code === 'ER_DUP_ENTRY') {
                return response.status(409).send('A programme with this name already exists.');
            }
            return response.status(500).send('Programme update failed');
        }

        response.redirect('/admin');
    });
});

app.post('/admin/programmes/delete', requireAdmin, function (request, response) {
    var programmeId = parseInt(request.body.programmeId, 10);

    if (Number.isNaN(programmeId)) {
        return response.status(400).send('Invalid programme ID');
    }

    var checkSql = `
        SELECT COUNT(*) AS applicationCount
        FROM applications
        WHERE programmeId = ?
    `;

    conn.query(checkSql, [programmeId], function (checkError, results) {
        if (checkError) {
            console.error('Programme usage check failed:', checkError.message);
            return response.status(500).send('Programme usage check failed');
        }

        if (results[0].applicationCount > 0) {
            return response.status(409).send('Programme cannot be deleted because applications use it.');
        }

        var deleteSql = `
            DELETE FROM programmes
            WHERE programmeId = ?
        `;

        conn.query(deleteSql, [programmeId], function (deleteError) {
            if (deleteError) {
                console.error('Programme delete failed:', deleteError.message);
                return response.status(500).send('Programme delete failed');
            }

            response.redirect('/admin');
        });
    });
});

app.post('/admin/programmes', requireAdmin, function (request, response) {
    var programmeName = (request.body.programmeName || '').trim();
    var provider = (request.body.provider || '').trim();
    var level = (request.body.level || '').trim();
    var location = (request.body.location || '').trim();
    var duration = (request.body.duration || '').trim();
    var studyArea = (request.body.studyArea || '').trim();

    if (!programmeName || !provider || !level || !location || !duration || !studyArea) {
        return response.redirect('/admin');
    }

    var sql = `
        INSERT INTO programmes
            (programmeName, provider, level, location, duration, studyArea)
        VALUES (?, ?, ?, ?, ?, ?)
    `;

    conn.query(sql, [programmeName, provider, level, location, duration, studyArea], function (error) {
        if (error) {
            console.error('Programme insert failed:', error.message);
            return response.status(500).send('Programme insert failed');
        }

        response.redirect('/admin');
    });
});

app.post('/register', function (request, response) {
    var name = (request.body.name || '').trim();
    var email = (request.body.email || '').trim();
    var password = request.body.password;

    if (!name || !email || !password) {
        return response.redirect('/register');
    }

    createPasswordHash(password, function (error, passwordHash) {
        if (error) {
            console.error('Password hash failed:', error.message);
            return response.status(500).send('Password setup failed');
        }

        var sql = 'INSERT INTO users (name, email, password) VALUES (?, ?, ?)';

        conn.query(
            sql,
            [name, email, passwordHash],
            function (error) {
                if (error) {
                    console.error('Registration query failed:', error.message);
                    return response.status(500).send('Registration failed');
                }

                response.redirect('/login');
            }
        );
    });
});

app.post('/auth', function (request, response) {
    var username = request.body.username;
    var password = request.body.password;

    if (!username || !password) {
        return response.redirect('/login');
    }

    var sql = 'SELECT id, name, password, role FROM users WHERE name = ?';

    conn.query(sql, [username], function (error, results) {
        if (error) {
            console.error('Database query failed:', error.message);
            return response.status(500).send('Database query failed');
        }

        if (results.length === 0) {
            return response.redirect('/register');
        }

        verifyPassword(
            password,
            results[0].password,
            function (error, passwordMatches) {
                if (error) {
                    console.error('Password verification failed:', error.message);
                    return response.status(500).send('Password verification failed');
                }

                if (passwordMatches) {
                    request.session.loggedin = true;
                    request.session.userId = results[0].id;
                    request.session.username = results[0].name;
                    request.session.userRole = results[0].role;

                    return response.redirect('/membersOnly');
                }

                return response.redirect('/login');
            }
        );
    });
});

var port = process.env.PORT || 3000;

app.get('/membersOnly', function (request, response) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    var role = request.session.userRole;
    var applicationSql = `
        SELECT status, COUNT(*) AS statusCount
        FROM applications
    `;
    var applicationValues = [];

    if (role === 'student') {
        applicationSql += ' WHERE ownerUserId = ?';
        applicationValues.push(request.session.userId);
    } else if (role === 'agent') {
        applicationSql += `
            WHERE ownerUserId IN (
                SELECT id FROM users WHERE agentId = ?
            )
        `;
        applicationValues.push(request.session.userId);
    }

    applicationSql += ' GROUP BY status ORDER BY status';

    conn.query(applicationSql, applicationValues, function (applicationError, applicationRows) {
        if (applicationError) {
            console.error('Dashboard application query failed:', applicationError.message);
            return response.status(500).send('Dashboard application query failed');
        }

        var applicationStatusCounts = {};
        var applicationTotal = 0;

        applicationRows.forEach(function (row) {
            applicationStatusCounts[row.status] = row.statusCount;
            applicationTotal += row.statusCount;
        });

        if (role === 'admin') {
            var adminSql = `
                SELECT
                    (SELECT COUNT(*) FROM users) AS accountCount,
                    (SELECT COUNT(*) FROM programmes) AS programmeCount,
                    (SELECT COUNT(*) FROM applications) AS applicationCount,
                    (SELECT COUNT(*) FROM trainingModules) AS trainingModuleCount,
                    (SELECT COUNT(*) FROM knowledgeArticles) AS knowledgeArticleCount
            `;

            return conn.query(adminSql, function (adminError, adminRows) {
                if (adminError) {
                    console.error('Dashboard admin query failed:', adminError.message);
                    return response.status(500).send('Dashboard admin query failed');
                }

                response.render('membersOnly', {
                    dashboard: {
                        role: role,
                        admin: adminRows[0]
                    }
                });
            });
        }

        var unreadSql = `
            SELECT COUNT(*) AS unreadMessageCount
            FROM applicationMessages AS m
            INNER JOIN applications AS a
                ON m.applicationId = a.applicationId
            LEFT JOIN applicationConversationReads AS r
                ON r.applicationId = a.applicationId
                AND r.userId = ?
            WHERE m.senderUserId <> ?
              AND (r.lastReadAt IS NULL OR m.createdAt > r.lastReadAt)
        `;
        var unreadValues = [request.session.userId, request.session.userId];

        if (role === 'student') {
            unreadSql += ' AND a.ownerUserId = ?';
            unreadValues.push(request.session.userId);
        } else {
            unreadSql += `
                AND a.ownerUserId IN (
                    SELECT id FROM users WHERE agentId = ?
                )
            `;
            unreadValues.push(request.session.userId);
        }

        conn.query(unreadSql, unreadValues, function (unreadError, unreadRows) {
            if (unreadError) {
                console.error('Dashboard unread query failed:', unreadError.message);
                return response.status(500).send('Dashboard unread query failed');
            }

            if (role === 'agent') {
                var agentSummarySql = `
                    SELECT
                        (
                            SELECT COUNT(*)
                            FROM applications
                            WHERE ownerUserId IN (
                                SELECT id FROM users WHERE agentId = ?
                            )
                            AND status IN ('New', 'Documents Required')
                        ) AS attentionCount,
                        (
                            SELECT COUNT(*)
                            FROM trainingModules AS m
                            LEFT JOIN trainingProgress AS tp
                                ON tp.moduleId = m.moduleId
                                AND tp.userId = ?
                            WHERE tp.moduleId IS NULL
                        ) AS incompleteTrainingCount,
                        (
                            SELECT COUNT(*)
                            FROM users
                            WHERE role = 'student' AND agentId = ?
                        ) AS assignedStudentCount
                `;

                return conn.query(
                    agentSummarySql,
                    [request.session.userId, request.session.userId, request.session.userId],
                    function (summaryError, summaryRows) {
                        if (summaryError) {
                            console.error('Agent dashboard summary query failed:', summaryError.message);
                            return response.status(500).send('Agent dashboard summary query failed');
                        }

                        var recentMessagesSql = `
                            SELECT
                                m.applicationId,
                                owner.name AS studentName,
                                p.programmeName,
                                m.messageText,
                                m.createdAt,
                                CASE
                                    WHEN m.senderUserId <> ?
                                         AND (r.lastReadAt IS NULL OR m.createdAt > r.lastReadAt)
                                    THEN 1
                                    ELSE 0
                                END AS unread
                            FROM applicationMessages AS m
                            INNER JOIN applications AS a
                                ON m.applicationId = a.applicationId
                            INNER JOIN users AS owner
                                ON a.ownerUserId = owner.id
                            INNER JOIN programmes AS p
                                ON a.programmeId = p.programmeId
                            LEFT JOIN applicationConversationReads AS r
                                ON r.applicationId = a.applicationId
                                AND r.userId = ?
                                                        WHERE m.senderUserId <> ?
                                                            AND a.ownerUserId IN (
                                SELECT id FROM users WHERE agentId = ?
                            )
                            ORDER BY m.createdAt DESC, m.id DESC
                            LIMIT 5
                        `;

                        conn.query(
                            recentMessagesSql,
                            [request.session.userId, request.session.userId, request.session.userId, request.session.userId],
                            function (messageError, recentMessages) {
                                if (messageError) {
                                    console.error('Agent recent messages query failed:', messageError.message);
                                    return response.status(500).send('Agent recent messages query failed');
                                }

                                var knowledgeSql = `
                                    SELECT articleId, title, category, updatedAt
                                    FROM knowledgeArticles
                                                                        WHERE title NOT REGEXP '^[0-9]+$'
                                                                            AND category NOT REGEXP '^[0-9]+$'
                                    ORDER BY updatedAt DESC, articleId DESC
                                    LIMIT 5
                                `;

                                conn.query(knowledgeSql, function (knowledgeError, knowledgeUpdates) {
                                    if (knowledgeError) {
                                        console.error('Knowledge updates query failed:', knowledgeError.message);
                                        return response.status(500).send('Knowledge updates query failed');
                                    }

                                    response.render('membersOnly', {
                                        dashboard: {
                                            role: role,
                                            applicationTotal: applicationTotal,
                                            applicationStatusCounts: applicationStatusCounts,
                                            unreadMessageCount: unreadRows[0].unreadMessageCount,
                                            attentionCount: summaryRows[0].attentionCount,
                                            incompleteTrainingCount: summaryRows[0].incompleteTrainingCount,
                                            assignedStudentCount: summaryRows[0].assignedStudentCount,
                                            recentMessages: recentMessages,
                                            knowledgeUpdates: knowledgeUpdates
                                        }
                                    });
                                });
                            }
                        );
                    }
                );
            }

            response.render('membersOnly', {
                dashboard: {
                    role: role,
                    applicationTotal: applicationTotal,
                    applicationStatusCounts: applicationStatusCounts,
                    unreadMessageCount: unreadRows[0].unreadMessageCount
                }
            });
        });
    });
});

app.post('/invitations', function (request, response) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    if (request.session.userRole !== 'agent' && request.session.userRole !== 'admin') {
        return response.status(403).send('You do not have permission to invite students.');
    }

    var email = (request.body.email || '').trim();

    if (!email) {
        return response.redirect('/membersOnly');
    }

    var token = crypto.randomBytes(32).toString('hex');
    var sql = `
        INSERT INTO invitations (agentId, email, token)
        VALUES (?, ?, ?)
    `;

    conn.query(sql, [request.session.userId, email, token], function (error) {
        if (error) {
            console.error('Invitation insert failed:', error.message);
            return response.status(500).send('Invitation creation failed');
        }

        var invitationLink = '/invite/' + token;
        response.render('membersOnly', { invitationLink: invitationLink });
    });
});

app.get('/invite/:token', function (request, response) {
    var sql = `
        SELECT token
        FROM invitations
        WHERE token = ? AND usedAt IS NULL
    `;

    conn.query(sql, [request.params.token], function (error, results) {
        if (error) {
            return response.status(500).send('Invitation lookup failed');
        }

        if (results.length === 0) {
            return response.status(404).send('Invitation is invalid or already used');
        }

        response.render('invite', { token: request.params.token });
    });
});

app.post('/invite/:token', function (request, response) {
    var name = (request.body.name || '').trim();
    var password = request.body.password || '';

    if (!name || password.length < 3) {
        return response.status(400).send('Name and a password of at least 3 characters are required');
    }

    var invitationSql = `
        SELECT invitationId, agentId, email
        FROM invitations
        WHERE token = ? AND usedAt IS NULL
    `;

    conn.query(invitationSql, [request.params.token], function (lookupError, invitations) {
        if (lookupError) {
            return response.status(500).send('Invitation lookup failed');
        }

        if (invitations.length === 0) {
            return response.status(404).send('Invitation is invalid or already used');
        }

        var invitation = invitations[0];

        createPasswordHash(password, function (hashError, passwordHash) {
            if (hashError) {
                return response.status(500).send('Password setup failed');
            }

            var userSql = `
                INSERT INTO users (name, email, password, role, agentId)
                VALUES (?, ?, ?, 'student', ?)
            `;

            conn.query(userSql, [name, invitation.email, passwordHash, invitation.agentId], function (userError) {
                if (userError) {
                    return response.status(500).send('Student account creation failed');
                }

                var usedSql = `
                    UPDATE invitations
                    SET usedAt = CURRENT_TIMESTAMP
                    WHERE invitationId = ?
                `;

                conn.query(usedSql, [invitation.invitationId], function (usedError) {
                    if (usedError) {
                        return response.status(500).send('Invitation completion failed');
                    }

                    response.redirect('/login');
                });
            });
        });
    });
});

app.get('/logout', function (request, response) {
    request.session.destroy(function (error) {
        if (error) {
            return response.status(500).send('Logout failed');
        }

        response.redirect('/');
    });
});

app.get('/students', requireAgent, function (request, response) {
    var role = request.session.userRole;
    var search = (request.query.q || '').trim();
    var progressStatuses = ['New', 'Documents Required', 'Under Review', 'Offer Received', 'Accepted', 'Completed'];
    var progress = progressStatuses.indexOf(request.query.progress) !== -1 ? request.query.progress : '';
    var programmeId = /^\d+$/.test(request.query.programme || '') ? request.query.programme : '';
    var agentId = role === 'admin' && /^\d+$/.test(request.query.agent || '') ? request.query.agent : '';
    var conditions = ["student.role = 'student'"];
    var filterValues = [];

    if (role === 'agent') {
        conditions.push('student.agentId = ?');
        filterValues.push(request.session.userId);
    }

    if (search) {
        conditions.push('(student.name LIKE ? OR student.email LIKE ?)');
        var searchTerm = '%' + search + '%';
        filterValues.push(searchTerm, searchTerm);
    }

    if (progress) {
        conditions.push(`
            EXISTS (
                SELECT 1 FROM applications AS progressApplication
                WHERE progressApplication.ownerUserId = student.id
                  AND progressApplication.status = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM applications AS newerProgressApplication
                      WHERE newerProgressApplication.ownerUserId = student.id
                        AND (
                            newerProgressApplication.createdAt > progressApplication.createdAt
                            OR (
                                newerProgressApplication.createdAt = progressApplication.createdAt
                                AND newerProgressApplication.applicationId > progressApplication.applicationId
                            )
                        )
                  )
            )
        `);
        filterValues.push(progress);
    }

    if (programmeId) {
        conditions.push(`
            EXISTS (
                SELECT 1 FROM applications AS programmeApplication
                WHERE programmeApplication.ownerUserId = student.id
                  AND programmeApplication.programmeId = ?
            )
        `);
        filterValues.push(programmeId);
    }

    if (agentId) {
        conditions.push('student.agentId = ?');
        filterValues.push(agentId);
    }

    var whereSql = conditions.join(' AND ');
    var currentUserId = request.session.userId;
    var unreadSelect = role === 'admin' ? '0' : `
        (
            SELECT COUNT(*)
            FROM applicationMessages AS unreadMessage
            INNER JOIN applications AS unreadApplication
                ON unreadMessage.applicationId = unreadApplication.applicationId
            LEFT JOIN applicationConversationReads AS unreadRead
                ON unreadRead.applicationId = unreadApplication.applicationId
                AND unreadRead.userId = ?
            WHERE unreadApplication.ownerUserId = student.id
              AND unreadMessage.senderUserId <> ?
              AND (unreadRead.lastReadAt IS NULL OR unreadMessage.createdAt > unreadRead.lastReadAt)
        )
    `;
    var listSelectValues = role === 'admin' ? [] : [currentUserId, currentUserId];
    var listSql = `
        SELECT
            student.id,
            student.name,
            student.email,
            agent.name AS agentName,
            (
                SELECT COUNT(*) FROM applications AS studentApplication
                WHERE studentApplication.ownerUserId = student.id
            ) AS applicationCount,
            (
                SELECT latestApplication.status
                FROM applications AS latestApplication
                WHERE latestApplication.ownerUserId = student.id
                ORDER BY latestApplication.createdAt DESC, latestApplication.applicationId DESC
                LIMIT 1
            ) AS latestStatus,
            (
                SELECT latestProgramme.programmeName
                FROM applications AS latestProgrammeApplication
                INNER JOIN programmes AS latestProgramme
                    ON latestProgrammeApplication.programmeId = latestProgramme.programmeId
                WHERE latestProgrammeApplication.ownerUserId = student.id
                ORDER BY latestProgrammeApplication.createdAt DESC, latestProgrammeApplication.applicationId DESC
                LIMIT 1
            ) AS latestProgrammeName,
            ${unreadSelect} AS unreadCount,
            COALESCE(
                (
                    SELECT MAX(activityMessage.createdAt)
                    FROM applicationMessages AS activityMessage
                    INNER JOIN applications AS activityApplication
                        ON activityMessage.applicationId = activityApplication.applicationId
                    WHERE activityApplication.ownerUserId = student.id
                ),
                (
                    SELECT MAX(activityApplication.createdAt)
                    FROM applications AS activityApplication
                    WHERE activityApplication.ownerUserId = student.id
                )
            ) AS lastActivity
        FROM users AS student
        LEFT JOIN users AS agent
            ON student.agentId = agent.id
        WHERE ${whereSql}
        ORDER BY student.name
    `;

    var summarySql = `
        SELECT
            COUNT(*) AS assignedStudentCount,
            (
                SELECT COUNT(*)
                FROM applications AS summaryApplication
                INNER JOIN users AS summaryStudent
                    ON summaryApplication.ownerUserId = summaryStudent.id
                WHERE summaryStudent.role = 'student'
                  ${role === 'agent' ? 'AND summaryStudent.agentId = ?' : ''}
                  AND summaryApplication.status NOT IN ('Completed', 'Rejected', 'Withdrawn')
            ) AS activeApplicationCount,
            (
                SELECT COUNT(*)
                FROM applications AS attentionApplication
                INNER JOIN users AS attentionStudent
                    ON attentionApplication.ownerUserId = attentionStudent.id
                WHERE attentionStudent.role = 'student'
                  ${role === 'agent' ? 'AND attentionStudent.agentId = ?' : ''}
                  AND attentionApplication.status IN ('New', 'Documents Required')
            ) AS attentionApplicationCount,
            ${role === 'admin' ? '0' : `
                (
                    SELECT COUNT(*)
                    FROM applicationMessages AS summaryMessage
                    INNER JOIN applications AS summaryMessageApplication
                        ON summaryMessage.applicationId = summaryMessageApplication.applicationId
                    INNER JOIN users AS messageStudent
                        ON summaryMessageApplication.ownerUserId = messageStudent.id
                    LEFT JOIN applicationConversationReads AS summaryRead
                        ON summaryRead.applicationId = summaryMessageApplication.applicationId
                        AND summaryRead.userId = ?
                    WHERE messageStudent.role = 'student'
                      AND messageStudent.agentId = ?
                      AND summaryMessage.senderUserId <> ?
                      AND (summaryRead.lastReadAt IS NULL OR summaryMessage.createdAt > summaryRead.lastReadAt)
                )
            `} AS unreadMessageCount
        FROM users AS scopedStudent
        WHERE ${role === 'agent' ? 'scopedStudent.role = \'student\' AND scopedStudent.agentId = ?' : "scopedStudent.role = 'student'"}
    `;
    var summaryValues = [];

    if (role === 'agent') {
        summaryValues.push(currentUserId, currentUserId, currentUserId, currentUserId, currentUserId, currentUserId);
    }

    conn.query(summarySql, summaryValues, function (summaryError, summaryRows) {
        if (summaryError) {
            console.error('Student summary query failed:', summaryError.message);
            return response.status(500).send('Student summary query failed');
        }

        conn.query(listSql, listSelectValues.concat(filterValues), function (listError, students) {
            if (listError) {
                console.error('Student list query failed:', listError.message);
                return response.status(500).send('Student list query failed');
            }

            conn.query('SELECT programmeId, programmeName FROM programmes ORDER BY programmeName', function (programmeError, programmes) {
                if (programmeError) {
                    console.error('Student programme filter query failed:', programmeError.message);
                    return response.status(500).send('Student programme filter query failed');
                }

                var renderStudents = function (agents) {
                    response.render('students', {
                        students: students,
                        summary: summaryRows[0],
                        progressStatuses: progressStatuses,
                        filters: {
                            q: search,
                            progress: progress,
                            programme: programmeId,
                            agent: agentId
                        },
                        programmes: programmes,
                        agents: agents
                    });
                };

                if (role !== 'admin') {
                    return renderStudents([]);
                }

                conn.query("SELECT id, name FROM users WHERE role = 'agent' ORDER BY name", function (agentError, agents) {
                    if (agentError) {
                        console.error('Student agent filter query failed:', agentError.message);
                        return response.status(500).send('Student agent filter query failed');
                    }

                    renderStudents(agents);
                });
            });
        });
    });
});

app.get('/students/new', requireAgent, function (request, response) {
    response.render('studentInvite');
});

app.get('/students/:id([0-9]+)', requireAgent, function (request, response) {
    var studentId = Number(request.params.id);

    if (!Number.isInteger(studentId) || studentId < 1) {
        return response.status(404).send('Student not found');
    }

    var studentSql = `
        SELECT student.id, student.name, student.email, student.role, agent.name AS agentName
        FROM users AS student
        LEFT JOIN users AS agent
            ON student.agentId = agent.id
        WHERE student.id = ? AND student.role = 'student'
    `;
    var studentValues = [studentId];

    if (request.session.userRole === 'agent') {
        studentSql += ' AND student.agentId = ?';
        studentValues.push(request.session.userId);
    }

    conn.query(studentSql, studentValues, function (studentError, students) {
        if (studentError) {
            console.error('Student detail query failed:', studentError.message);
            return response.status(500).send('Student detail query failed');
        }

        if (students.length === 0) {
            return response.status(404).send('Student not found');
        }

        var currentUserId = request.session.userId;
        var unreadSelect = request.session.userRole === 'admin' ? '0' : `
            (
                SELECT COUNT(*)
                FROM applicationMessages AS detailMessage
                LEFT JOIN applicationConversationReads AS detailRead
                    ON detailRead.applicationId = a.applicationId
                    AND detailRead.userId = ?
                WHERE detailMessage.applicationId = a.applicationId
                  AND detailMessage.senderUserId <> ?
                  AND (detailRead.lastReadAt IS NULL OR detailMessage.createdAt > detailRead.lastReadAt)
            )
        `;
        var applicationValues = request.session.userRole === 'admin' ? [studentId] : [currentUserId, currentUserId, studentId];
        var applicationsSql = `
            SELECT a.applicationId, a.status, a.createdAt,
                   p.programmeName, p.provider,
                   ${unreadSelect} AS unreadCount
            FROM applications AS a
            INNER JOIN programmes AS p
                ON a.programmeId = p.programmeId
            WHERE a.ownerUserId = ?
            ORDER BY a.createdAt DESC, a.applicationId DESC
        `;

        conn.query(applicationsSql, applicationValues, function (applicationError, applications) {
            if (applicationError) {
                console.error('Student applications query failed:', applicationError.message);
                return response.status(500).send('Student applications query failed');
            }

            var messagesSql = `
                SELECT m.applicationId, m.messageText, m.createdAt,
                       m.senderUserId, sender.name AS senderName, sender.role AS senderRole,
                       p.programmeName
                FROM applicationMessages AS m
                INNER JOIN applications AS a
                    ON m.applicationId = a.applicationId
                INNER JOIN programmes AS p
                    ON a.programmeId = p.programmeId
                INNER JOIN users AS sender
                    ON m.senderUserId = sender.id
                WHERE a.ownerUserId = ?
                ORDER BY m.createdAt DESC, m.id DESC
                LIMIT 5
            `;

            conn.query(messagesSql, [studentId], function (messageError, messages) {
                if (messageError) {
                    console.error('Student recent messages query failed:', messageError.message);
                    return response.status(500).send('Student recent messages query failed');
                }

                var recommendationSql = `
                    SELECT r.recommendationId, r.reason, r.status, r.studentComment, r.createdAt,
                           p.programmeName, p.provider, p.level
                    FROM programmeRecommendations AS r
                    INNER JOIN programmes AS p ON r.programmeId = p.programmeId
                    WHERE r.studentUserId = ?
                    ORDER BY r.createdAt DESC, r.recommendationId DESC
                `;

                conn.query(recommendationSql, [studentId], function (recommendationError, recommendations) {
                    if (recommendationError) {
                        console.error('Student recommendation query failed:', recommendationError.message);
                        return response.status(500).send('Student recommendation query failed');
                    }

                    var reviewSql = `
                        SELECT r.rating, r.comment, r.createdAt, r.applicationId, p.programmeName
                        FROM agentReviews AS r
                        INNER JOIN applications AS a ON r.applicationId = a.applicationId
                        INNER JOIN programmes AS p ON a.programmeId = p.programmeId
                        WHERE r.studentUserId = ?
                        ORDER BY r.createdAt DESC, r.reviewId DESC
                    `;

                    conn.query(reviewSql, [studentId], function (reviewError, reviews) {
                        if (reviewError) {
                            console.error('Student review query failed:', reviewError.message);
                            return response.status(500).send('Student review query failed');
                        }

                        conn.query(`
                            SELECT programmeId, programmeName, provider, level
                            FROM programmes
                            ORDER BY programmeName
                        `, function (programmeError, programmes) {
                            if (programmeError) {
                                console.error('Student recommendation programme query failed:', programmeError.message);
                                return response.status(500).send('Student recommendation programme query failed');
                            }

                            response.render('studentDetails', {
                                student: students[0],
                                applications: applications,
                                messages: messages,
                                recommendations: recommendations,
                                reviews: reviews,
                                programmes: programmes
                            });
                        });
                    });
                });
            });
        });
    });
});

app.post('/students/:id([0-9]+)/recommendations', requireAgent, function (request, response) {
    if (request.session.userRole !== 'agent') {
        return response.status(403).send('Only agents can create recommendations.');
    }

    var studentId = Number(request.params.id);
    var programmeId = Number(request.body.programmeId);
    var reason = (request.body.reason || '').trim();

    if (!Number.isInteger(studentId) || studentId < 1 || !Number.isInteger(programmeId) || programmeId < 1 || !reason) {
        return response.status(400).send('Student, programme and reason are required.');
    }

    var scopeSql = `
        SELECT id FROM users
        WHERE id = ? AND role = 'student' AND agentId = ?
    `;

    conn.query(scopeSql, [studentId, request.session.userId], function (scopeError, students) {
        if (scopeError) {
            console.error('Recommendation student scope query failed:', scopeError.message);
            return response.status(500).send('Recommendation student scope query failed');
        }

        if (students.length === 0) {
            return response.status(403).send('You can only recommend programmes to assigned students.');
        }

        conn.beginTransaction(function (transactionError) {
            if (transactionError) {
                console.error('Recommendation transaction failed:', transactionError.message);
                return response.status(500).send('Recommendation transaction failed');
            }

            var duplicateSql = `
                SELECT recommendationId FROM programmeRecommendations
                WHERE studentUserId = ? AND programmeId = ?
                FOR UPDATE
            `;

            conn.query(duplicateSql, [studentId, programmeId], function (duplicateError, existing) {
                if (duplicateError) {
                    return rollbackWithError(response, 'Recommendation duplicate query failed', duplicateError);
                }

                if (existing.length > 0) {
                    return conn.rollback(function () {
                        response.status(409).send('This programme has already been recommended to this student.');
                    });
                }

                conn.query('SELECT programmeName FROM programmes WHERE programmeId = ?', [programmeId], function (programmeError, programmes) {
                    if (programmeError) {
                        return rollbackWithError(response, 'Recommendation programme query failed', programmeError);
                    }

                    if (programmes.length === 0) {
                        return conn.rollback(function () {
                            response.status(404).send('Programme not found');
                        });
                    }

                    var insertSql = `
                        INSERT INTO programmeRecommendations
                            (studentUserId, agentUserId, programmeId, reason)
                        VALUES (?, ?, ?, ?)
                    `;

                    conn.query(insertSql, [studentId, request.session.userId, programmeId, reason], function (insertError) {
                        if (insertError) {
                            if (insertError.code === 'ER_DUP_ENTRY') {
                                return conn.rollback(function () {
                                    response.status(409).send('This programme has already been recommended to this student.');
                                });
                            }
                            return rollbackWithError(response, 'Recommendation insert failed', insertError);
                        }

                        insertNotification({
                            recipientUserId: studentId,
                            actorUserId: request.session.userId,
                            type: notificationTypes.NEW_RECOMMENDATION,
                            title: 'New programme recommendation',
                            message: 'Your agent recommended ' + programmes[0].programmeName + '.',
                            linkPath: '/recommendations'
                        }, function (notificationError) {
                            if (notificationError) {
                                return rollbackWithError(response, 'Recommendation notification insert failed', notificationError);
                            }

                            conn.commit(function (commitError) {
                                if (commitError) {
                                    return rollbackWithError(response, 'Recommendation transaction commit failed', commitError);
                                }
                                response.redirect('/students/' + studentId);
                            });
                        });
                    });
                });
            });
        });
    });
});

app.get('/recommendations', requireLogin, function (request, response) {
    if (request.session.userRole !== 'student') {
        return response.status(403).send('Only students can view this page.');
    }

    var sql = `
        SELECT r.recommendationId, r.reason, r.status, r.studentComment, r.createdAt, r.respondedAt,
               p.programmeName, p.provider, p.level, p.location, p.duration,
               agent.name AS agentName
        FROM programmeRecommendations AS r
        INNER JOIN programmes AS p ON r.programmeId = p.programmeId
        INNER JOIN users AS agent ON r.agentUserId = agent.id
        WHERE r.studentUserId = ?
        ORDER BY r.createdAt DESC, r.recommendationId DESC
    `;

    conn.query(sql, [request.session.userId], function (error, recommendations) {
        if (error) {
            console.error('Student recommendation list query failed:', error.message);
            return response.status(500).send('Student recommendation list query failed');
        }

        response.render('recommendations', { recommendations: recommendations });
    });
});

app.get('/notifications', requireLogin, function (request, response) {
    var sql = `
        SELECT notificationId, type, title, message, linkPath, readAt, createdAt
        FROM notifications
        WHERE recipientUserId = ?
        ORDER BY (readAt IS NULL) DESC, createdAt DESC, notificationId DESC
    `;

    conn.query(sql, [request.session.userId], function (error, notifications) {
        if (error) {
            console.error('Notification list query failed:', error.message);
            return response.status(500).send('Notification list query failed');
        }

        response.render('notifications', { notifications: notifications });
    });
});

app.post('/notifications/:id/open', requireLogin, function (request, response) {
    var notificationId = Number(request.params.id);

    if (!Number.isInteger(notificationId) || notificationId < 1) {
        return response.status(404).send('Notification not found');
    }

    conn.query(`
        SELECT linkPath
        FROM notifications
        WHERE notificationId = ? AND recipientUserId = ?
    `, [notificationId, request.session.userId], function (lookupError, notifications) {
        if (lookupError) {
            console.error('Notification open lookup failed:', lookupError.message);
            return response.status(500).send('Notification open lookup failed');
        }

        if (notifications.length === 0) {
            return response.status(404).send('Notification not found');
        }

        conn.query(`
            UPDATE notifications
            SET readAt = CURRENT_TIMESTAMP
            WHERE notificationId = ? AND recipientUserId = ? AND readAt IS NULL
        `, [notificationId, request.session.userId], function (updateError) {
            if (updateError) {
                console.error('Notification read update failed:', updateError.message);
                return response.status(500).send('Notification read update failed');
            }

            response.redirect(notifications[0].linkPath || '/notifications');
        });
    });
});

app.post('/notifications/read-all', requireLogin, function (request, response) {
    conn.query(`
        UPDATE notifications
        SET readAt = CURRENT_TIMESTAMP
        WHERE recipientUserId = ? AND readAt IS NULL
    `, [request.session.userId], function (error) {
        if (error) {
            console.error('Notification read-all update failed:', error.message);
            return response.status(500).send('Notification read-all update failed');
        }

        response.redirect('/notifications');
    });
});

app.post('/recommendations/:id/respond', requireLogin, function (request, response) {
    if (request.session.userRole !== 'student') {
        return response.status(403).send('Only students can respond to recommendations.');
    }

    var recommendationId = Number(request.params.id);
    var status = request.body.status;
    var studentComment = (request.body.studentComment || '').trim();
    var allowedRecommendationStatuses = ['Interested', 'Not Interested', 'Request Changes'];

    if (!Number.isInteger(recommendationId) || recommendationId < 1 || allowedRecommendationStatuses.indexOf(status) === -1) {
        return response.status(400).send('Invalid recommendation response.');
    }

    if (status === 'Request Changes' && !studentComment) {
        return response.status(400).send('A comment is required when requesting changes.');
    }

    conn.beginTransaction(function (transactionError) {
        if (transactionError) {
            return response.status(500).send('Recommendation response transaction failed');
        }

        var lookupSql = `
            SELECT r.status, r.agentUserId, student.name AS studentName
            FROM programmeRecommendations AS r
            INNER JOIN users AS student ON r.studentUserId = student.id
            WHERE r.recommendationId = ? AND r.studentUserId = ?
            FOR UPDATE
        `;

        conn.query(lookupSql, [recommendationId, request.session.userId], function (lookupError, recommendations) {
            if (lookupError) {
                return rollbackWithError(response, 'Recommendation response lookup failed', lookupError);
            }

            if (recommendations.length === 0 || recommendations[0].status !== 'Pending') {
                return conn.rollback(function () {
                    response.status(409).send('This recommendation has already been responded to or is not yours.');
                });
            }

            var updateSql = `
                UPDATE programmeRecommendations
                SET status = ?, studentComment = ?, respondedAt = CURRENT_TIMESTAMP
                WHERE recommendationId = ? AND studentUserId = ? AND status = 'Pending'
            `;

            conn.query(updateSql, [status, studentComment || null, recommendationId, request.session.userId], function (updateError) {
                if (updateError) {
                    return rollbackWithError(response, 'Recommendation response update failed', updateError);
                }

                insertNotification({
                    recipientUserId: recommendations[0].agentUserId,
                    actorUserId: request.session.userId,
                    type: notificationTypes.RECOMMENDATION_RESPONSE,
                    title: 'Recommendation response',
                    message: recommendations[0].studentName + ' responded ' + status + '.',
                    linkPath: '/students/' + request.session.userId
                }, function (notificationError) {
                    if (notificationError) {
                        return rollbackWithError(response, 'Recommendation response notification insert failed', notificationError);
                    }

                    conn.commit(function (commitError) {
                        if (commitError) {
                            return rollbackWithError(response, 'Recommendation response transaction commit failed', commitError);
                        }
                        response.redirect('/recommendations');
                    });
                });
            });
        });
    });
});

app.get('/programmes', function (request, response) {
    var keyword = (request.query.keyword || '').trim();
    var level = (request.query.level || '').trim();
    var location = (request.query.location || '').trim();
    var studyArea = (request.query.studyArea || '').trim();

    var sql = `
        SELECT programmeId, programmeName, provider,
               level, location, duration, studyArea
        FROM programmes
    `;

    var conditions = [];
    var values = [];

    if (keyword) {
        conditions.push(`
            (
                programmeName LIKE ?
                OR provider LIKE ?
                OR level LIKE ?
                OR location LIKE ?
                OR studyArea LIKE ?
            )
        `);

        var searchTerm = '%' + keyword + '%';

        values.push(
            searchTerm,
            searchTerm,
            searchTerm,
            searchTerm,
            searchTerm
        );
    }

    if (level) {
    conditions.push('LOWER(level) LIKE LOWER(?)');
    values.push('%' + level + '%');
    }

    if (location) {
        conditions.push('LOWER(location) LIKE LOWER(?)');
        values.push('%' + location + '%');
    }

    if (studyArea) {
        conditions.push('LOWER(studyArea) LIKE LOWER(?)');
        values.push('%' + studyArea + '%');
    }

    if (conditions.length > 0) {
        sql += ' WHERE ' + conditions.join(' AND ');
    }

    sql += ' ORDER BY programmeName';

    conn.query(sql, values, function (error, results) {
        if (error) {
            console.error('Programme query failed:', error.message);
            return response.status(500).send('Programme query failed');
        }

        loadAgentFavouriteIds(request, 'Programme', results.map(function (programme) {
            return programme.programmeId;
        }), function (favouriteError, favouriteIds) {
            if (favouriteError) {
                console.error('Programme favourites query failed:', favouriteError.message);
                return response.status(500).send('Programme favourites query failed');
            }

            response.render('programmes', {
                programmes: results,
                keyword: keyword,
                filters: {
                    level: level,
                    location: location,
                    studyArea: studyArea
                },
                favouriteProgrammeIds: favouriteIds
            });
        });
    });
});

app.get('/programmes/:id', function (request, response) {
    var programmeId = parseInt(request.params.id, 10);

    if (Number.isNaN(programmeId)) {
        return response.status(404).send('Programme not found');
    }

    var sql = `
        SELECT programmeId, programmeName, provider,
               level, location, duration, studyArea
        FROM programmes
        WHERE programmeId = ?
    `;

    conn.query(sql, [programmeId], function (error, results) {
        if (error) {
            console.error('Programme detail query failed:', error.message);
            return response.status(500).send('Programme detail query failed');
        }

        if (results.length === 0) {
            return response.status(404).send('Programme not found');
        }

        loadAgentFavouriteIds(request, 'Programme', [programmeId], function (favouriteError, favouriteIds) {
            if (favouriteError) {
                console.error('Programme favourite detail query failed:', favouriteError.message);
                return response.status(500).send('Programme favourite detail query failed');
            }

            response.render('programmeDetails', {
                programme: results[0],
                isFavourite: favouriteIds.indexOf(programmeId) !== -1
            });
        });
    });
});

app.post('/favourites/programmes/:programmeId([0-9]+)', requireAgentFavourite, function (request, response) {
    var programmeId = Number(request.params.programmeId);
    var redirectPath = request.query.from === 'list' ? '/programmes' : '/programmes/' + programmeId;
    toggleFavourite(request, response, 'Programme', programmeId, 'programmes', 'programmeId', redirectPath);
});

var allowedApplicationStatuses = [
    'New',
    'Submitted',
    'Documents Required',
    'Under Review',
    'Offer Received',
    'Accepted',
    'Completed',
    'Decision Made',
    'Rejected',
    'Withdrawn'
];

app.get('/applications', requireLogin, function (request, response) {
    var role = request.session.userRole;
    var search = (request.query.q || '').trim();
    var programmeSearch = (request.query.programme || '').trim();
    var provider = (request.query.provider || '').trim();
    var status = allowedApplicationStatuses.indexOf(request.query.status) !== -1 ? request.query.status : '';
    var fromDate = /^\d{4}-\d{2}-\d{2}$/.test(request.query.from || '') ? request.query.from : '';
    var toDate = /^\d{4}-\d{2}-\d{2}$/.test(request.query.to || '') ? request.query.to : '';
    var agentId = role === 'admin' && /^\d+$/.test(request.query.agent || '') ? request.query.agent : '';
    var filterConditions = [];
    var filterValues = [];

    if (role === 'student') {
        filterConditions.push('a.ownerUserId = ?');
        filterValues.push(request.session.userId);
    } else if (role === 'agent') {
        filterConditions.push(`
            a.ownerUserId IN (
                SELECT id FROM users WHERE agentId = ?
            )
        `);
        filterValues.push(request.session.userId);
    }

    if (search) {
        filterConditions.push(`
            (
                a.studentLabel LIKE ?
                OR owner.name LIKE ?
                OR owner.email LIKE ?
            )
        `);
        var searchTerm = '%' + search + '%';
        filterValues.push(searchTerm, searchTerm, searchTerm);
    }

    if (programmeSearch) {
        filterConditions.push('p.programmeName LIKE ?');
        filterValues.push('%' + programmeSearch + '%');
    }

    if (provider) {
        filterConditions.push('p.provider = ?');
        filterValues.push(provider);
    }

    if (fromDate) {
        filterConditions.push('a.createdAt >= ?');
        filterValues.push(fromDate);
    }

    if (toDate) {
        filterConditions.push('a.createdAt < DATE_ADD(?, INTERVAL 1 DAY)');
        filterValues.push(toDate);
    }

    if (agentId) {
        filterConditions.push('owner.agentId = ?');
        filterValues.push(agentId);
    }

    var listConditions = filterConditions.slice();
    var listValues = filterValues.slice();

    if (status) {
        listConditions.push('a.status = ?');
        listValues.push(status);
    }

    var joins = `
        FROM applications AS a
        INNER JOIN programmes AS p
            ON a.programmeId = p.programmeId
        LEFT JOIN users AS owner
            ON a.ownerUserId = owner.id
        LEFT JOIN users AS assignedAgent
            ON owner.agentId = assignedAgent.id
    `;
    var countSql = `
        SELECT a.status, COUNT(*) AS statusCount
        ${joins}
        ${filterConditions.length ? 'WHERE ' + filterConditions.join(' AND ') : ''}
        GROUP BY a.status
    `;

    conn.query(countSql, filterValues, function (countError, countRows) {
        if (countError) {
            console.error('Application count query failed:', countError.message);
            return response.status(500).send('Application count query failed');
        }

        var statusCounts = {};
        var totalCount = 0;
        countRows.forEach(function (row) {
            statusCounts[row.status] = row.statusCount;
            totalCount += row.statusCount;
        });

        var unreadSelect = '0 AS unreadCount';
        var unreadValues = [];

        if (role === 'student' || role === 'agent') {
            unreadSelect = `
                (
                    SELECT COUNT(*)
                    FROM applicationMessages AS m
                    LEFT JOIN applicationConversationReads AS r
                        ON r.applicationId = a.applicationId
                        AND r.userId = ?
                    WHERE m.applicationId = a.applicationId
                      AND m.senderUserId <> ?
                      AND (r.lastReadAt IS NULL OR m.createdAt > r.lastReadAt)
                ) AS unreadCount
            `;
            unreadValues.push(request.session.userId, request.session.userId);
        }

        var listSql = `
            SELECT a.applicationId,
                   a.studentLabel,
                   a.status,
                   a.createdAt,
                   p.programmeName,
                   p.provider,
                   owner.name AS ownerName,
                   owner.email AS ownerEmail,
                   assignedAgent.name AS agentName,
                   ${unreadSelect}
            ${joins}
            ${listConditions.length ? 'WHERE ' + listConditions.join(' AND ') : ''}
            ORDER BY a.createdAt DESC, a.applicationId DESC
        `;

        conn.query(listSql, unreadValues.concat(listValues), function (listError, applications) {
            if (listError) {
                console.error('Application list query failed:', listError.message);
                return response.status(500).send('Application list query failed');
            }

            var providerSql = `
                SELECT DISTINCT provider
                FROM programmes
                ORDER BY provider
            `;

            conn.query(providerSql, function (providerError, providers) {
                if (providerError) {
                    console.error('Application provider filter query failed:', providerError.message);
                    return response.status(500).send('Application provider filter query failed');
                }

                var renderApplications = function (agents) {
                    response.render('applications', {
                        applications: applications,
                        statusCounts: statusCounts,
                        totalCount: totalCount,
                        statuses: allowedApplicationStatuses,
                        filters: {
                            q: search,
                            programme: programmeSearch,
                            provider: provider,
                            status: status,
                            from: fromDate,
                            to: toDate,
                            agent: agentId
                        },
                        providers: providers,
                        agents: agents
                    });
                };

                if (role !== 'admin') {
                    return renderApplications([]);
                }

                conn.query(
                    "SELECT id, name FROM users WHERE role = 'agent' ORDER BY name",
                    function (agentError, agents) {
                        if (agentError) {
                            console.error('Application agent filter query failed:', agentError.message);
                            return response.status(500).send('Application agent filter query failed');
                        }

                        renderApplications(agents);
                    }
                );
            });
        });
    });
});

app.get('/applications/:id([0-9]+)', requireLogin, function (request, response) {
    var applicationId = Number(request.params.id);

    if (!Number.isInteger(applicationId) || applicationId < 1) {
        return response.status(404).send('Application not found');
    }

    var applicationSql = `
        SELECT a.applicationId,
               a.studentLabel,
               a.status,
               a.createdAt,
               p.programmeName,
               p.provider,
               p.level,
               p.location,
               p.duration,
               p.studyArea,
               owner.name AS ownerName,
               owner.email AS ownerEmail,
               owner.role AS ownerRole,
               assignedAgent.name AS agentName
        FROM applications AS a
        INNER JOIN programmes AS p
            ON a.programmeId = p.programmeId
        LEFT JOIN users AS owner
            ON a.ownerUserId = owner.id
        LEFT JOIN users AS assignedAgent
            ON owner.agentId = assignedAgent.id
        WHERE a.applicationId = ?
    `;

    var applicationValues = [applicationId];

    if (request.session.userRole === 'student') {
        applicationSql += ' AND a.ownerUserId = ?';
        applicationValues.push(request.session.userId);
    } else if (request.session.userRole === 'agent') {
        applicationSql += `
            AND a.ownerUserId IN (
                SELECT id FROM users WHERE agentId = ?
            )
        `;
        applicationValues.push(request.session.userId);
    } else if (request.session.userRole !== 'admin') {
        return response.status(403).send('You do not have permission to view this application.');
    }

    conn.query(applicationSql, applicationValues, function (applicationError, applications) {
        if (applicationError) {
            console.error('Application detail query failed:', applicationError.message);
            return response.status(500).send('Application detail query failed');
        }

        if (applications.length === 0) {
            return response.status(404).send('Application not found');
        }

        var historySql = `
            SELECT h.oldStatus, h.newStatus, h.createdAt, u.name AS changedByName
            FROM applicationStatusHistory AS h
            INNER JOIN users AS u
                ON h.changedByUserId = u.id
            WHERE h.applicationId = ?
            ORDER BY h.createdAt DESC, h.id DESC
        `;

        conn.query(historySql, [applicationId], function (historyError, statusHistory) {
            if (historyError) {
                console.error('Application status history query failed:', historyError.message);
                return response.status(500).send('Application status history query failed');
            }

            var messageSql = `
                SELECT m.messageText, m.createdAt, u.name AS senderName, u.role AS senderRole
                FROM applicationMessages AS m
                INNER JOIN users AS u
                    ON m.senderUserId = u.id
                WHERE m.applicationId = ?
                ORDER BY m.createdAt ASC, m.id ASC
            `;

            conn.query(messageSql, [applicationId], function (messageError, messages) {
                if (messageError) {
                    console.error('Application message query failed:', messageError.message);
                    return response.status(500).send('Application message query failed');
                }

                var reviewSql = `
                     SELECT rating, comment, createdAt
                     FROM agentReviews
                     WHERE applicationId = ?
                 `;

                conn.query(reviewSql, [applicationId], function (reviewError, reviews) {
                     if (reviewError) {
                         console.error('Application review query failed:', reviewError.message);
                         return response.status(500).send('Application review query failed');
                     }

                    var documentSql = `
                        SELECT d.documentId, d.documentType, d.originalFileName,
                               d.mimeType, d.fileSize, d.reviewStatus, d.reviewNote,
                               d.uploadedAt, uploader.name AS uploadedByName,
                               reviewer.name AS reviewedByName, d.reviewedAt
                        FROM applicationDocuments AS d
                        INNER JOIN users AS uploader ON d.uploadedByUserId = uploader.id
                        LEFT JOIN users AS reviewer ON d.reviewedByUserId = reviewer.id
                        WHERE d.applicationId = ?
                        ORDER BY d.uploadedAt DESC, d.documentId DESC
                    `;

                    conn.query(documentSql, [applicationId], function (documentError, applicationDocuments) {
                        if (documentError) {
                            console.error('Application document query failed:', documentError.message);
                            return response.status(500).send('Application document query failed');
                        }

                        function renderApplication() {
                            response.render('applicationDetails', {
                                application: applications[0],
                                messages: messages,
                                statusHistory: statusHistory,
                                statuses: allowedApplicationStatuses,
                                review: reviews[0] || null,
                                applicationDocuments: applicationDocuments,
                                documentTypes: allowedDocumentTypes
                            });
                        }

                        if (request.session.userRole === 'admin') {
                            return renderApplication();
                        }

                        var readSql = `
                            INSERT INTO applicationConversationReads (applicationId, userId)
                            VALUES (?, ?)
                            ON DUPLICATE KEY UPDATE lastReadAt = CURRENT_TIMESTAMP
                        `;

                        conn.query(readSql, [applicationId, request.session.userId], function (readError) {
                            if (readError) {
                                console.error('Application conversation read update failed:', readError.message);
                                return response.status(500).send('Application conversation read update failed');
                            }

                            renderApplication();
                        });
                    });
                });
            });
        });
    });
});

app.get('/applications/:id/documents/:documentId', requireLogin, requireApplicationScope, function (request, response) {
    var documentId = Number(request.params.documentId);
    if (!Number.isInteger(documentId) || documentId < 1) {
        return response.status(404).send('Document not found');
    }

    conn.query(`
        SELECT storedFileName, originalFileName, mimeType
        FROM applicationDocuments
        WHERE documentId = ? AND applicationId = ?
    `, [documentId, request.scopedApplication.applicationId], function (error, documents) {
        if (error) {
            console.error('Application document download lookup failed:', error.message);
            return response.status(500).send('Application document download lookup failed');
        }
        if (documents.length === 0) {
            return response.status(404).send('Document not found');
        }

        var document = documents[0];
        var filePath = path.join(applicationDocumentsDir, document.storedFileName);
        response.download(filePath, document.originalFileName, { headers: { 'Content-Type': document.mimeType } }, function (downloadError) {
            if (downloadError && !response.headersSent) {
                console.error('Application document download failed:', downloadError.message);
                response.status(downloadError.code === 'ENOENT' ? 404 : 500).send('Document download failed');
            }
        });
    });
});

app.post('/applications/:id/documents', requireLogin, requireStudentApplicationScope, handleDocumentUpload, function (request, response) {
    var documentType = request.body.documentType;
    if (allowedDocumentTypes.indexOf(documentType) === -1 || !request.file) {
        return removeUploadedFile(request.file, function () {
            response.status(400).send('A valid document type and file are required.');
        });
    }

    conn.beginTransaction(function (transactionError) {
        if (transactionError) {
            return removeUploadedFile(request.file, function () {
                response.status(500).send('Document upload transaction failed');
            });
        }

        conn.query(`
            INSERT INTO applicationDocuments
                (applicationId, uploadedByUserId, documentType, originalFileName,
                 storedFileName, mimeType, fileSize, reviewStatus)
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Uploaded')
        `, [
            request.scopedApplication.applicationId,
            request.session.userId,
            documentType,
            request.file.originalname,
            request.file.filename,
            request.file.mimetype,
            request.file.size
        ], function (insertError) {
            if (insertError) {
                return rollbackAndRemoveFile(response, 'Application document insert failed', insertError, request.file);
            }

            var recipients = [];
            if (request.scopedApplication.agentId) {
                recipients.push(request.scopedApplication.agentId);
            }

            function insertNext(index) {
                if (index === recipients.length) {
                    return conn.commit(function (commitError) {
                        if (commitError) {
                            return rollbackAndRemoveFile(response, 'Document upload transaction commit failed', commitError, request.file);
                        }
                        response.redirect('/applications/' + request.scopedApplication.applicationId);
                    });
                }

                insertNotification({
                    recipientUserId: recipients[index],
                    actorUserId: request.session.userId,
                    type: notificationTypes.DOCUMENT_UPLOADED,
                    title: 'New application document',
                    message: request.scopedApplication.studentName + ' uploaded a ' + documentType + ' document.',
                    linkPath: '/applications/' + request.scopedApplication.applicationId
                }, function (notificationError) {
                    if (notificationError) {
                        return rollbackAndRemoveFile(response, 'Document upload notification failed', notificationError, request.file);
                    }
                    insertNext(index + 1);
                });
            }

            insertNext(0);
        });
    });
});

app.post('/applications/:id/documents/:documentId/review', requireAgent, requireApplicationScope, function (request, response) {
    var documentId = Number(request.params.documentId);
    var reviewStatus = request.body.reviewStatus;
    var reviewNote = (request.body.reviewNote || '').trim();
    if (!Number.isInteger(documentId) || documentId < 1 || allowedDocumentReviewStatuses.indexOf(reviewStatus) === -1) {
        return response.status(400).send('Invalid document review.');
    }

    conn.beginTransaction(function (transactionError) {
        if (transactionError) {
            return response.status(500).send('Document review transaction failed');
        }

        conn.query(`
            SELECT d.documentType, d.reviewStatus, d.reviewNote
            FROM applicationDocuments AS d
            WHERE d.documentId = ? AND d.applicationId = ?
            FOR UPDATE
        `, [documentId, request.scopedApplication.applicationId], function (lookupError, documents) {
            if (lookupError) {
                return rollbackWithError(response, 'Application document review lookup failed', lookupError);
            }
            if (documents.length === 0) {
                return conn.rollback(function () { response.status(404).send('Document not found'); });
            }

            var currentReviewNote = (documents[0].reviewNote || '').trim();
            if (documents[0].reviewStatus === reviewStatus && currentReviewNote === reviewNote) {
                return conn.rollback(function () {
                    response.redirect('/applications/' + request.scopedApplication.applicationId);
                });
            }

            conn.query(`
                UPDATE applicationDocuments
                SET reviewStatus = ?, reviewNote = ?, reviewedByUserId = ?, reviewedAt = CURRENT_TIMESTAMP
                WHERE documentId = ? AND applicationId = ?
            `, [reviewStatus, reviewNote || null, request.session.userId, documentId, request.scopedApplication.applicationId], function (updateError) {
                if (updateError) {
                    return rollbackWithError(response, 'Application document review update failed', updateError);
                }

                var studentId = request.scopedApplication.ownerUserId;
                if (!studentId) {
                    return conn.commit(function (commitError) {
                        if (commitError) return rollbackWithError(response, 'Document review commit failed', commitError);
                        response.redirect('/applications/' + request.scopedApplication.applicationId);
                    });
                }

                insertNotification({
                    recipientUserId: studentId,
                    actorUserId: request.session.userId,
                    type: notificationTypes.DOCUMENT_REVIEW_UPDATED,
                    title: 'Application document reviewed',
                    message: 'Your ' + documents[0].documentType + ' document is marked ' + reviewStatus + '.',
                    linkPath: '/applications/' + request.scopedApplication.applicationId
                }, function (notificationError) {
                    if (notificationError) {
                        return rollbackWithError(response, 'Document review notification failed', notificationError);
                    }
                    conn.commit(function (commitError) {
                        if (commitError) return rollbackWithError(response, 'Document review commit failed', commitError);
                        response.redirect('/applications/' + request.scopedApplication.applicationId);
                    });
                });
            });
        });
    });
});

app.post('/applications/:id/review', requireLogin, function (request, response) {
    if (request.session.userRole !== 'student') {
        return response.status(403).send('Only students can submit reviews.');
    }

    var applicationId = Number(request.params.id);
    var rating = Number(request.body.rating);
    var comment = (request.body.comment || '').trim();

    if (!Number.isInteger(applicationId) || applicationId < 1 || !Number.isInteger(rating) || rating < 1 || rating > 5 || !comment) {
        return response.status(400).send('A rating from 1 to 5 and a comment are required.');
    }

    var applicationSql = `
        SELECT a.applicationId, a.ownerUserId, a.status, student.agentId
        FROM applications AS a
        INNER JOIN users AS student ON a.ownerUserId = student.id
        WHERE a.applicationId = ? AND a.ownerUserId = ?
    `;

    conn.query(applicationSql, [applicationId, request.session.userId], function (applicationError, applications) {
        if (applicationError) {
            console.error('Review application lookup failed:', applicationError.message);
            return response.status(500).send('Review application lookup failed');
        }

        if (applications.length === 0) {
            return response.status(403).send('You can only review your own application.');
        }

        if (applications[0].status !== 'Completed') {
            return response.status(403).send('Reviews are available only for completed applications.');
        }

        if (!applications[0].agentId) {
            return response.status(409).send('This application has no assigned agent to review.');
        }

        conn.beginTransaction(function (transactionError) {
            if (transactionError) {
                return response.status(500).send('Agent review transaction failed');
            }

            var insertSql = `
                INSERT INTO agentReviews (applicationId, studentUserId, agentUserId, rating, comment)
                VALUES (?, ?, ?, ?, ?)
            `;

            conn.query(insertSql, [applicationId, request.session.userId, applications[0].agentId, rating, comment], function (insertError) {
                if (insertError) {
                    if (insertError.code === 'ER_DUP_ENTRY') {
                        return conn.rollback(function () {
                            response.status(409).send('This application already has a review.');
                        });
                    }
                    return rollbackWithError(response, 'Agent review insert failed', insertError);
                }

                insertNotification({
                    recipientUserId: applications[0].agentId,
                    actorUserId: request.session.userId,
                    type: notificationTypes.NEW_AGENT_REVIEW,
                    title: 'New student feedback',
                    message: 'Student submitted a ' + rating + '-star review.',
                    linkPath: '/students/' + request.session.userId
                }, function (notificationError) {
                    if (notificationError) {
                        return rollbackWithError(response, 'Agent review notification insert failed', notificationError);
                    }

                    conn.commit(function (commitError) {
                        if (commitError) {
                            return rollbackWithError(response, 'Agent review transaction commit failed', commitError);
                        }
                        response.redirect('/applications/' + applicationId);
                    });
                });
            });
        });
    });
});

app.post('/applications/:id/messages', requireLogin, function (request, response) {
    var applicationId = Number(request.params.id);
    var messageText = (request.body.messageText || '').trim();

    if (!Number.isInteger(applicationId) || applicationId < 1 || !messageText) {
        return response.status(400).send('A non-empty message is required');
    }

    if (request.session.userRole !== 'student' && request.session.userRole !== 'agent') {
        return response.status(403).send('Only students and agents can send messages.');
    }

    var scopeSql = `
        SELECT a.applicationId
        FROM applications AS a
        WHERE a.applicationId = ?
    `;
    var scopeValues = [applicationId];

    if (request.session.userRole === 'student') {
        scopeSql += ' AND a.ownerUserId = ?';
        scopeValues.push(request.session.userId);
    } else {
        scopeSql += `
            AND a.ownerUserId IN (
                SELECT id FROM users WHERE agentId = ?
            )
        `;
        scopeValues.push(request.session.userId);
    }

    conn.query(scopeSql, scopeValues, function (scopeError, applications) {
        if (scopeError) {
            console.error('Application message scope query failed:', scopeError.message);
            return response.status(500).send('Application message scope query failed');
        }

        if (applications.length === 0) {
            return response.status(404).send('Application not found');
        }

        var messageSql = `
            INSERT INTO applicationMessages (applicationId, senderUserId, messageText)
            VALUES (?, ?, ?)
        `;

        conn.query(messageSql, [applicationId, request.session.userId, messageText], function (messageError) {
            if (messageError) {
                console.error('Application message insert failed:', messageError.message);
                return response.status(500).send('Application message insert failed');
            }

            response.redirect('/applications/' + applicationId);
        });
    });
});

app.get('/applications/new', requireLogin, function (request, response) {
    var sql = `
        SELECT programmeId, programmeName
        FROM programmes
        ORDER BY programmeName
    `;

    conn.query(sql, function (error, results) {
        if (error) {
            console.error('Application programme query failed:', error.message);
            return response.status(500).send('Application programme query failed');
        }

        response.render('applicationForm', {
            programmes: results,
            application: null
        });
    });
});

app.post('/applications', requireLogin, function (request, response) {
    var studentLabel = (request.body.studentLabel || '').trim();
    var programmeId = parseInt(request.body.programmeId, 10);

    if (!studentLabel || Number.isNaN(programmeId)) {
        return response.redirect('/applications/new');
    }

    var sql = `
            INSERT INTO applications
                (ownerUserId, studentLabel, programmeId, status)
            VALUES (?, ?, ?, ?)
        `;

    conn.query(
        sql,
        [request.session.userId, studentLabel, programmeId, 'New'],
        function (error) {
            if (error) {
                console.error('Application insert failed:', error.message);
                return response.status(500).send('Application insert failed');
            }

            response.redirect('/applications');
        }
    );
});

app.get('/applications/:id/edit', requireLogin, function (request, response) {
    if (['student', 'agent', 'admin'].indexOf(request.session.userRole) === -1) return response.status(403).send('You do not have permission to edit applications.');
    var id = Number(request.params.id), sql = "SELECT a.applicationId,a.studentLabel,a.programmeId,a.status FROM applications a WHERE a.applicationId=? AND a.status='Submitted'", values = [id];
    if (request.session.userRole === 'student') { sql += ' AND a.ownerUserId=?'; values.push(request.session.userId); }
    else if (request.session.userRole === 'agent') { sql += ' AND a.ownerUserId IN (SELECT id FROM users WHERE agentId=?)'; values.push(request.session.userId); }
    conn.query(sql, values, function (error, rows) { if (error) return response.status(500).send('Application lookup failed'); if (!rows.length) return response.status(404).send('Application not found or is not submitted'); conn.query('SELECT programmeId,programmeName FROM programmes ORDER BY programmeName', function (e, programmes) { if (e) return response.status(500).send('Application programme query failed'); response.render('applicationForm', { programmes: programmes, application: rows[0] }); }); });
});

app.post('/applications/:id/edit', requireLogin, function (request, response) {
    if (['student', 'agent', 'admin'].indexOf(request.session.userRole) === -1) return response.status(403).send('You do not have permission to edit applications.');
    var id = Number(request.params.id), label = (request.body.studentLabel || '').trim(), programmeId = parseInt(request.body.programmeId, 10);
    if (!Number.isInteger(id) || !label || Number.isNaN(programmeId)) return response.status(400).send('Invalid application details');
    var sql = "UPDATE applications SET studentLabel=?, programmeId=? WHERE applicationId=? AND status='Submitted'", values = [label, programmeId, id];
    if (request.session.userRole === 'student') { sql += ' AND ownerUserId=?'; values.push(request.session.userId); } else if (request.session.userRole === 'agent') { sql += ' AND ownerUserId IN (SELECT id FROM users WHERE agentId=?)'; values.push(request.session.userId); }
    conn.query(sql, values, function (error, result) { if (error) return response.status(500).send('Application update failed'); if (!result.affectedRows) return response.status(404).send('Application not found or is not submitted'); response.redirect('/applications'); });
});

app.post('/applications/:id/delete', requireLogin, function (request, response) {
    if (['student', 'agent', 'admin'].indexOf(request.session.userRole) === -1) return response.status(403).send('You do not have permission to delete applications.');
    var id = Number(request.params.id), sql = "DELETE FROM applications WHERE applicationId=? AND status='Submitted'", values = [id];
    if (request.session.userRole === 'student') { sql += ' AND ownerUserId=?'; values.push(request.session.userId); } else if (request.session.userRole === 'agent') { sql += ' AND ownerUserId IN (SELECT id FROM users WHERE agentId=?)'; values.push(request.session.userId); }
    conn.query(sql, values, function (error, result) { if (error) return response.status(500).send('Application deletion failed'); if (!result.affectedRows) return response.status(404).send('Application not found or is not submitted'); response.redirect('/applications'); });
});

app.post('/applications/:id/status', requireAgent, function (request, response) {
    var applicationId = Number(request.params.id);
    var status = request.body.status;
    var messageText = (request.body.messageText || '').trim();

    if (!Number.isInteger(applicationId) || applicationId < 1) {
        return response.status(400).send('Invalid application ID');
    }

    if (allowedApplicationStatuses.indexOf(status) === -1) {
        return response.status(400).send('Invalid application status');
    }

    conn.beginTransaction(function (transactionError) {
        if (transactionError) {
            return response.status(500).send('Application status transaction failed');
        }

        var lookupSql = `
            SELECT a.status, a.ownerUserId,
                   owner.agentId, owner.name AS studentName,
                   p.programmeName
            FROM applications AS a
            LEFT JOIN users AS owner ON a.ownerUserId = owner.id
            INNER JOIN programmes AS p ON a.programmeId = p.programmeId
            WHERE a.applicationId = ?
        `;
        var lookupValues = [applicationId];

        if (request.session.userRole === 'agent') {
            lookupSql += `
                AND a.ownerUserId IN (
                    SELECT id FROM users WHERE agentId = ?
                )
            `;
            lookupValues.push(request.session.userId);
        }

        lookupSql += ' FOR UPDATE';

        conn.query(lookupSql, lookupValues, function (lookupError, applications) {
            if (lookupError) {
                return rollbackWithError(response, 'Application status lookup failed', lookupError);
            }

            if (applications.length === 0) {
                return conn.rollback(function () {
                    response.status(404).send('Application not found');
                });
            }

            var application = applications[0];
            var previousStatus = application.status;
            var statusChanged = previousStatus !== status;
            var updateSql = `
                UPDATE applications
                SET status = ?
                WHERE applicationId = ?
            `;
            var updateValues = [status, applicationId];

            if (request.session.userRole === 'agent') {
                updateSql += `
                    AND ownerUserId IN (
                        SELECT id FROM users WHERE agentId = ?
                    )
                `;
                updateValues.push(request.session.userId);
            }

            conn.query(updateSql, updateValues, function (updateError) {
                if (updateError) {
                    return rollbackWithError(response, 'Application status update failed', updateError);
                }

                function insertStatusMessage(next) {
                    if (!messageText) {
                        return next();
                    }

                    conn.query(`
                        INSERT INTO applicationMessages (applicationId, senderUserId, messageText)
                        VALUES (?, ?, ?)
                    `, [applicationId, request.session.userId, messageText], function (messageError) {
                        if (messageError) {
                            return rollbackWithError(response, 'Status message insert failed', messageError);
                        }
                        next();
                    });
                }

                function insertStatusHistory(next) {
                    if (!statusChanged) {
                        return next();
                    }

                    conn.query(`
                        INSERT INTO applicationStatusHistory
                            (applicationId, oldStatus, newStatus, changedByUserId)
                        VALUES (?, ?, ?, ?)
                    `, [applicationId, previousStatus, status, request.session.userId], function (historyError) {
                        if (historyError) {
                            return rollbackWithError(response, 'Application status history insert failed', historyError);
                        }
                        next();
                    });
                }

                function insertStatusNotifications(next) {
                    if (!statusChanged) {
                        return next();
                    }

                    var notifications = [];
                    if (application.ownerUserId) {
                        notifications.push({
                            recipientUserId: application.ownerUserId,
                            actorUserId: request.session.userId,
                            type: notificationTypes.APPLICATION_STATUS_CHANGED,
                            title: 'Application status updated',
                            message: 'Your application for ' + application.programmeName + ' is now ' + status + '.',
                            linkPath: '/applications/' + applicationId
                        });
                    }

                    if (
                        request.session.userRole === 'admin' &&
                        application.agentId &&
                        application.agentId !== request.session.userId
                    ) {
                        notifications.push({
                            recipientUserId: application.agentId,
                            actorUserId: request.session.userId,
                            type: notificationTypes.APPLICATION_STATUS_CHANGED,
                            title: 'Application status updated',
                            message: application.studentName + "'s application for " + application.programmeName + ' is now ' + status + '.',
                            linkPath: '/applications/' + applicationId
                        });
                    }

                    var index = 0;
                    function insertNext() {
                        if (index === notifications.length) {
                            return next();
                        }
                        insertNotification(notifications[index++], function (notificationError) {
                            if (notificationError) {
                                return rollbackWithError(response, 'Application status notification insert failed', notificationError);
                            }
                            insertNext();
                        });
                    }
                    insertNext();
                }

                insertStatusMessage(function () {
                    insertStatusHistory(function () {
                        insertStatusNotifications(function () {
                            conn.commit(function (commitError) {
                                if (commitError) {
                                    return rollbackWithError(response, 'Application status transaction commit failed', commitError);
                                }
                                response.redirect('/applications');
                            });
                        });
                    });
                });
            });
        });
    });
});

app.get('/training', requireAgent, function (request, response) {
    var requestedCategory = (request.query.category || '').trim();
    var categorySql = `
        SELECT DISTINCT category
        FROM trainingModules
        WHERE category IS NOT NULL AND category <> ''
        ORDER BY category
    `;

    conn.query(categorySql, function (categoryError, categoryRows) {
        if (categoryError) {
            console.error('Training category query failed:', categoryError.message);
            return response.status(500).send('Training category query failed');
        }

        var categories = categoryRows.map(function (row) { return row.category; });
        var category = categories.indexOf(requestedCategory) !== -1 ? requestedCategory : '';
        var sql = `
            SELECT m.moduleId, m.title, m.description,
                   m.category, m.level, m.durationMinutes,
                   tp.completedAt
            FROM trainingModules AS m
            LEFT JOIN trainingProgress AS tp
                ON tp.moduleId = m.moduleId
                AND tp.userId = ?
        `;
        var values = [request.session.userId];

        if (category) {
            sql += ' WHERE m.category = ?';
            values.push(category);
        }

        sql += ' ORDER BY m.moduleId';

        conn.query(sql, values, function (error, results) {
            if (error) {
                console.error('Training query failed:', error.message);
                return response.status(500).send('Training query failed');
            }

            response.render('training', {
                trainingModules: results,
                categories: categories,
                selectedCategory: category
            });
        });
    });
});

app.get('/training/:id([0-9]+)', requireAgent, function (request, response) {
    var moduleId = Number(request.params.id);

    if (!Number.isInteger(moduleId) || moduleId < 1) {
        return response.status(404).send('Training module not found');
    }

    var sql = `
         SELECT m.moduleId, m.title, m.description,
             m.category, m.level, m.durationMinutes,
             tp.completedAt
        FROM trainingModules AS m
        LEFT JOIN trainingProgress AS tp
            ON tp.moduleId = m.moduleId
            AND tp.userId = ?
        WHERE m.moduleId = ?
    `;

    conn.query(sql, [request.session.userId, moduleId], function (error, results) {
        if (error) {
            console.error('Training detail query failed:', error.message);
            return response.status(500).send('Training detail query failed');
        }

        if (results.length === 0) {
            return response.status(404).send('Training module not found');
        }

        var sectionsSql = `
            SELECT sectionId, moduleId, sectionTitle, sectionContent, sortOrder
            FROM trainingModuleSections
            WHERE moduleId = ?
            ORDER BY sortOrder ASC, sectionId ASC
        `;

        conn.query(sectionsSql, [moduleId], function (sectionsError, sections) {
            if (sectionsError) {
                console.error('Training sections query failed:', sectionsError.message);
                return response.status(500).send('Training sections query failed');
            }

            var resourcesSql = `
                SELECT resourceId, moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder
                FROM trainingResources
                WHERE moduleId = ?
                ORDER BY sortOrder ASC, resourceId ASC
            `;

            conn.query(resourcesSql, [moduleId], function (resourcesError, resources) {
                if (resourcesError) {
                    console.error('Training resource query failed:', resourcesError.message);
                    return response.status(500).send('Training resource query failed');
                }

                var quizAvailabilitySql = `
                    SELECT questionId
                    FROM trainingQuizQuestions
                    WHERE moduleId = ?
                    ORDER BY sortOrder ASC, questionId ASC
                `;

                conn.query(quizAvailabilitySql, [moduleId], function (quizError, quizQuestions) {
                    if (quizError) {
                        console.error('Training quiz availability query failed:', quizError.message);
                        return response.status(500).send('Training quiz availability query failed');
                    }

                    response.render('trainingDetails', {
                        trainingModule: results[0],
                        sections: sections,
                        trainingResources: resources.map(normalizeContentResource).filter(Boolean),
                        hasQuiz: quizQuestions.length > 0
                    });
                });
            });
        });
    });
});

app.get('/training/:id([0-9]+)/quiz', requireAgent, function (request, response) {
    var moduleId = Number(request.params.id);

    if (!Number.isInteger(moduleId) || moduleId < 1) {
        return response.status(404).send('Training module not found');
    }

    var moduleSql = `
        SELECT moduleId, title, category, level, durationMinutes
        FROM trainingModules
        WHERE moduleId = ?
    `;

    conn.query(moduleSql, [moduleId], function (moduleError, modules) {
        if (moduleError) {
            console.error('Training quiz module query failed:', moduleError.message);
            return response.status(500).send('Training quiz module query failed');
        }

        if (modules.length === 0) {
            return response.status(404).send('Training module not found');
        }

        var questionSql = `
            SELECT questionId, questionText, optionA, optionB, optionC, optionD, sortOrder
            FROM trainingQuizQuestions
            WHERE moduleId = ?
            ORDER BY sortOrder ASC, questionId ASC
        `;

        conn.query(questionSql, [moduleId], function (questionError, questions) {
            if (questionError) {
                console.error('Training quiz question query failed:', questionError.message);
                return response.status(500).send('Training quiz question query failed');
            }

            if (questions.length === 0) {
                return response.redirect('/training/' + moduleId);
            }

            response.render('trainingQuiz', {
                trainingModule: modules[0],
                questions: questions
            });
        });
    });
});

app.post('/training/:id([0-9]+)/quiz', requireAgent, function (request, response) {
    var moduleId = Number(request.params.id);

    if (!Number.isInteger(moduleId) || moduleId < 1) {
        return response.status(404).send('Training module not found');
    }

    var questionSql = `
        SELECT questionId, correctOption
        FROM trainingQuizQuestions
        WHERE moduleId = ?
        ORDER BY sortOrder ASC, questionId ASC
    `;

    conn.query(questionSql, [moduleId], function (questionError, questions) {
        if (questionError) {
            console.error('Training quiz scoring query failed:', questionError.message);
            return response.status(500).send('Training quiz scoring query failed');
        }

        if (questions.length === 0) {
            return response.redirect('/training/' + moduleId);
        }

        var score = 0;
        questions.forEach(function (question) {
            var answer = request.body['question_' + question.questionId];
            if (answer === question.correctOption) {
                score += 1;
            }
        });

        var totalQuestions = questions.length;
        var passed = score / totalQuestions >= 0.75;
        var attemptSql = `
            INSERT INTO trainingQuizAttempts
                (userId, moduleId, score, totalQuestions, passed)
            VALUES (?, ?, ?, ?, ?)
        `;

        conn.query(
            attemptSql,
            [request.session.userId, moduleId, score, totalQuestions, passed],
            function (attemptError) {
                if (attemptError) {
                    console.error('Training quiz attempt insert failed:', attemptError.message);
                    return response.status(500).send('Training quiz attempt insert failed');
                }

                var completeModule = function () {
                    response.render('trainingQuizResult', {
                        trainingModuleId: moduleId,
                        score: score,
                        totalQuestions: totalQuestions,
                        passed: passed
                    });
                };

                if (!passed) {
                    return completeModule();
                }

                var progressSql = `
                    SELECT progressId
                    FROM trainingProgress
                    WHERE userId = ? AND moduleId = ?
                `;

                conn.query(progressSql, [request.session.userId, moduleId], function (progressError, progressRows) {
                    if (progressError) {
                        console.error('Training progress lookup failed:', progressError.message);
                        return response.status(500).send('Training progress lookup failed');
                    }

                    if (progressRows.length > 0) {
                        return completeModule();
                    }

                    var insertProgressSql = `
                        INSERT INTO trainingProgress (userId, moduleId)
                        VALUES (?, ?)
                    `;

                    conn.query(insertProgressSql, [request.session.userId, moduleId], function (insertProgressError) {
                        if (insertProgressError) {
                            console.error('Training progress save failed:', insertProgressError.message);
                            return response.status(500).send('Training progress save failed');
                        }

                        completeModule();
                    });
                });
            }
        );
    });
});

app.post('/training/:id/complete', requireAgent, function (request, response) {
    var moduleId = Number(request.params.id);

    if (!Number.isInteger(moduleId) || moduleId < 1) {
        return response.status(404).send('Training module not found');
    }

    var quizCheckSql = `
        SELECT COUNT(*) AS questionCount
        FROM trainingQuizQuestions
        WHERE moduleId = ?
    `;

    conn.query(quizCheckSql, [moduleId], function (quizError, quizRows) {
        if (quizError) {
            console.error('Training quiz availability check failed:', quizError.message);
            return response.status(500).send('Training quiz availability check failed');
        }

        if (quizRows[0].questionCount > 0) {
            return response.status(409).send('Complete the knowledge check to finish this module.');
        }

        var sql = `
            INSERT INTO trainingProgress (userId, moduleId)
            VALUES (?, ?)
            ON DUPLICATE KEY UPDATE progressId = progressId
        `;

        conn.query(
            sql,
            [request.session.userId, moduleId],
            function (error) {
                if (error) {
                    console.error('Training progress save failed:', error.message);
                    return response.status(500).send('Training progress save failed');
                }

                response.redirect('/training');
            }
        );
    });
});

app.post('/admin/knowledge/files/upload', requireAdmin, handleKnowledgeFileUpload, function (request, response) {
    var metadata = validateKnowledgeFileMetadata(request, false);
    if (metadata.errors.length > 0) {
        return removeUploadedFile(request.file, function () {
            response.status(400).send(metadata.errors.join(' '));
        });
    }

    conn.beginTransaction(function (transactionError) {
        if (transactionError) {
            return removeUploadedFile(request.file, function () {
                response.status(500).send('Knowledge file upload transaction failed');
            });
        }

        var duplicateSql = metadata.provider
            ? `SELECT fileId FROM knowledgeFiles
               WHERE status = 'Current' AND provider = ? AND resourceType = ? AND title = ?
               FOR UPDATE`
            : `SELECT fileId FROM knowledgeFiles
               WHERE status = 'Current' AND provider IS NULL AND resourceType = ? AND title = ?
               FOR UPDATE`;
        var duplicateValues = metadata.provider
            ? [metadata.provider, metadata.resourceType, metadata.title]
            : [metadata.resourceType, metadata.title];

        conn.query(duplicateSql, duplicateValues, function (duplicateError, currentRows) {
            if (duplicateError) {
                return rollbackAndRemoveFile(response, 'Knowledge file duplicate check failed', duplicateError, request.file);
            }
            if (currentRows.length > 0) {
                return conn.rollback(function () {
                    removeUploadedFile(request.file, function () {
                        response.status(409).send('A current version already exists. Use Replace to upload a new version.');
                    });
                });
            }

            conn.query(`
                INSERT INTO knowledgeFiles
                    (title, description, country, provider, fileType, fileUrl,
                     sourceSystem, sourceRecordId, sourceUpdatedAt, resourceType,
                     originalFileName, storedFileName, mimeType, fileSize, versionLabel,
                     status, uploadedByUserId, uploadedAt)
                VALUES (?, ?, NULL, ?, ?, NULL, NULL, NULL, NULL, ?, ?, ?, ?, ?, ?, 'Current', ?, CURRENT_TIMESTAMP)
            `, [
                metadata.title,
                metadata.description || null,
                metadata.provider,
                knowledgeFileType(request.file),
                metadata.resourceType,
                request.file.originalname,
                request.file.filename,
                request.file.mimetype,
                request.file.size,
                metadata.versionLabel,
                request.session.userId
            ], function (insertError, result) {
                if (insertError) {
                    return rollbackAndRemoveFile(response, 'Knowledge file insert failed', insertError, request.file);
                }

                conn.commit(function (commitError) {
                    if (commitError) {
                        return rollbackAndRemoveFile(response, 'Knowledge file upload commit failed', commitError, request.file);
                    }
                    response.redirect('/knowledge/files/' + result.insertId);
                });
            });
        });
    });
});

app.post('/admin/knowledge/files/:fileId/archive', requireAdmin, function (request, response) {
    var fileId = Number(request.params.fileId);
    if (!Number.isInteger(fileId) || fileId < 1) {
        return response.status(400).send('Invalid Knowledge file ID.');
    }

    conn.beginTransaction(function (transactionError) {
        if (transactionError) return response.status(500).send('Knowledge file archive transaction failed');
        conn.query(`
            SELECT fileId, status
            FROM knowledgeFiles
            WHERE fileId = ?
            FOR UPDATE
        `, [fileId], function (lookupError, rows) {
            if (lookupError) return rollbackWithError(response, 'Knowledge file archive lookup failed', lookupError);
            if (rows.length === 0) return conn.rollback(function () { response.status(404).send('Knowledge file not found'); });
            if (rows[0].status !== 'Current') return conn.rollback(function () { response.status(409).send('Only current Knowledge files can be archived.'); });

            conn.query(`UPDATE knowledgeFiles SET status = 'Archived' WHERE fileId = ?`, [fileId], function (updateError) {
                if (updateError) return rollbackWithError(response, 'Knowledge file archive failed', updateError);
                conn.commit(function (commitError) {
                    if (commitError) return rollbackWithError(response, 'Knowledge file archive commit failed', commitError);
                    response.redirect('/knowledge/files/' + fileId);
                });
            });
        });
    });
});

app.post('/admin/knowledge/files/:fileId/replace', requireAdmin, handleKnowledgeFileUpload, function (request, response) {
    var fileId = Number(request.params.fileId);
    if (!Number.isInteger(fileId) || fileId < 1) {
        return removeUploadedFile(request.file, function () { response.status(400).send('Invalid Knowledge file ID.'); });
    }

    conn.beginTransaction(function (transactionError) {
        if (transactionError) {
            return removeUploadedFile(request.file, function () { response.status(500).send('Knowledge file replacement transaction failed'); });
        }

        conn.query(`
            SELECT fileId, title, description, country, provider, resourceType, status
            FROM knowledgeFiles
            WHERE fileId = ?
            FOR UPDATE
        `, [fileId], function (lookupError, rows) {
            if (lookupError) return rollbackAndRemoveFile(response, 'Knowledge file replacement lookup failed', lookupError, request.file);
            if (rows.length === 0) {
                return conn.rollback(function () { removeUploadedFile(request.file, function () { response.status(404).send('Knowledge file not found'); }); });
            }
            if (rows[0].status !== 'Current') {
                return conn.rollback(function () { removeUploadedFile(request.file, function () { response.status(409).send('Only current Knowledge files can be replaced.'); }); });
            }

            var current = rows[0];
            request.body.resourceGroup = current.provider ? 'provider' : 'general';
            request.body.provider = current.provider || '';
            request.body.resourceType = current.resourceType;
            request.body.title = current.title;
            request.body.description = request.body.description || current.description || '';
            var metadata = validateKnowledgeFileMetadata(request, false);
            if (metadata.errors.length > 0) {
                return rollbackAndRemoveFile(response, metadata.errors.join(' '), new Error('Invalid replacement metadata'), request.file);
            }

            var duplicateSql = metadata.provider
                ? `SELECT fileId FROM knowledgeFiles
                   WHERE status = 'Current' AND fileId <> ? AND provider = ? AND resourceType = ? AND title = ?
                   FOR UPDATE`
                : `SELECT fileId FROM knowledgeFiles
                   WHERE status = 'Current' AND fileId <> ? AND provider IS NULL AND resourceType = ? AND title = ?
                   FOR UPDATE`;
            var duplicateValues = metadata.provider
                ? [fileId, metadata.provider, metadata.resourceType, metadata.title]
                : [fileId, metadata.resourceType, metadata.title];

            conn.query(duplicateSql, duplicateValues, function (duplicateError, duplicateRows) {
                if (duplicateError) return rollbackAndRemoveFile(response, 'Knowledge file replacement duplicate check failed', duplicateError, request.file);
                if (duplicateRows.length > 0) {
                    return conn.rollback(function () {
                        removeUploadedFile(request.file, function () {
                            response.status(409).send('A current version already exists for this resource.');
                        });
                    });
                }

                conn.query(`UPDATE knowledgeFiles SET status = 'Archived' WHERE fileId = ?`, [fileId], function (archiveError) {
                    if (archiveError) return rollbackAndRemoveFile(response, 'Knowledge file replacement archive failed', archiveError, request.file);
                    conn.query(`
                        INSERT INTO knowledgeFiles
                            (title, description, country, provider, fileType, fileUrl,
                             sourceSystem, sourceRecordId, sourceUpdatedAt, resourceType,
                             originalFileName, storedFileName, mimeType, fileSize, versionLabel,
                             status, uploadedByUserId, uploadedAt)
                            VALUES (?, ?, ?, ?, ?, NULL, NULL, NULL, NULL, ?, ?, ?, ?, ?, ?, 'Current', ?, CURRENT_TIMESTAMP)
                    `, [
                        metadata.title,
                        metadata.description || null,
                        current.country,
                        metadata.provider,
                        knowledgeFileType(request.file),
                        metadata.resourceType,
                        request.file.originalname,
                        request.file.filename,
                        request.file.mimetype,
                        request.file.size,
                        metadata.versionLabel,
                        request.session.userId
                    ], function (insertError, result) {
                        if (insertError) return rollbackAndRemoveFile(response, 'Knowledge file replacement insert failed', insertError, request.file);
                        conn.commit(function (commitError) {
                            if (commitError) return rollbackAndRemoveFile(response, 'Knowledge file replacement commit failed', commitError, request.file);
                            response.redirect('/knowledge/files/' + result.insertId);
                        });
                    });
                });
            });
        });
    });
});

app.get('/knowledge', requireKnowledgeAccess, function (request, response) {
    var keyword = (request.query.q || request.query.keyword || '').trim();
    var category = (request.query.category || '').trim();

    var sql = `
        SELECT articleId, title, category, content, sourceLabel, updatedAt
        FROM knowledgeArticles
    `;

    var conditions = [];
    var values = [];

    if (keyword) {
        conditions.push('(title LIKE ? OR category LIKE ? OR content LIKE ?)');
        var searchTerm = '%' + keyword + '%';
        values.push(searchTerm, searchTerm, searchTerm);
    }

    if (category) {
        conditions.push('category = ?');
        values.push(category);
    }

    if (conditions.length > 0) {
        sql += ' WHERE ' + conditions.join(' AND ');
    }

    sql += ' ORDER BY updatedAt DESC, articleId DESC';

    conn.query(sql, values, function (error, results) {
        if (error) {
            console.error('Knowledge query failed:', error.message);
            return response.status(500).send('Knowledge query failed');
        }

        var categorySql = `
            SELECT category, COUNT(*) AS articleCount
            FROM knowledgeArticles
            GROUP BY category
            ORDER BY category
        `;

        conn.query(categorySql, function (categoryError, categories) {
            if (categoryError) {
                console.error('Knowledge category query failed:', categoryError.message);
                return response.status(500).send('Knowledge category query failed');
            }

            loadAgentFavouriteIds(request, 'KnowledgeArticle', results.map(function (article) {
                return article.articleId;
            }), function (favouriteError, favouriteIds) {
                if (favouriteError) {
                    console.error('Knowledge favourites query failed:', favouriteError.message);
                    return response.status(500).send('Knowledge favourites query failed');
                }

                response.render('knowledge', {
                    articles: results,
                    categories: categories,
                    keyword: keyword,
                    selectedCategory: category,
                    favouriteArticleIds: favouriteIds
                });
            });
        });
    });
});

app.get('/knowledge/:id([0-9]+)', requireKnowledgeAccess, function (request, response) {
    var articleId = Number(request.params.id);

    if (!Number.isInteger(articleId) || articleId < 1) {
        return response.status(404).send('Knowledge article not found');
    }

    var sql = `
        SELECT articleId, title, category, content, sourceLabel, updatedAt
        FROM knowledgeArticles
        WHERE articleId = ?
    `;

    conn.query(sql, [articleId], function (error, results) {
        if (error) {
            console.error('Knowledge article detail query failed:', error.message);
            return response.status(500).send('Knowledge article detail query failed');
        }

        if (results.length === 0) {
            return response.status(404).send('Knowledge article not found');
        }

        var resourcesSql = `
            SELECT resourceId, articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder
            FROM knowledgeResources
            WHERE articleId = ?
            ORDER BY sortOrder ASC, resourceId ASC
        `;

        conn.query(resourcesSql, [articleId], function (resourcesError, resources) {
            if (resourcesError) {
                console.error('Knowledge resource query failed:', resourcesError.message);
                return response.status(500).send('Knowledge resource query failed');
            }

            loadAgentFavouriteIds(request, 'KnowledgeArticle', [articleId], function (favouriteError, favouriteIds) {
                if (favouriteError) {
                    console.error('Knowledge favourite detail query failed:', favouriteError.message);
                    return response.status(500).send('Knowledge favourite detail query failed');
                }

                response.render('knowledgeDetails', {
                    article: results[0],
                    knowledgeResources: resources.map(normalizeContentResource).filter(Boolean),
                    isFavourite: favouriteIds.indexOf(articleId) !== -1
                });
            });
        });
    });
});

app.post('/favourites/knowledge/:articleId([0-9]+)', requireAgentFavourite, function (request, response) {
    var articleId = Number(request.params.articleId);
    var redirectPath = request.query.from === 'list' ? '/knowledge' : '/knowledge/' + articleId;
    toggleFavourite(request, response, 'KnowledgeArticle', articleId, 'knowledgeArticles', 'articleId', redirectPath);
});

app.get('/favourites', requireAgentFavourite, function (request, response) {
    conn.query(`
        SELECT f.favouriteId, f.itemId, f.createdAt,
               p.programmeName, p.provider, p.level, p.location
        FROM favourites AS f
        INNER JOIN programmes AS p ON f.itemId = p.programmeId
        WHERE f.userId = ? AND f.itemType = 'Programme'
        ORDER BY f.createdAt DESC, f.favouriteId DESC
    `, [request.session.userId], function (programmeError, programmes) {
        if (programmeError) {
            console.error('Favourite programmes query failed:', programmeError.message);
            return response.status(500).send('Favourite programmes query failed');
        }

        conn.query(`
            SELECT f.favouriteId, f.itemId, f.createdAt,
                   a.title, a.category
            FROM favourites AS f
            INNER JOIN knowledgeArticles AS a ON f.itemId = a.articleId
            WHERE f.userId = ? AND f.itemType = 'KnowledgeArticle'
            ORDER BY f.createdAt DESC, f.favouriteId DESC
        `, [request.session.userId], function (articleError, articles) {
            if (articleError) {
                console.error('Favourite Knowledge query failed:', articleError.message);
                return response.status(500).send('Favourite Knowledge query failed');
            }

            response.render('favourites', {
                programmes: programmes,
                articles: articles
            });
        });
    });
});

app.get('/knowledge/faqs', requireKnowledgeAccess, function (request, response) {
    var keyword = (request.query.q || '').trim();
    var country = (request.query.country || '').trim();
    var provider = (request.query.provider || '').trim();
    var category = (request.query.category || '').trim();

    var sql = `
        SELECT faqId, question, answer, country, provider, category, updatedAt
        FROM knowledgeFaqs
    `;
    var conditions = [];
    var values = [];

    if (keyword) {
        conditions.push('(question LIKE ? OR answer LIKE ? OR provider LIKE ? OR category LIKE ?)');
        var searchTerm = '%' + keyword + '%';
        values.push(searchTerm, searchTerm, searchTerm, searchTerm);
    }

    if (country) {
        conditions.push('country = ?');
        values.push(country);
    }

    if (provider) {
        conditions.push('provider = ?');
        values.push(provider);
    }

    if (category) {
        conditions.push('category = ?');
        values.push(category);
    }

    if (conditions.length > 0) {
        sql += ' WHERE ' + conditions.join(' AND ');
    }

    sql += ' ORDER BY updatedAt DESC, faqId DESC';

    conn.query(sql, values, function (error, faqs) {
        if (error) {
            console.error('Knowledge FAQ query failed:', error.message);
            return response.status(500).send('Knowledge FAQ query failed');
        }

        var filterSql = `
            SELECT DISTINCT country, provider, category
            FROM knowledgeFaqs
            ORDER BY country, provider, category
        `;

        conn.query(filterSql, function (filterError, filterRows) {
            if (filterError) {
                console.error('Knowledge FAQ filter query failed:', filterError.message);
                return response.status(500).send('Knowledge FAQ filter query failed');
            }

            response.render('knowledgeFaqs', {
                faqs: faqs,
                countries: filterRows.filter(function (row) { return row.country; }).map(function (row) { return row.country; }).filter(function (value, index, values) { return values.indexOf(value) === index; }),
                providers: filterRows.filter(function (row) { return row.provider; }).map(function (row) { return row.provider; }).filter(function (value, index, values) { return values.indexOf(value) === index; }),
                categories: filterRows.filter(function (row) { return row.category; }).map(function (row) { return row.category; }).filter(function (value, index, values) { return values.indexOf(value) === index; }),
                keyword: keyword,
                selectedCountry: country,
                selectedProvider: provider,
                selectedCategory: category
            });
        });
    });
});

app.get('/knowledge/faqs/:id([0-9]+)', requireKnowledgeAccess, function (request, response) {
    var faqId = Number(request.params.id);

    if (!Number.isInteger(faqId) || faqId < 1) {
        return response.status(404).send('FAQ not found');
    }

    var sql = `
        SELECT faqId, question, answer, country, provider, category, updatedAt
        FROM knowledgeFaqs
        WHERE faqId = ?
    `;

    conn.query(sql, [faqId], function (error, results) {
        if (error) {
            console.error('Knowledge FAQ detail query failed:', error.message);
            return response.status(500).send('Knowledge FAQ detail query failed');
        }

        if (results.length === 0) {
            return response.status(404).send('FAQ not found');
        }

        response.render('knowledgeFaqDetails', {
            faq: results[0]
        });
    });
});

app.get('/knowledge/files', requireKnowledgeAccess, function (request, response) {
    var keyword = (request.query.q || '').trim();
    var country = (request.query.country || '').trim();
    var provider = (request.query.provider || '').trim();
    var fileType = (request.query.fileType || '').trim();
    var showArchived = request.session.userRole === 'admin' && request.query.includeArchived === '1';

    var sql = `
        SELECT fileId, title, description, country, provider, fileType, fileUrl, updatedAt,
               sourceSystem, sourceUpdatedAt, resourceType, originalFileName,
               storedFileName, mimeType, fileSize, versionLabel, status, uploadedAt
        FROM knowledgeFiles
    `;
    var conditions = showArchived ? [] : ["status = 'Current'"];
    var values = [];

    if (keyword) {
        conditions.push('(title LIKE ? OR description LIKE ? OR provider LIKE ? OR fileType LIKE ?)');
        var searchTerm = '%' + keyword + '%';
        values.push(searchTerm, searchTerm, searchTerm, searchTerm);
    }

    if (country) {
        conditions.push('country = ?');
        values.push(country);
    }

    if (provider) {
        conditions.push('provider = ?');
        values.push(provider);
    }

    if (fileType) {
        conditions.push('fileType = ?');
        values.push(fileType);
    }

    if (conditions.length > 0) {
        sql += ' WHERE ' + conditions.join(' AND ');
    }

    sql += ' ORDER BY updatedAt DESC, fileId DESC';

    conn.query(sql, values, function (error, files) {
        if (error) {
            console.error('Knowledge file query failed:', error.message);
            return response.status(500).send('Knowledge file query failed');
        }

        var filterSql = `
            SELECT DISTINCT country, provider, fileType
            FROM knowledgeFiles
            ORDER BY country, provider, fileType
        `;

        conn.query(filterSql, function (filterError, filterRows) {
            if (filterError) {
                console.error('Knowledge file filter query failed:', filterError.message);
                return response.status(500).send('Knowledge file filter query failed');
            }

            response.render('knowledgeFiles', {
                files: files,
                providerResources: files.filter(function (file) { return file.provider; }),
                generalResources: files.filter(function (file) { return !file.provider; }),
                countries: filterRows.filter(function (row) { return row.country; }).map(function (row) { return row.country; }).filter(function (value, index, values) { return values.indexOf(value) === index; }),
                providers: filterRows.filter(function (row) { return row.provider; }).map(function (row) { return row.provider; }).filter(function (value, index, values) { return values.indexOf(value) === index; }),
                fileTypes: filterRows.filter(function (row) { return row.fileType; }).map(function (row) { return row.fileType; }).filter(function (value, index, values) { return values.indexOf(value) === index; }),
                keyword: keyword,
                selectedCountry: country,
                selectedProvider: provider,
                selectedFileType: fileType,
                isAdmin: request.session.userRole === 'admin',
                showArchived: showArchived
            });
        });
    });
});

app.get('/knowledge/files/:id([0-9]+)', requireKnowledgeAccess, function (request, response) {
    var fileId = Number(request.params.id);

    if (!Number.isInteger(fileId) || fileId < 1) {
        return response.status(404).send('Knowledge file not found');
    }

    var sql = `
        SELECT fileId, title, description, country, provider, fileType, fileUrl, updatedAt,
               sourceSystem, sourceUpdatedAt, resourceType, originalFileName,
               storedFileName, mimeType, fileSize, versionLabel, status, uploadedAt
        FROM knowledgeFiles
        WHERE fileId = ?
    `;

    conn.query(sql, [fileId], function (error, results) {
        if (error) {
            console.error('Knowledge file detail query failed:', error.message);
            return response.status(500).send('Knowledge file detail query failed');
        }

        if (results.length === 0) {
            return response.status(404).send('Knowledge file not found');
        }

        if (results[0].status === 'Archived' && request.session.userRole !== 'admin') {
            return response.status(403).send('Archived Knowledge files are available to Admin only.');
        }

        response.render('knowledgeFileDetails', {
            file: results[0],
            isAdmin: request.session.userRole === 'admin'
        });
    });
});

app.get('/knowledge/files/:fileId/download', requireKnowledgeAccess, function (request, response) {
    var fileId = Number(request.params.fileId);
    if (!Number.isInteger(fileId) || fileId < 1) {
        return response.status(400).send('Invalid Knowledge file ID.');
    }

    conn.query(`
        SELECT fileId, originalFileName, storedFileName, fileUrl, status
        FROM knowledgeFiles
        WHERE fileId = ?
    `, [fileId], function (error, rows) {
        if (error) {
            console.error('Knowledge file download lookup failed:', error.message);
            return response.status(500).send('Knowledge file download lookup failed');
        }
        if (rows.length === 0) return response.status(404).send('Knowledge file not found');
        if (rows[0].status === 'Archived' && request.session.userRole !== 'admin') {
            return response.status(403).send('Archived Knowledge files are available to Admin only.');
        }

        var file = rows[0];
        if (file.storedFileName) {
            if (path.basename(file.storedFileName) !== file.storedFileName) {
                return response.status(404).send('Knowledge file not found');
            }
            var storedPath = path.join(knowledgeFilesDir, file.storedFileName);
            return response.download(storedPath, file.originalFileName || file.storedFileName, function (downloadError) {
                if (downloadError && !response.headersSent) response.status(downloadError.code === 'ENOENT' ? 404 : 500).send('Knowledge file download failed');
            });
        }

        try {
            var externalUrl = new URL(file.fileUrl || '');
            if (externalUrl.protocol !== 'https:') throw new Error('Unsupported external URL');
            return response.redirect(externalUrl.toString());
        } catch (urlError) {
            return response.status(404).send('Knowledge file is not available');
        }
    });
});

app.listen(port, function() {
    console.log('Node app is running on port ' + port);
});
