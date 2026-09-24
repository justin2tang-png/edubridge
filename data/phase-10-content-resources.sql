CREATE TABLE IF NOT EXISTS trainingResources (
    resourceId INT NOT NULL AUTO_INCREMENT,
    moduleId INT NOT NULL,
    resourceType VARCHAR(30) NOT NULL,
    title VARCHAR(200) NOT NULL,
    resourceUrl VARCHAR(500) NOT NULL,
    sourceLabel VARCHAR(160) NULL,
    sortOrder INT NOT NULL DEFAULT 1,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (resourceId),
    KEY idx_training_resources_module_sort (moduleId, sortOrder, resourceId),
    CONSTRAINT fk_training_resources_module
        FOREIGN KEY (moduleId) REFERENCES trainingModules(moduleId) ON DELETE CASCADE,
    CONSTRAINT chk_training_resources_type
        CHECK (resourceType IN ('YouTube', 'Official Link'))
);

CREATE TABLE IF NOT EXISTS knowledgeResources (
    resourceId INT NOT NULL AUTO_INCREMENT,
    articleId INT NOT NULL,
    resourceType VARCHAR(30) NOT NULL,
    title VARCHAR(200) NOT NULL,
    resourceUrl VARCHAR(500) NOT NULL,
    sourceLabel VARCHAR(160) NULL,
    sortOrder INT NOT NULL DEFAULT 1,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (resourceId),
    KEY idx_knowledge_resources_article_sort (articleId, sortOrder, resourceId),
    CONSTRAINT fk_knowledge_resources_article
        FOREIGN KEY (articleId) REFERENCES knowledgeArticles(articleId) ON DELETE CASCADE,
    CONSTRAINT chk_knowledge_resources_type
        CHECK (resourceType IN ('YouTube', 'Official Link'))
);
