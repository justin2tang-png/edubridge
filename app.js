var express = require('express');
var app = express();
var conn = require('./dbConfig');
var crypto = require('crypto');
var session = require('express-session');

app.set('view engine', 'ejs');

app.use('/public', express.static('public'));
app.use(express.urlencoded({ extended: false }));
app.use(session({
    secret: process.env.SESSION_SECRET || 'edubridge-local-session',
    resave: false,
    saveUninitialized: false
}));

app.use(function (request, response, next) {
    response.locals.loggedin = request.session.loggedin;
    response.locals.username = request.session.username;
    response.locals.userRole = request.session.userRole;
    next();
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

function requireAdmin(request, response, next) {
    if (!request.session.loggedin) {
        return response.redirect('/login');
    }

    if (request.session.userRole !== 'admin') {
        return response.status(403).send('You do not have permission to view this page.');
    }

    next();
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

                response.render('admin', {
                    ...results[0],
                    users: users,
                    trainingModules: trainingModules,
                    knowledgeArticles: knowledgeArticles
                });
            });
        });
    });
});
});

function scoreProgramme(programme, preferences) {
    var score = 0;

    if (
        preferences.level &&
        programme.level.toLowerCase().includes(preferences.level.toLowerCase())
    ) {
        score += 1;
    }

    if (
        preferences.location &&
        programme.location.toLowerCase().includes(preferences.location.toLowerCase())
    ) {
        score += 1;
    }

    if (
        preferences.studyArea &&
        programme.studyArea.toLowerCase().includes(preferences.studyArea.toLowerCase())
    ) {
        score += 1;
    }

    return score;
}

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

                console.log('User record inserted');
                response.redirect('/login');
            }
        );
    });
});

app.post('/auth', function (request, response) {
    var username = request.body.username;
    var password = request.body.password;

    console.log('Auth Post action is called');
    console.log('Username received:', username);

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
            console.log('The user is not registered');
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

                    console.log('Successful authentication');

                    return response.redirect('/membersOnly');
                }

                console.log('Wrong password');
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

        if (role === 'agent') {
            var trainingSql = `
                SELECT COUNT(*) AS completedTrainingCount
                FROM trainingProgress
                WHERE userId = ?
            `;

            return conn.query(trainingSql, [request.session.userId], function (trainingError, trainingRows) {
                if (trainingError) {
                    console.error('Dashboard training query failed:', trainingError.message);
                    return response.status(500).send('Dashboard training query failed');
                }

                response.render('membersOnly', {
                    dashboard: {
                        role: role,
                        applicationTotal: applicationTotal,
                        applicationStatusCounts: applicationStatusCounts,
                        completedTrainingCount: trainingRows[0].completedTrainingCount
                    }
                });
            });
        }

        response.render('membersOnly', {
            dashboard: {
                role: role,
                applicationTotal: applicationTotal,
                applicationStatusCounts: applicationStatusCounts
            }
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
    var sql = `
        SELECT
            student.id,
            student.name,
            student.email,
            agent.name AS agentName
        FROM users AS student
        LEFT JOIN users AS agent
            ON student.agentId = agent.id
        WHERE student.role = 'student'
    `;

    var values = [];

    if (request.session.userRole === 'agent') {
        sql += ' AND student.agentId = ?';
        values.push(request.session.userId);
    }

    sql += ' ORDER BY student.id';

    conn.query(sql, values, function (error, results) {
        if (error) {
            console.error('Student list query failed:', error.message);
            return response.status(500).send('Student list query failed');
        }

        response.render('students', { students: results });
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

    var preferences = {
            level: level,
            location: location,
            studyArea: studyArea
        };

    results.forEach(function (programme) {
        programme.matchScore = scoreProgramme(programme, preferences);
    });

    results.sort(function (first, second) {
        return second.matchScore - first.matchScore;
    });

    response.render('programmes', {
        programmes: results,
        keyword: keyword,
        filters: {
            level: level,
            location: location,
            studyArea: studyArea
            }
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

        response.render('programmeDetails', {
            programme: results[0]
        });
    });
});

app.get('/applications', requireLogin, function (request, response) {
    var sql = `
        SELECT a.applicationId,
               a.studentLabel,
               a.status,
               a.createdAt,
               p.programmeName
        FROM applications AS a
        INNER JOIN programmes AS p
            ON a.programmeId = p.programmeId
    `;

    var values = [];

    if (request.session.userRole === 'student') {
        sql += ' WHERE a.ownerUserId = ?';
        values.push(request.session.userId);
    } else if (request.session.userRole === 'agent') {
        sql += `
            WHERE a.ownerUserId IN (
                SELECT id FROM users WHERE agentId = ?
            )
        `;
        values.push(request.session.userId);
    }

    sql += ' ORDER BY a.createdAt DESC';

    conn.query(sql, values, function (error, results) {
        if (error) {
            console.error('Application list query failed:', error.message);
            return response.status(500).send('Application list query failed');
        }

        response.render('applications', {
            applications: results
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

            console.log('Application record inserted');
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

    var allowedStatuses = [
        'New',
        'Submitted',
        'Under Review',
        'Documents Required',
        'Decision Made'
    ];

    if (!Number.isInteger(applicationId) || applicationId < 1) {
        return response.status(400).send('Invalid application ID');
    }

    if (allowedStatuses.indexOf(status) === -1) {
        return response.status(400).send('Invalid application status');
    }

    var sql = `
        UPDATE applications
        SET status = ?
        WHERE applicationId = ?
    `;

    var values = [status, applicationId];

    if (request.session.userRole === 'agent') {
        sql += `
            AND ownerUserId IN (
                SELECT id FROM users WHERE agentId = ?
            )
        `;
        values.push(request.session.userId);
    }

    conn.query(
        sql,
        values,
        function (error) {
            if (error) {
                console.error('Application status update failed:', error.message);
                return response.status(500).send('Application status update failed');
            }

            response.redirect('/applications');
        }
    );
});

app.get('/training', requireAgent, function (request, response) {
    var sql = `
        SELECT m.moduleId, m.title, m.description, tp.completedAt
        FROM trainingModules AS m
        LEFT JOIN trainingProgress AS tp
            ON tp.moduleId = m.moduleId
            AND tp.userId = ?
        ORDER BY m.moduleId
    `;

    conn.query(sql, [request.session.userId], function (error, results) {
        if (error) {
            console.error('Training query failed:', error.message);
            return response.status(500).send('Training query failed');
        }

        response.render('training', {
            trainingModules: results
        });
    });
});

app.post('/training/:id/complete', requireAgent, function (request, response) {
    var moduleId = Number(request.params.id);

    if (!Number.isInteger(moduleId) || moduleId < 1) {
        return response.status(404).send('Training module not found');
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

app.get('/knowledge', requireLogin, function (request, response) {
    var keyword = (request.query.keyword || '').trim();

    var sql = `
        SELECT articleId, title, category, content, sourceLabel, updatedAt
        FROM knowledgeArticles
    `;

    var values = [];

    if (keyword) {
        sql += `
            WHERE title LIKE ?
               OR category LIKE ?
               OR content LIKE ?
        `;

        var searchTerm = '%' + keyword + '%';
        values.push(searchTerm, searchTerm, searchTerm);
    }

    sql += ' ORDER BY title';

    conn.query(sql, values, function (error, results) {
        if (error) {
            console.error('Knowledge query failed:', error.message);
            return response.status(500).send('Knowledge query failed');
        }

        response.render('knowledge', {
            articles: results,
            keyword: keyword
        });
    });
});

app.listen(port, function() {
    console.log('Node app is running on port ' + port);
});
