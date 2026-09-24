CREATE TABLE IF NOT EXISTS programmeRecommendations (
    recommendationId INT NOT NULL AUTO_INCREMENT,
    studentUserId INT NOT NULL,
    agentUserId INT NOT NULL,
    programmeId INT NOT NULL,
    reason TEXT NOT NULL,
    status ENUM('Pending', 'Interested', 'Not Interested', 'Request Changes') NOT NULL DEFAULT 'Pending',
    studentComment TEXT NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    respondedAt TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (recommendationId),
    UNIQUE KEY uq_recommendation_student_programme (studentUserId, programmeId),
    KEY idx_recommendations_agent (agentUserId),
    KEY idx_recommendations_programme (programmeId),
    CONSTRAINT fk_recommendations_student FOREIGN KEY (studentUserId) REFERENCES users(id),
    CONSTRAINT fk_recommendations_agent FOREIGN KEY (agentUserId) REFERENCES users(id),
    CONSTRAINT fk_recommendations_programme FOREIGN KEY (programmeId) REFERENCES programmes(programmeId)
);

CREATE TABLE IF NOT EXISTS agentReviews (
    reviewId INT NOT NULL AUTO_INCREMENT,
    applicationId INT NOT NULL,
    studentUserId INT NOT NULL,
    agentUserId INT NOT NULL,
    rating TINYINT NOT NULL,
    comment TEXT NOT NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (reviewId),
    UNIQUE KEY uq_agent_review_application (applicationId),
    KEY idx_agent_reviews_student (studentUserId),
    KEY idx_agent_reviews_agent (agentUserId),
    CONSTRAINT fk_agent_reviews_application FOREIGN KEY (applicationId) REFERENCES applications(applicationId),
    CONSTRAINT fk_agent_reviews_student FOREIGN KEY (studentUserId) REFERENCES users(id),
    CONSTRAINT fk_agent_reviews_agent FOREIGN KEY (agentUserId) REFERENCES users(id),
    CONSTRAINT chk_agent_review_rating CHECK (rating BETWEEN 1 AND 5)
);
