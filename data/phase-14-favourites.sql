-- EduBridge Final Feature Round: Agent favourites.
-- Run once against the existing edubridge database after reviewing the change.

CREATE TABLE IF NOT EXISTS favourites (
    favouriteId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    itemType VARCHAR(30) NOT NULL,
    itemId INT NOT NULL,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_favourites_user_item (userId, itemType, itemId),
    KEY idx_favourites_user (userId),
    CONSTRAINT fk_favourites_user
        FOREIGN KEY (userId) REFERENCES users(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
