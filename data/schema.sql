-- EduBridge database tables (structure only, no user records)
-- Exported from the existing local MariaDB schema for project setup.
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agentreviews` (
  `reviewId` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `studentUserId` int(11) NOT NULL,
  `agentUserId` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `comment` text NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`reviewId`),
  UNIQUE KEY `uq_agent_review_application` (`applicationId`),
  KEY `idx_agent_reviews_student` (`studentUserId`),
  KEY `idx_agent_reviews_agent` (`agentUserId`),
  CONSTRAINT `fk_agent_reviews_agent` FOREIGN KEY (`agentUserId`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_agent_reviews_application` FOREIGN KEY (`applicationId`) REFERENCES `applications` (`applicationId`),
  CONSTRAINT `fk_agent_reviews_student` FOREIGN KEY (`studentUserId`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_agent_review_rating` CHECK (`rating` between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applicationconversationreads` (
  `applicationId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `lastReadAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`applicationId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `applicationconversationreads_ibfk_1` FOREIGN KEY (`applicationId`) REFERENCES `applications` (`applicationId`) ON DELETE CASCADE,
  CONSTRAINT `applicationconversationreads_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applicationdocuments` (
  `documentId` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `uploadedByUserId` int(11) NOT NULL,
  `documentType` varchar(60) NOT NULL,
  `originalFileName` varchar(255) NOT NULL,
  `storedFileName` varchar(255) NOT NULL,
  `mimeType` varchar(120) NOT NULL,
  `fileSize` int(11) NOT NULL,
  `reviewStatus` varchar(40) NOT NULL DEFAULT 'Uploaded',
  `reviewNote` text DEFAULT NULL,
  `uploadedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `reviewedByUserId` int(11) DEFAULT NULL,
  `reviewedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`documentId`),
  KEY `idx_application_documents_application` (`applicationId`),
  KEY `idx_application_documents_uploader` (`uploadedByUserId`),
  KEY `idx_application_documents_reviewer` (`reviewedByUserId`),
  CONSTRAINT `fk_application_documents_application` FOREIGN KEY (`applicationId`) REFERENCES `applications` (`applicationId`),
  CONSTRAINT `fk_application_documents_reviewer` FOREIGN KEY (`reviewedByUserId`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_application_documents_uploader` FOREIGN KEY (`uploadedByUserId`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_application_documents_review_status` CHECK (`reviewStatus` in ('Uploaded','Received','Reviewed','Needs Replacement'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applicationmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `senderUserId` int(11) NOT NULL,
  `messageText` text NOT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_application_messages_application` (`applicationId`),
  KEY `fk_application_messages_sender` (`senderUserId`),
  CONSTRAINT `fk_application_messages_application` FOREIGN KEY (`applicationId`) REFERENCES `applications` (`applicationId`) ON DELETE CASCADE,
  CONSTRAINT `fk_application_messages_sender` FOREIGN KEY (`senderUserId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications` (
  `applicationId` int(11) NOT NULL AUTO_INCREMENT,
  `ownerUserId` int(11) DEFAULT NULL,
  `studentLabel` varchar(100) NOT NULL,
  `programmeId` int(11) NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'New',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`applicationId`),
  KEY `fk_application_programme` (`programmeId`),
  KEY `idx_applications_ownerUserId` (`ownerUserId`),
  CONSTRAINT `fk_application_programme` FOREIGN KEY (`programmeId`) REFERENCES `programmes` (`programmeId`),
  CONSTRAINT `fk_applications_owner_user` FOREIGN KEY (`ownerUserId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applicationstatushistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `oldStatus` varchar(30) NOT NULL,
  `newStatus` varchar(30) NOT NULL,
  `changedByUserId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `applicationId` (`applicationId`),
  KEY `changedByUserId` (`changedByUserId`),
  CONSTRAINT `applicationstatushistory_ibfk_1` FOREIGN KEY (`applicationId`) REFERENCES `applications` (`applicationId`),
  CONSTRAINT `applicationstatushistory_ibfk_2` FOREIGN KEY (`changedByUserId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favourites` (
  `favouriteId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `itemType` varchar(30) NOT NULL,
  `itemId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`favouriteId`),
  UNIQUE KEY `uq_favourites_user_item` (`userId`,`itemType`,`itemId`),
  KEY `idx_favourites_user` (`userId`),
  CONSTRAINT `fk_favourites_user` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invitations` (
  `invitationId` int(11) NOT NULL AUTO_INCREMENT,
  `agentId` int(11) NOT NULL,
  `email` varchar(150) NOT NULL,
  `token` varchar(100) NOT NULL,
  `usedAt` timestamp NULL DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`invitationId`),
  UNIQUE KEY `token` (`token`),
  KEY `fk_invitations_agent` (`agentId`),
  CONSTRAINT `fk_invitations_agent` FOREIGN KEY (`agentId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledgearticles` (
  `articleId` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `category` varchar(80) NOT NULL,
  `content` text NOT NULL,
  `sourceLabel` varchar(255) NOT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`articleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledgefaqs` (
  `faqId` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(500) NOT NULL,
  `answer` text NOT NULL,
  `country` varchar(80) DEFAULT NULL,
  `provider` varchar(150) DEFAULT NULL,
  `category` varchar(100) NOT NULL,
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `sourceSystem` varchar(40) DEFAULT NULL,
  `sourceRecordId` varchar(80) DEFAULT NULL,
  `sourceUpdatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`faqId`),
  UNIQUE KEY `uq_knowledgeFaqs_source` (`sourceSystem`,`sourceRecordId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledgefiles` (
  `fileId` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `country` varchar(80) DEFAULT NULL,
  `provider` varchar(150) DEFAULT NULL,
  `fileType` varchar(100) NOT NULL,
  `fileUrl` varchar(1000) DEFAULT NULL,
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sourceSystem` varchar(40) DEFAULT NULL,
  `sourceRecordId` varchar(80) DEFAULT NULL,
  `sourceUpdatedAt` datetime DEFAULT NULL,
  `resourceType` varchar(60) DEFAULT NULL,
  `originalFileName` varchar(255) DEFAULT NULL,
  `storedFileName` varchar(255) DEFAULT NULL,
  `mimeType` varchar(120) DEFAULT NULL,
  `fileSize` int(11) DEFAULT NULL,
  `versionLabel` varchar(80) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Current',
  `uploadedByUserId` int(11) DEFAULT NULL,
  `uploadedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`fileId`),
  UNIQUE KEY `uq_knowledgeFiles_source` (`sourceSystem`,`sourceRecordId`),
  KEY `idx_knowledgeFiles_country` (`country`),
  KEY `idx_knowledgeFiles_provider` (`provider`),
  KEY `idx_knowledgeFiles_fileType` (`fileType`),
  KEY `idx_knowledgeFiles_current_identity` (`provider`,`resourceType`,`title`,`status`),
  KEY `fk_knowledgeFiles_uploadedBy` (`uploadedByUserId`),
  CONSTRAINT `fk_knowledgeFiles_uploadedBy` FOREIGN KEY (`uploadedByUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledgeresources` (
  `resourceId` int(11) NOT NULL AUTO_INCREMENT,
  `articleId` int(11) NOT NULL,
  `resourceType` varchar(30) NOT NULL,
  `title` varchar(200) NOT NULL,
  `resourceUrl` varchar(500) NOT NULL,
  `sourceLabel` varchar(160) DEFAULT NULL,
  `sortOrder` int(11) NOT NULL DEFAULT 1,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`resourceId`),
  KEY `idx_knowledge_resources_article_sort` (`articleId`,`sortOrder`,`resourceId`),
  CONSTRAINT `fk_knowledge_resources_article` FOREIGN KEY (`articleId`) REFERENCES `knowledgearticles` (`articleId`) ON DELETE CASCADE,
  CONSTRAINT `chk_knowledge_resources_type` CHECK (`resourceType` in ('YouTube','Official Link'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `notificationId` int(11) NOT NULL AUTO_INCREMENT,
  `recipientUserId` int(11) NOT NULL,
  `actorUserId` int(11) DEFAULT NULL,
  `type` varchar(60) NOT NULL,
  `title` varchar(160) NOT NULL,
  `message` varchar(500) NOT NULL,
  `linkPath` varchar(255) DEFAULT NULL,
  `readAt` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`notificationId`),
  KEY `idx_notifications_recipient_read` (`recipientUserId`,`readAt`),
  KEY `idx_notifications_created` (`createdAt`),
  KEY `fk_notifications_actor` (`actorUserId`),
  CONSTRAINT `fk_notifications_actor` FOREIGN KEY (`actorUserId`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_notifications_recipient` FOREIGN KEY (`recipientUserId`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_notifications_type` CHECK (`type` in ('NEW_RECOMMENDATION','RECOMMENDATION_RESPONSE','APPLICATION_STATUS_CHANGED','DOCUMENT_UPLOADED','DOCUMENT_REVIEW_UPDATED','NEW_AGENT_REVIEW'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programmerecommendations` (
  `recommendationId` int(11) NOT NULL AUTO_INCREMENT,
  `studentUserId` int(11) NOT NULL,
  `agentUserId` int(11) NOT NULL,
  `programmeId` int(11) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('Pending','Interested','Not Interested','Request Changes') NOT NULL DEFAULT 'Pending',
  `studentComment` text DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `respondedAt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`recommendationId`),
  UNIQUE KEY `uq_recommendation_student_programme` (`studentUserId`,`programmeId`),
  KEY `idx_recommendations_agent` (`agentUserId`),
  KEY `idx_recommendations_programme` (`programmeId`),
  CONSTRAINT `fk_recommendations_agent` FOREIGN KEY (`agentUserId`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_recommendations_programme` FOREIGN KEY (`programmeId`) REFERENCES `programmes` (`programmeId`),
  CONSTRAINT `fk_recommendations_student` FOREIGN KEY (`studentUserId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programmes` (
  `programmeId` int(11) NOT NULL AUTO_INCREMENT,
  `programmeName` varchar(150) NOT NULL,
  `provider` varchar(120) NOT NULL,
  `level` varchar(60) NOT NULL,
  `location` varchar(80) NOT NULL,
  `duration` varchar(50) NOT NULL,
  `studyArea` varchar(100) NOT NULL,
  PRIMARY KEY (`programmeId`),
  UNIQUE KEY `uq_programmes_provider_name` (`provider`,`programmeName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainingmodules` (
  `moduleId` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(80) DEFAULT NULL,
  `level` varchar(40) DEFAULT NULL,
  `durationMinutes` int(11) DEFAULT NULL,
  PRIMARY KEY (`moduleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainingmodulesections` (
  `sectionId` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) NOT NULL,
  `sectionTitle` varchar(150) NOT NULL,
  `sectionContent` text NOT NULL,
  `sortOrder` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`sectionId`),
  KEY `moduleId` (`moduleId`),
  CONSTRAINT `trainingmodulesections_ibfk_1` FOREIGN KEY (`moduleId`) REFERENCES `trainingmodules` (`moduleId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainingprogress` (
  `progressId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `moduleId` int(11) NOT NULL,
  `completedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`progressId`),
  UNIQUE KEY `unique_user_module` (`userId`,`moduleId`),
  KEY `fk_training_progress_module` (`moduleId`),
  CONSTRAINT `fk_training_progress_module` FOREIGN KEY (`moduleId`) REFERENCES `trainingmodules` (`moduleId`),
  CONSTRAINT `fk_training_progress_user` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainingquizattempts` (
  `attemptId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `moduleId` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `totalQuestions` int(11) NOT NULL,
  `passed` tinyint(1) NOT NULL DEFAULT 0,
  `attemptedAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`attemptId`),
  KEY `fk_training_quiz_attempts_user` (`userId`),
  KEY `fk_training_quiz_attempts_module` (`moduleId`),
  CONSTRAINT `fk_training_quiz_attempts_module` FOREIGN KEY (`moduleId`) REFERENCES `trainingmodules` (`moduleId`),
  CONSTRAINT `fk_training_quiz_attempts_user` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainingquizquestions` (
  `questionId` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) NOT NULL,
  `questionText` varchar(500) NOT NULL,
  `optionA` varchar(300) NOT NULL,
  `optionB` varchar(300) NOT NULL,
  `optionC` varchar(300) NOT NULL,
  `optionD` varchar(300) NOT NULL,
  `correctOption` char(1) NOT NULL,
  `sortOrder` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`questionId`),
  KEY `fk_training_quiz_questions_module` (`moduleId`),
  CONSTRAINT `fk_training_quiz_questions_module` FOREIGN KEY (`moduleId`) REFERENCES `trainingmodules` (`moduleId`) ON DELETE CASCADE,
  CONSTRAINT `chk_training_quiz_correct_option` CHECK (`correctOption` in ('A','B','C','D'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainingresources` (
  `resourceId` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) NOT NULL,
  `resourceType` varchar(30) NOT NULL,
  `title` varchar(200) NOT NULL,
  `resourceUrl` varchar(500) NOT NULL,
  `sourceLabel` varchar(160) DEFAULT NULL,
  `sortOrder` int(11) NOT NULL DEFAULT 1,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`resourceId`),
  KEY `idx_training_resources_module_sort` (`moduleId`,`sortOrder`,`resourceId`),
  CONSTRAINT `fk_training_resources_module` FOREIGN KEY (`moduleId`) REFERENCES `trainingmodules` (`moduleId`) ON DELETE CASCADE,
  CONSTRAINT `chk_training_resources_type` CHECK (`resourceType` in ('YouTube','Official Link'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `password` text NOT NULL,
  `email` text NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'student',
  `agentId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_users_agentId` (`agentId`),
  CONSTRAINT `fk_users_agent` FOREIGN KEY (`agentId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

SET FOREIGN_KEY_CHECKS = 1;
