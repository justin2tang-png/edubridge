CREATE TABLE IF NOT EXISTS notifications (
    notificationId INT NOT NULL AUTO_INCREMENT,
    recipientUserId INT NOT NULL,
    actorUserId INT NULL,
    type VARCHAR(60) NOT NULL,
    title VARCHAR(160) NOT NULL,
    message VARCHAR(500) NOT NULL,
    linkPath VARCHAR(255) NULL,
    readAt DATETIME NULL,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (notificationId),
    KEY idx_notifications_recipient_read (recipientUserId, readAt),
    KEY idx_notifications_created (createdAt),
    CONSTRAINT fk_notifications_recipient FOREIGN KEY (recipientUserId) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_notifications_actor FOREIGN KEY (actorUserId) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_notifications_type CHECK (type IN (
        'NEW_RECOMMENDATION',
        'RECOMMENDATION_RESPONSE',
        'APPLICATION_STATUS_CHANGED',
        'DOCUMENT_UPLOADED',
        'DOCUMENT_REVIEW_UPDATED',
        'NEW_AGENT_REVIEW'
    ))
);
