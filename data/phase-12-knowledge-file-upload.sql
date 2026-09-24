-- EduBridge Phase 12: private Knowledge File Library uploads and versions.
-- Run once against the existing edubridge database after reviewing the changes.

ALTER TABLE knowledgeFiles
    MODIFY fileUrl VARCHAR(1000) NULL,
    ADD COLUMN resourceType VARCHAR(60) NULL AFTER sourceUpdatedAt,
    ADD COLUMN originalFileName VARCHAR(255) NULL AFTER resourceType,
    ADD COLUMN storedFileName VARCHAR(255) NULL AFTER originalFileName,
    ADD COLUMN mimeType VARCHAR(120) NULL AFTER storedFileName,
    ADD COLUMN fileSize INT NULL AFTER mimeType,
    ADD COLUMN versionLabel VARCHAR(80) NULL AFTER fileSize,
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'Current' AFTER versionLabel,
    ADD COLUMN uploadedByUserId INT NULL AFTER status,
    ADD COLUMN uploadedAt DATETIME NULL AFTER uploadedByUserId,
    ADD KEY idx_knowledgeFiles_current_identity (provider, resourceType, title, status),
    ADD CONSTRAINT fk_knowledgeFiles_uploadedBy
        FOREIGN KEY (uploadedByUserId) REFERENCES users(id)
        ON DELETE SET NULL ON UPDATE CASCADE;

-- Current-version uniqueness is enforced in the application transaction because
-- MySQL/MariaDB has no portable partial unique constraint for status = Current.
