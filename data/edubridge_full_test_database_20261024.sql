-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: edubridge
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agentreviews`
--

DROP TABLE IF EXISTS `agentreviews`;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agentreviews`
--

LOCK TABLES `agentreviews` WRITE;
/*!40000 ALTER TABLE `agentreviews` DISABLE KEYS */;
INSERT INTO `agentreviews` VALUES (3,3,5,4,5,'ok','2026-09-24 07:04:26'),(4,4,5,4,5,'Excellent support during the application process.','2026-09-24 07:51:15');
/*!40000 ALTER TABLE `agentreviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicationconversationreads`
--

DROP TABLE IF EXISTS `applicationconversationreads`;
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

--
-- Dumping data for table `applicationconversationreads`
--

LOCK TABLES `applicationconversationreads` WRITE;
/*!40000 ALTER TABLE `applicationconversationreads` DISABLE KEYS */;
INSERT INTO `applicationconversationreads` VALUES (2,4,'2026-09-29 20:03:00'),(3,4,'2026-09-29 18:43:46'),(3,5,'2026-09-29 18:44:05'),(4,4,'2026-10-13 19:26:14'),(4,5,'2026-10-13 19:27:31');
/*!40000 ALTER TABLE `applicationconversationreads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicationdocuments`
--

DROP TABLE IF EXISTS `applicationdocuments`;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicationdocuments`
--

LOCK TABLES `applicationdocuments` WRITE;
/*!40000 ALTER TABLE `applicationdocuments` DISABLE KEYS */;
INSERT INTO `applicationdocuments` VALUES (1,4,5,'Academic Transcript','synthetic-browser-acceptance.pdf','682b6993-d9f7-4968-a407-1a337c56f7ba.pdf','application/pdf',48,'Needs Replacement','Please upload a clearer copy.','2026-09-24 19:44:17',4,'2026-09-24 20:09:45');
/*!40000 ALTER TABLE `applicationdocuments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicationmessages`
--

DROP TABLE IF EXISTS `applicationmessages`;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicationmessages`
--

LOCK TABLES `applicationmessages` WRITE;
/*!40000 ALTER TABLE `applicationmessages` DISABLE KEYS */;
INSERT INTO `applicationmessages` VALUES (1,4,5,'hi I forgot to upload my transcript','2026-09-22 18:56:44'),(2,3,5,'hi my passport has expired','2026-09-22 18:58:09'),(3,3,4,'oh, really? that\'s great','2026-09-22 18:58:55'),(4,3,5,'yeah, so I don\'t need to go to NZ now, yeah!','2026-09-22 19:02:07'),(5,4,4,'that\'s great','2026-09-24 18:19:01'),(6,3,4,'come to office tomorrow','2026-09-29 18:43:46'),(7,4,4,'hey, been long time','2026-10-01 18:13:02');
/*!40000 ALTER TABLE `applicationmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,NULL,'abc',2,'New','2026-09-10 08:27:54'),(2,3,'abc',2,'Under Review','2026-09-15 07:18:12'),(3,5,'ccc',2,'Completed','2026-09-15 08:23:21'),(4,5,'dafdag',3,'Completed','2026-09-17 07:40:33');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicationstatushistory`
--

DROP TABLE IF EXISTS `applicationstatushistory`;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicationstatushistory`
--

LOCK TABLES `applicationstatushistory` WRITE;
/*!40000 ALTER TABLE `applicationstatushistory` DISABLE KEYS */;
INSERT INTO `applicationstatushistory` VALUES (1,4,'New','Under Review',4,'2026-09-22 20:02:53'),(2,3,'New','Completed',4,'2026-09-24 19:03:55'),(3,4,'Under Review','Documents Required',4,'2026-09-24 19:46:39'),(4,4,'Documents Required','Under Review',1,'2026-09-24 19:49:00'),(5,4,'Under Review','Completed',1,'2026-09-24 19:49:10');
/*!40000 ALTER TABLE `applicationstatushistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favourites`
--

DROP TABLE IF EXISTS `favourites`;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favourites`
--

LOCK TABLES `favourites` WRITE;
/*!40000 ALTER TABLE `favourites` DISABLE KEYS */;
INSERT INTO `favourites` VALUES (5,4,'Programme',9,'2026-10-01 20:31:49');
/*!40000 ALTER TABLE `favourites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitations`
--

DROP TABLE IF EXISTS `invitations`;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invitations`
--

LOCK TABLES `invitations` WRITE;
/*!40000 ALTER TABLE `invitations` DISABLE KEYS */;
INSERT INTO `invitations` VALUES (1,4,'justin2tang@gmail.com','204817ea1732cab2cb292cf51924340614839e8e9285b7972cefa810506defa5',NULL,'2026-09-17 08:16:20'),(2,4,'justin2tang@gmail.com','d465d5600be35235034b2e24c86d80083c8147a72f9509a1ed10f7ed5b925c6a','2026-09-17 08:17:05','2026-09-17 08:16:56');
/*!40000 ALTER TABLE `invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledgearticles`
--

DROP TABLE IF EXISTS `knowledgearticles`;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledgearticles`
--

LOCK TABLES `knowledgearticles` WRITE;
/*!40000 ALTER TABLE `knowledgearticles` DISABLE KEYS */;
INSERT INTO `knowledgearticles` VALUES (5,'New Zealand Student Visa Funds and Tuition Fee Evidence','Student Visa Guidance','Applicants for a New Zealand student visa must show that they have sufficient funds for tuition fees, living costs and outward travel.\n\nImmigration New Zealand accepts several forms of financial evidence. Bank statements can be used when they show the account holder\'s name and the most recent three months of transaction history. Fixed-term deposit certificates can also be used where the deposit has been held for at least three months.\n\nFor tertiary, English-language and other non-compulsory study, students paying their own living costs generally need NZD 20,000 for each year of study, or NZD 1,667 per month where the course is shorter than one year.\n\nFor tuition fees, applicants normally need to show that they have paid for one course or one year of study, whichever is shorter. An applicant applying from outside New Zealand may choose to wait until receiving approval in principle before paying tuition fees, although the visa cannot be issued until the required tuition payment evidence has been provided.\n\nThe visa period is normally linked to the period of study that has been paid for, subject to other factors such as passport validity.\n\nFinancial evidence should always be checked against current Immigration New Zealand requirements before case-specific advice is given.','Immigration New Zealand — Fee Paying Student Visa and Student Fund Requirements','2026-09-22 11:08:01'),(6,'Changing Education Agents at the University of Auckland','Provider Guidance','The University of Auckland has specific procedures for appointing or changing an education agent.\n\nFrom 14 May 2026, an applicant who has received at least one full offer within the previous 12 months is not eligible to be newly linked to an agency or to request a change of agent.\n\nWhere a change is permitted, the University\'s Change of Agent Form must be completed. The applicant must complete and sign the required sections, while both the current agency and the new agency must complete the relevant agency sections and provide the required signatures and stamps.\n\nA change of agent is not recognised until the completed documentation has been received and reviewed by the University of Auckland International Office.\n\nAdvisers should check the University\'s current Agent Guidelines before giving case-specific advice because eligibility and process requirements may change.','University of Auckland — Agent Guidelines','2026-09-22 11:08:01'),(7,'University of Auckland Doctoral Applications and Agent Access','Provider Guidance','Doctoral applications at the University of Auckland are handled differently from many other international student applications.\n\nApplicants for doctoral programmes are required to submit and manage their own doctoral applications through their student portal.\n\nEducation agents can view doctoral applications through the University\'s Agent Application Centre, but doctoral applications are available to agents as read-only records rather than applications that the agent manages on behalf of the student.\n\nAdvisers should distinguish between providing general application support and directly managing a doctoral application.\n\nQuestions about agency recognition, commission arrangements or commercial agreements should be checked separately with the University and should not be assumed from the application workflow.','University of Auckland — Agent Application Centre','2026-09-22 11:08:01'),(8,'Outward Travel Evidence and the New Zealand Traveller Declaration','Pre-departure Guidance','A New Zealand student visa applicant must be able to show that they can leave New Zealand at the end of their stay. This can be demonstrated through a ticket for outward travel, sufficient additional funds to purchase a ticket, or an acceptable arrangement with a sponsor.\n\nThis does not mean every student must purchase a return ticket before travelling.\n\nTravellers entering New Zealand must also complete a New Zealand Traveller Declaration. For air travellers, the earliest the declaration can be submitted is 24 hours before starting the journey to New Zealand. It must be submitted by the time the traveller reaches passport control in New Zealand.\n\nThe declaration collects travel, customs, immigration and biosecurity information and is linked to the traveller\'s passport.\n\nStudents should check current travel and entry requirements before departure and keep important travel and study documents accessible during their journey.','Immigration New Zealand / New Zealand Traveller Declaration','2026-09-22 11:08:01'),(9,'Health Evidence for a New Zealand Fee-Paying Student Visa','Student Visa Guidance','Health evidence for a New Zealand student visa depends on the applicant\'s circumstances. A separate medical examination is not automatically required for every student visa application.\n\nApplicants staying for less than six months do not normally need a chest X-ray, while applicants staying for less than twelve months do not normally need a medical certificate. Immigration New Zealand may still request health evidence depending on the applicant\'s health information and circumstances.\n\nFor stays longer than six months, a chest X-ray may be required where the applicant is a citizen of a country that does not have a low incidence of tuberculosis, or has spent more than three months during the previous five years in such a country.\n\nWhen health evidence is required, the applicant should arrange an appointment with an appropriate clinic. The visa application may use the eMedical reference code, the clinic details, or medical and X-ray certificates where applicable.\n\nHealth evidence must meet Immigration New Zealand\'s current validity and submission requirements.','Immigration New Zealand — Fee Paying Student Visa Health Requirements','2026-09-22 11:08:01'),(10,'Police Certificates and Supporting Documents for New Zealand Student Visas','Student Visa Guidance','Police certificate requirements for a New Zealand student visa depend on the applicant\'s age and expected time in New Zealand.\n\nA police certificate is generally required when the applicant is aged 17 or older and their total time in New Zealand will be 24 months or longer. This total can include time previously spent in New Zealand on other visas.\n\nWhere required, police certificates must normally be obtained from countries of citizenship and from countries where the applicant has spent more than five years since turning 17.\n\nPolice certificates must meet Immigration New Zealand\'s current age and validity requirements. Police and medical certificates that are not in English require certified English translations.\n\nAcademic records may also be required in relevant situations. For example, students applying for another student visa may need to provide evidence of previous academic progress such as transcripts, attendance records or provider letters.\n\nImmigration New Zealand does not describe notarisation of every academic transcript, birth document or household registration document as a universal requirement for every fee-paying student visa application. Additional identity, relationship or supporting documents may be requested depending on the individual case.','Immigration New Zealand — Fee Paying Student Visa','2026-09-22 11:08:01'),(11,'Pre-Master\'s Pathways for Students Without a Bachelor\'s Degree','Programme Guidance','Not holding a bachelor\'s degree does not automatically prevent an international student from progressing toward master\'s-level study in New Zealand. Some universities provide structured pre-master\'s pathways for students who meet alternative tertiary-entry requirements.\n\nThe University of Waikato\'s Diploma in Postgraduate Preparation (Pre-Masters) is designed for international students who do not have the equivalent of a New Zealand bachelor\'s degree or who do not meet the requirements for direct entry into selected postgraduate programmes.\n\nThe University of Canterbury also offers a two-semester Pre-Master\'s pathway for international students who hold an advanced diploma or associate degree but not a full bachelor\'s degree. Successful completion can provide progression into a range of eligible master\'s programmes, subject to programme requirements.\n\nEligibility is not based on work experience alone. Previous tertiary study, qualification level, English-language requirements and the intended master\'s programme all need to be checked.\n\nAdvisers should confirm current entry requirements directly with the relevant university before recommending a pathway.','University of Waikato / University of Canterbury — Pre-Master\'s Pathways','2026-09-22 11:08:01'),(12,'Partner Work Rights While a Student Is Studying in New Zealand','Student Visa Guidance','A partner of an international student may be eligible for a Partner of a Student Work Visa, but eligibility depends on the qualification being studied.\n\nA student studying a level 9 or 10 qualification, such as an eligible master\'s or doctoral degree, can generally support their partner\'s application for this work visa.\n\nSome level 7 or 8 qualifications can also support a partner work visa where the qualification meets Immigration New Zealand\'s specified eligibility rules, including relevant Green List or Post-Study Work Visa qualification requirements.\n\nA Partner of a Student Work Visa allows the holder to work in New Zealand and to study for up to three months. The visa is normally granted for the same duration as the supporting student\'s visa.\n\nThe applicant must also meet partnership, health, character and financial requirements.\n\nAdvisers should check the student\'s exact qualification against the current Immigration New Zealand eligibility rules before advising that a partner will qualify for work rights.','Immigration New Zealand — Partner of a Student Work Visa','2026-09-22 11:08:01');
/*!40000 ALTER TABLE `knowledgearticles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledgefaqs`
--

DROP TABLE IF EXISTS `knowledgefaqs`;
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledgefaqs`
--

LOCK TABLES `knowledgefaqs` WRITE;
/*!40000 ALTER TABLE `knowledgefaqs` DISABLE KEYS */;
INSERT INTO `knowledgefaqs` VALUES (1,'What should an adviser do when an application is missing required documents?','Review the application information and identify what is missing before taking the next step. Where appropriate, use the Documents Required status to show that the application is waiting for information. Send a clear message through the application conversation explaining what the student needs to provide and what will happen next. Do not guess missing details, mark the application as complete, or promise an outcome before the information has been reviewed.',NULL,NULL,'Application Process','2026-09-22 21:56:08',NULL,NULL,NULL),(2,'What do the application statuses mean in EduBridge?','Application statuses describe the current stage recorded for an application. Available statuses include New, Submitted, Documents Required, Under Review, Offer Received, Accepted, Completed, Decision Made, Rejected, and Withdrawn. The status should describe what is currently known about the workflow. It is not a guarantee of a future result. Advisers should read the application details and messages together with the status before explaining progress to a student.',NULL,NULL,'Application Process','2026-09-22 21:56:08',NULL,NULL,NULL),(3,'When should an adviser update an application status?','Update the status when a meaningful change occurs in the application workflow, such as a submission, a review step, a request for information, or a confirmed outcome. The selected status should reflect the actual current stage rather than the stage the adviser hopes to reach next. If only a discussion or reminder has occurred, record the relevant communication without changing the status unless the application stage has genuinely changed.',NULL,NULL,'Application Process','2026-09-22 21:56:08',NULL,NULL,NULL),(4,'How should an adviser use an application conversation?','An application conversation keeps messages connected to the correct student application. Use it to explain progress, request relevant information, answer workflow questions, and record useful updates. Messages should be clear, professional, and specific about any next action. Check the application and recipient before sending. The conversation supports the application record, but it does not replace accurate status updates or careful review of the application information.',NULL,NULL,'Student Support','2026-09-22 21:56:08',NULL,NULL,NULL),(5,'What does an unread application message indicate?','An unread message indicates that a message from another participant is newer than the user read marker for that application conversation. It is a prompt to review the relevant application thread, not proof that every message in the thread is new. Open the correct application, read the current conversation, and identify whether a response or follow-up action is needed. Do not rely on the unread count alone to understand the application situation.',NULL,NULL,'Student Support','2026-09-22 21:56:08',NULL,NULL,NULL),(6,'What does an assigned student mean for an adviser?','An assigned student is a student record linked to the adviser through the EduBridge assignment workflow. Agents use their assigned student scope when reviewing student records, applications, messages, and related progress. Advisers should work within that scope and avoid treating an unassigned record as their responsibility. If an assignment appears incorrect or missing, report the issue through the appropriate administrative process instead of changing ownership informally.',NULL,NULL,'Student Support','2026-09-22 21:56:08',NULL,NULL,NULL),(7,'What information should be compared when reviewing programmes?','Use the programme information available in EduBridge to compare relevant options. Useful comparison points include the programme name, provider, study level, location, duration, and study area. Consider these details alongside the student goal and the information recorded for the application. A comparison should explain meaningful differences between options. It should not present a programme as automatically suitable without checking the available information and the student context.',NULL,NULL,'Programme Guidance','2026-09-22 21:56:08',NULL,NULL,NULL),(8,'How should an adviser check programme information before discussing an option?','Review the programme record and confirm the details that are relevant to the current discussion, including the provider, level, location, duration, and study area where available. Use the information recorded in the system rather than relying on memory or unsupported assumptions. If a detail is unclear or may need confirmation, explain the uncertainty and identify what should be checked before the student relies on it.',NULL,NULL,'Programme Guidance','2026-09-22 21:56:08',NULL,NULL,NULL),(9,'How should student information be protected during adviser work?','Use student information only for the education and application work being completed. Keep communication connected to the correct student and application, and avoid copying personal details into unrelated notes or messages. Record only information that is relevant to the workflow. Use the access provided by EduBridge and do not share account credentials. When testing the project, continue to use synthetic development records rather than real sensitive student information.',NULL,NULL,'Privacy & Compliance','2026-09-22 21:56:08',NULL,NULL,NULL),(10,'What is an advisers access scope in EduBridge?','Access is based on the users role and the workflow permissions provided by EduBridge. Students can work with their own application records. Agents work with applications and student records assigned to them. Administrators have broader management visibility, including access to records needed for administration. A user should not try to bypass these boundaries or use another persons account. If access appears incorrect, report the issue instead of working around it.',NULL,NULL,'Privacy & Compliance','2026-09-22 21:56:08',NULL,NULL,NULL),(11,'Where can an adviser review an applications history?','The application detail page brings together the current application status, status history, and application conversation. Status history shows recorded changes to the application status, while the conversation shows messages connected to that application. Review both areas when explaining what has happened. A message does not automatically replace a status change, and a status alone may not explain the full context of the students progress.',NULL,NULL,'Application Process','2026-09-22 21:56:08',NULL,NULL,NULL),(12,'How does training quiz completion work in EduBridge?','A training module with quiz questions must be completed through its knowledge check. The quiz uses a 75 percent passing rule. A failed attempt displays a not passed result and does not create training progress. A passed attempt records the quiz attempt and creates the users training progress when the module is not already completed. Modules without quiz questions retain the direct completion fallback used by the current Training Centre workflow.',NULL,NULL,'EduBridge Help','2026-09-22 21:56:08',NULL,NULL,NULL);
/*!40000 ALTER TABLE `knowledgefaqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledgefiles`
--

DROP TABLE IF EXISTS `knowledgefiles`;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledgefiles`
--

LOCK TABLES `knowledgefiles` WRITE;
/*!40000 ALTER TABLE `knowledgefiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `knowledgefiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledgeresources`
--

DROP TABLE IF EXISTS `knowledgeresources`;
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledgeresources`
--

LOCK TABLES `knowledgeresources` WRITE;
/*!40000 ALTER TABLE `knowledgeresources` DISABLE KEYS */;
INSERT INTO `knowledgeresources` VALUES (16,5,'YouTube','Applying for a Student Visa to Study in New Zealand','https://www.youtube.com/watch?v=xcMWJ-yJ9KU','Study with New Zealand',1,'2026-09-24 21:05:13'),(17,5,'Official Link','Student fund requirements','https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/student-fund-requirements/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(18,5,'Official Link','Fee Paying Student Visa','https://www.immigration.govt.nz/visas/fee-paying-student-visa/','Immigration New Zealand',3,'2026-09-24 21:05:13'),(19,6,'Official Link','Agent guidelines','https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-guidelines.html','University of Auckland',1,'2026-09-24 21:05:13'),(20,7,'Official Link','Agent Application Centre','https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-application-centre.html','University of Auckland',1,'2026-09-24 21:05:13'),(21,8,'Official Link','New Zealand Traveller Declaration','https://www.travellerdeclaration.govt.nz/','New Zealand Traveller Declaration',1,'2026-09-24 21:05:13'),(22,8,'Official Link','About the New Zealand Traveller Declaration','https://www.travellerdeclaration.govt.nz/about/','New Zealand Traveller Declaration',2,'2026-09-24 21:05:13'),(23,9,'YouTube','Applying for a Student Visa to Study in New Zealand','https://www.youtube.com/watch?v=xcMWJ-yJ9KU','Study with New Zealand',1,'2026-09-24 21:05:13'),(24,9,'Official Link','Health requirements','https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/health-requirements/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(25,9,'Official Link','Who needs an X-ray or medical examination','https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/health-requirements/who-needs-an-x-ray-or-medical-examination/','Immigration New Zealand',3,'2026-09-24 21:05:13'),(26,10,'Official Link','Police certificates','https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/character-requirements-third-party-checks-and-police-certificates/police-certificates/','Immigration New Zealand',1,'2026-09-24 21:05:13'),(27,10,'Official Link','Providing English translations of supporting documents','https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/providing-english-translations-of-supporting-documents/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(28,11,'Official Link','University of Waikato College entry requirements','https://college.waikato.ac.nz/admissions/entry-requirements/','University of Waikato College',1,'2026-09-24 21:05:13'),(29,12,'YouTube','Can I bring my family when I study in New Zealand?','https://www.youtube.com/watch?v=ngpz9YFaxgU','Study with New Zealand',1,'2026-09-24 21:05:13'),(30,12,'Official Link','Partner of a Student Work Visa','https://www.immigration.govt.nz/visas/partner-of-a-student-work-visa/','Immigration New Zealand',2,'2026-09-24 21:05:13');
/*!40000 ALTER TABLE `knowledgeresources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (3,5,4,'NEW_RECOMMENDATION','New programme recommendation','Your agent recommended Master of Applied Computing.','/recommendations','2026-09-24 19:43:42','2026-09-24 19:41:55'),(4,4,5,'RECOMMENDATION_RESPONSE','Recommendation response','ccc responded Request Changes.','/students/5',NULL,'2026-09-24 19:43:47'),(5,4,5,'DOCUMENT_UPLOADED','New application document','ccc uploaded a Academic Transcript document.','/applications/4',NULL,'2026-09-24 19:44:17'),(6,5,4,'APPLICATION_STATUS_CHANGED','Application status updated','Your application for Certificate in Early Childhood Education is now Documents Required.','/applications/4','2026-09-24 19:48:10','2026-09-24 19:46:39'),(7,5,4,'DOCUMENT_REVIEW_UPDATED','Application document reviewed','Your Academic Transcript document is marked Needs Replacement.','/applications/4','2026-09-24 19:48:10','2026-09-24 19:46:52'),(8,5,4,'DOCUMENT_REVIEW_UPDATED','Application document reviewed','Your Academic Transcript document is marked Needs Replacement.','/applications/4','2026-09-24 19:47:58','2026-09-24 19:46:57'),(9,5,1,'APPLICATION_STATUS_CHANGED','Application status updated','Your application for Certificate in Early Childhood Education is now Under Review.','/applications/4',NULL,'2026-09-24 19:49:00'),(10,4,1,'APPLICATION_STATUS_CHANGED','Application status updated','ccc\'s application for Certificate in Early Childhood Education is now Under Review.','/applications/4',NULL,'2026-09-24 19:49:00'),(11,5,1,'APPLICATION_STATUS_CHANGED','Application status updated','Your application for Certificate in Early Childhood Education is now Completed.','/applications/4',NULL,'2026-09-24 19:49:10'),(12,4,1,'APPLICATION_STATUS_CHANGED','Application status updated','ccc\'s application for Certificate in Early Childhood Education is now Completed.','/applications/4',NULL,'2026-09-24 19:49:10'),(13,4,5,'NEW_AGENT_REVIEW','New student feedback','Student submitted a 5-star review.','/students/5',NULL,'2026-09-24 19:51:15'),(19,5,4,'DOCUMENT_REVIEW_UPDATED','Application document reviewed','Your Academic Transcript document is marked Reviewed.','/applications/4',NULL,'2026-09-24 20:03:23'),(27,5,4,'NEW_RECOMMENDATION','New programme recommendation','Your agent recommended Bachelor of Architecture and Future Environments.','/recommendations','2026-10-13 19:24:00','2026-10-13 19:23:29'),(28,4,5,'RECOMMENDATION_RESPONSE','Recommendation response','student responded Interested.','/students/5','2026-10-13 19:25:15','2026-10-13 19:24:30');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programmerecommendations`
--

DROP TABLE IF EXISTS `programmerecommendations`;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programmerecommendations`
--

LOCK TABLES `programmerecommendations` WRITE;
/*!40000 ALTER TABLE `programmerecommendations` DISABLE KEYS */;
INSERT INTO `programmerecommendations` VALUES (4,5,4,57,'good','Interested','ok','2026-09-24 07:01:03','2026-09-24 07:02:01'),(5,5,4,48,'reason = synthetic browser acceptance test','Request Changes','Please provide another option.','2026-09-24 07:41:55','2026-09-24 07:43:47'),(11,5,4,9,'good programme','Interested','yes','2026-10-13 06:23:29','2026-10-13 06:24:30');
/*!40000 ALTER TABLE `programmerecommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programmes`
--

DROP TABLE IF EXISTS `programmes`;
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
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programmes`
--

LOCK TABLES `programmes` WRITE;
/*!40000 ALTER TABLE `programmes` DISABLE KEYS */;
INSERT INTO `programmes` VALUES (2,'Bachelor of Business','Harbour City University','Bachelor','Wellington','3 years','Business'),(3,'Certificate in Early Childhood Education','Southern Learning College','Certificate','Christchurch','1 year','Education'),(9,'Bachelor of Architecture and Future Environments','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Architecture'),(10,'Bachelor of Arts','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Arts and Humanities'),(11,'Bachelor of Business','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Business'),(12,'Bachelor of Communication Studies','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Communication and Media'),(13,'Bachelor of Computer and Information Sciences','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Computing and IT'),(14,'Bachelor of Construction','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Construction and Built Environment'),(15,'Bachelor of Design Te Tohu Paetahi mō te Hoahoa','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Design'),(16,'Bachelor of Engineering (Honours)','Auckland University of Technology (AUT)','8','Auckland','4 years full-time','Engineering'),(17,'Bachelor of Engineering Technology','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Engineering'),(18,'Bachelor of Health Science','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Health Sciences'),(19,'Bachelor of Health Science (Midwifery)','Auckland University of Technology (AUT)','7','Auckland','4 years full-time','Midwifery'),(20,'Bachelor of Health Science (Nursing)','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Nursing'),(21,'Bachelor of Health Science (Occupational Therapy)','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Occupational Therapy'),(22,'Bachelor of Health Science (Oral Health)','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Oral Health'),(23,'Bachelor of Health Science (Physiotherapy)','Auckland University of Technology (AUT)','7','Auckland','4 years full-time','Physiotherapy'),(24,'Bachelor of Health Science (Podiatry)','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Podiatry'),(25,'Bachelor of International Hospitality Management','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Hospitality'),(26,'Bachelor of Laws','Auckland University of Technology (AUT)','7','Auckland','4 years full-time','Law'),(27,'Bachelor of Medical Laboratory Science','Auckland University of Technology (AUT)','7','Auckland','4 years full-time','Medical Laboratory Science'),(28,'Bachelor of Science','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Science'),(29,'Bachelor of Sport, Exercise and Health','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Sport and Exercise'),(30,'Bachelor of Visual Arts Te Tohu Paetahi mō Toi Ataata','Auckland University of Technology (AUT)','7','Auckland','3 years full-time','Visual Arts'),(31,'Bachelor of Science','University of Auckland','7','Auckland – City / Grafton','3 years full-time','Science'),(32,'Bachelor of Arts','University of Auckland','7','Auckland – City','3 years full-time','Arts and Humanities'),(33,'Bachelor of Arts/Bachelor of Science','University of Auckland','7','Auckland – City / Grafton','4 years full-time','Arts and Science'),(34,'Bachelor of Science (Honours)','University of Auckland','8','Auckland – City / Grafton / Newmarket','1 year full-time','Science'),(35,'Bachelor of Arts/Bachelor of Commerce','University of Auckland','7','Auckland – City','4 years full-time','Arts and Business'),(36,'Bachelor of Arts (Honours)','University of Auckland','8','Auckland – City','1 year full-time','Arts and Humanities'),(37,'Bachelor of Communication','University of Auckland','7','Auckland – City','3 years full-time','Communication and Media'),(38,'Bachelor of Arts/Bachelor of Fine Arts','University of Auckland','7','Auckland – City','4 years full-time','Arts and Fine Arts'),(39,'Bachelor of Fine Arts/Bachelor of Science','University of Auckland','7','Auckland – City','4 years full-time','Fine Arts and Science'),(40,'Bachelor of Commerce','University of Auckland','7','Auckland – City','3 years full-time','Business and Commerce'),(41,'Bachelor of Arts/Bachelor of Global Studies','University of Auckland','7','Auckland – City','4 years full-time','Arts and Global Studies'),(42,'Bachelor of Arts/Bachelor of Health Sciences','University of Auckland','7','Auckland – City / Grafton','4 years full-time','Arts and Health Sciences'),(43,'Master of Arts','University of Auckland','9','Auckland – City','1–1.5 years full-time depending on entry route','Arts and Humanities'),(44,'Bachelor of Science - Individual Major','Lincoln University','7','Lincoln, Canterbury','3 years full-time','Science'),(45,'Bachelor of Science with Honours','Lincoln University','8','Lincoln, Canterbury','1 year full-time','Science'),(46,'Master of Applied Science','Lincoln University','9','Lincoln, Canterbury','2 years full-time','Applied Science'),(47,'Master of Tourism Management','Lincoln University','9','Lincoln, Canterbury / Online','1.5 years full-time','Tourism Management'),(48,'Master of Applied Computing','Lincoln University','9','Lincoln, Canterbury','1.5 years full-time','Computing and IT'),(49,'Master of Commerce and Management','Lincoln University','9','Lincoln, Canterbury','2 years full-time','Commerce and Management'),(50,'Master of Business in Global Management and Marketing','Lincoln University','9','Lincoln, Canterbury / Online','1.5 years full-time','Business and Marketing'),(51,'Master of Environmental Policy and Management','Lincoln University','9','Lincoln, Canterbury / Online','1.5 years full-time','Environmental Management'),(52,'Bachelor of Commerce - Accounting and Finance Major','Lincoln University','7','Lincoln, Canterbury','3 years full-time','Accounting and Finance'),(53,'Bachelor of Landscape Architecture','Lincoln University','7','Lincoln, Canterbury','4 years full-time','Landscape Architecture'),(54,'Master of Landscape Architecture','Lincoln University','9','Lincoln, Canterbury','2 years full-time (240-credit route)','Landscape Architecture'),(55,'Master of Planning','Lincoln University','9','Lincoln, Canterbury / Online','2 years full-time','Planning'),(56,'Bachelor of Land and Property Management','Lincoln University','7','Lincoln, Canterbury','4 years full-time','Land and Property Management'),(57,'Bachelor of Commerce - Marketing Major','Lincoln University','7','Lincoln, Canterbury','3 years full-time','Marketing'),(58,'Bachelor of Commerce - Individual Major','Lincoln University','7','Lincoln, Canterbury','3 years full-time','Commerce');
/*!40000 ALTER TABLE `programmes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainingmodules`
--

DROP TABLE IF EXISTS `trainingmodules`;
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainingmodules`
--

LOCK TABLES `trainingmodules` WRITE;
/*!40000 ALTER TABLE `trainingmodules` DISABLE KEYS */;
INSERT INTO `trainingmodules` VALUES (1,'Programme Research and Comparison','Learn how to compare providers, programme levels, locations, entry requirements and study duration.','Programme Knowledge','Beginner',15),(2,'Managing Student Applications','Learn how to track application progress, record status changes and support students through each application stage.','Application Process','Beginner',20),(4,'Introduction to EduBridge','Learn how to use the EduBridge workspace to manage students, applications, programmes and communication.','Getting Started','Beginner',10),(5,'Understanding the New Zealand Education System','Understand NZQF levels, education providers and the main study pathways available to international students.','Programme Knowledge','Beginner',20),(6,'Supporting Student Communication','Learn practical ways to communicate application updates, document requests and next steps clearly with students.','Student Support','Intermediate',20),(7,'Privacy and Data Handling','Understand appropriate handling of student information and the importance of protecting personal data.','Compliance','Intermediate',15),(8,'Ethics and Professional Practice','Review professional responsibilities, accurate record keeping and appropriate boundaries when supporting students.','Compliance','Intermediate',20),(9,'NZQCF Qualification Levels for Education Advisers','Use the New Zealand Qualifications and Credentials Framework to explain qualification levels, compare study options, and avoid confusing qualification type with programme subject.','Programme Knowledge','Intermediate',25),(10,'Checking Provider Quality and Code Signatory Status','Check provider legitimacy, quality assurance and Code signatory status before recommending New Zealand study options.','Compliance','Intermediate',25),(11,'Education Agent Responsibilities under the Learner Code','Understand the education-agent role, accurate information duties, learner-centred conduct and provider monitoring expectations.','Compliance','Intermediate',30),(12,'Immigration Advice Boundaries for Education Agents','Know when education information becomes regulated New Zealand immigration advice and when a learner must be referred to a licensed or exempt adviser.','Compliance','Advanced',30),(13,'Fee-Paying Student Visa Evidence Essentials','Review the main evidence areas in a New Zealand fee-paying student visa application without turning factual guidance into personalised immigration advice.','Application Process','Intermediate',30),(14,'Student Work Rights and Study Conditions','Explain how to check student work conditions, scheduled-break work rights and common limits without assuming every student has the same visa conditions.','Student Support','Intermediate',25),(15,'Pathway Student Visas and Study Progression','Understand the Pathway Student Visa concept, provider eligibility, multi-programme study plans and progression checks.','Student Visa Guidance','Intermediate',25),(16,'Partner and Family Visa Awareness for Student Advisers','Recognise the qualification-level rules that may affect partners and dependent children, while keeping personalised immigration decisions outside an unlicensed adviser role.','Student Support','Intermediate',30),(17,'Post-Study Work Pathways after New Zealand Study','Understand the broad relationship between completed New Zealand qualifications and post-study work options, including 2026 rule changes.','Programme Knowledge','Advanced',30),(18,'Advanced Learner Privacy and Information Handling','Apply New Zealand privacy principles to education-adviser records, including necessary collection, transparency, secure handling, use and access rights.','Compliance','Advanced',30);
/*!40000 ALTER TABLE `trainingmodules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainingmodulesections`
--

DROP TABLE IF EXISTS `trainingmodulesections`;
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
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainingmodulesections`
--

LOCK TABLES `trainingmodulesections` WRITE;
/*!40000 ALTER TABLE `trainingmodulesections` DISABLE KEYS */;
INSERT INTO `trainingmodulesections` VALUES (1,1,'Start with the student goal','Before comparing programmes, identify what the student is trying to achieve. Consider the intended study area, preferred location, qualification level and longer-term study or career direction. A programme comparison is more useful when it begins with a clear student objective.',1),(2,1,'Compare the provider and qualification','Check the education provider, programme title and qualification level. Similar programme names can lead to different qualifications, so compare the actual programme structure and level rather than relying only on the title.',2),(3,1,'Review entry requirements','Check the academic and English-language entry requirements published for each programme. Do not assume that two similar programmes have the same requirements. Record any important differences that may affect whether the programme is suitable for the student.',3),(4,1,'Compare practical study factors','Review the programme location, study duration and other practical information available from the provider. These factors can affect the student experience and may influence which option is more appropriate.',4),(5,1,'Record the comparison clearly','Keep the programme comparison clear enough that another adviser can understand why each option was considered. Record the important differences and avoid making unsupported claims about which programme is best for the student.',5),(6,2,'Understanding the application workflow','An application moves through a series of clear steps from initial student interest to a recorded outcome. An adviser should understand which programme the student is considering, what information has been submitted, what stage the application has reached, and what action is expected next. Following the workflow helps keep work organised and reduces confusion between students, advisers, and other people involved in reviewing the application.',1),(7,2,'Checking application information','Before progressing an application, review the information that has been entered and confirm that it is clear and internally consistent. Check the selected programme, student details, application notes, and any information required by the current workflow. If something is unclear or incomplete, record the issue and request clarification rather than making assumptions. Careful checking helps prevent avoidable delays and supports accurate communication.',2),(8,2,'Updating application status','Application status should reflect the current stage of work. Update it when a meaningful change occurs, such as a new submission, a review step, or a required follow-up. Use the available status options consistently and do not select a status simply to make an application appear further advanced. A clear status gives other users a quick understanding of what has happened and what still needs attention.',3),(9,2,'Communicating progress to students','Students should receive clear updates about application progress. Explain what has happened, what is still being reviewed, and whether the student needs to provide information or take another step. Communication should describe the current position without promising an outcome that has not been confirmed. A useful update is specific enough to guide the student and simple enough to understand without specialist knowledge.',4),(10,2,'Keeping application records clear','Application records should make the history and current position easy to understand. Use concise notes, accurate statuses, and consistent descriptions of follow-up actions. Record important changes so another adviser can continue the work without repeating earlier checks. Clear records support continuity, reduce duplicated effort, and make it easier to explain the application history when a student asks for an update.',5),(11,4,'Purpose of EduBridge','EduBridge provides a shared workspace for everyday education adviser activities. It brings programme information, student records, applications, training modules, knowledge articles, messages, and progress updates into one system. The purpose is to help users keep work organised and visible. EduBridge supports structured work and clear records, but users must still review information carefully and communicate responsibly when making decisions or updating students.',1),(12,4,'Managing students','Student management begins with keeping student records clear and using them for the work currently being completed. Review the relevant student information, applications, training progress, and communication history when these are available to the user. Avoid making assumptions from incomplete information. A well-managed student record helps an adviser understand the current situation and provide a consistent response when the student returns with a question.',2),(13,4,'Managing applications','Applications help users track how a student is progressing through a programme choice and application workflow. An adviser can review the related programme, current status, ownership, and recorded updates. Application information should be kept accurate and changed when the work moves forward. The application record should support the next action instead of becoming a collection of unclear or unsupported notes.',3),(14,4,'Using programmes, training and knowledge','EduBridge includes different areas that support adviser work. Programmes provide information for comparison, training modules support ongoing learning, and knowledge articles provide reference material. These areas should be used together where appropriate, while keeping their purposes clear. Programme information supports comparison, training supports capability, and knowledge articles support understanding. Users should rely on the information available in the system and identify uncertainty instead of inventing details.',4),(15,4,'Working with messages and updates','Messages and updates help users communicate changes in an application or student workflow. Important communication should be clear, relevant, and connected to the correct student or application. Record meaningful updates so that the next person reviewing the work can understand what was discussed and what action is expected. A message should help the workflow move forward rather than create additional uncertainty.',5),(16,5,'Education providers and programmes','A provider delivers programmes with their own titles, structures, entry information, locations, and study arrangements. When comparing options, identify the provider and the specific programme rather than relying on a broad subject label. Similar programme titles may describe different learning experiences. A careful adviser records the relevant differences and helps the student compare actual programme information that is available in the system or from the provider.',1),(17,5,'Qualification levels','Qualification level is one factor used to understand how a programme is positioned within a study pathway. It should be considered together with the programme structure, subject area, entry requirements, and the student goal. Do not treat a level label as proof that one programme is automatically better than another. The adviser should use the level information shown for the programme and explain comparisons in clear, practical language.',2),(18,5,'Programme entry requirements','Entry requirements describe what a student may need before starting a programme. These can include academic background, English-language information, or other requirements published for that programme. Requirements should be checked for the specific provider and programme because similar options may differ. If the available information is incomplete or unclear, record the uncertainty and direct the student to confirm the current information with the relevant provider.',3),(19,5,'Comparing study pathways','A study pathway connects a student goal with a sequence of possible learning choices. Compare pathways by considering the intended subject area, qualification level, programme structure, entry requirements, location, and duration shown in the available information. The purpose is to help the student understand the differences between options. Avoid presenting one pathway as suitable without considering the student goal and the information that has been checked.',4),(20,5,'Using reliable provider information','Provider information should be treated as the main reference for programme details that may change. When reviewing a programme, use the information available from the provider or the approved information recorded in the system. Keep notes specific about what was checked and when it was considered. If a detail cannot be confirmed, say so clearly rather than filling the gap with an assumption or an unsupported claim.',5),(21,6,'Clear and professional communication','Clear communication uses direct language, a respectful tone, and information that is relevant to the student situation. Explain the current position without unnecessary technical terms or vague wording. A professional message should help the student understand what has happened and what may happen next. Before sending an update, check that the message is connected to the correct student or application and does not contain unsupported conclusions.',1),(22,6,'Explaining application progress','When explaining application progress, describe the current status and the action connected to it. If the application is waiting for review, information, or a response, state that clearly. Do not describe an uncertain outcome as confirmed. Students should be able to identify whether they need to respond, wait for another update, or ask a follow-up question. Accurate progress updates reduce confusion and support realistic expectations.',2),(23,6,'Requesting documents clearly','A document request should explain what information is needed, why it is relevant to the current step, and what the student should do next. Use a clear description rather than an unexplained abbreviation or general request for everything. Ask only for information connected to the work being completed. If the request is uncertain, check the application context before contacting the student so that the message is specific and useful.',3),(24,6,'Managing expectations','Managing expectations means explaining what is known, what is still uncertain, and what the next update may depend on. Avoid promising a result, date, or decision that has not been confirmed. A realistic message can still be helpful when it identifies the current step and the action available to the student. Consistent explanations help students make decisions based on the information that is actually available.',4),(25,6,'Recording important communication','Important communication should be recorded when it affects the student workflow, application status, required information, or next action. Notes should identify the main point without reproducing unnecessary personal details. Record updates accurately and in a way that another adviser can understand later. Good communication records support continuity, reduce repeated questions, and make it easier to explain how the current position was reached.',5),(26,7,'Respecting student information','Student information should be handled carefully because it relates to a real person and their education planning. Use information only for the work being completed and communicate it through the appropriate part of the system. Avoid casual sharing, unnecessary copying, or discussing personal details where they are not needed. Respectful handling protects student dignity and helps maintain confidence in the adviser workflow.',1),(27,7,'Collecting only necessary information','Collect only the information needed for the current task and the workflow supported by EduBridge. Before recording a detail, consider whether it is relevant to the student, programme, application, communication, or training activity being completed. Avoid collecting extra personal information simply because it may be useful later. Keeping records focused makes them easier to manage and reduces unnecessary exposure.',2),(28,7,'Access control and role permissions','Users should access student and application information through the role and permissions provided by the system. A user should not try to bypass those controls or view information outside the work they are authorised to complete. Role-based access supports appropriate separation between students, agents, and administrators. If access appears incorrect, report the issue instead of sharing credentials or using another person account.',3),(29,7,'Avoiding unnecessary exposure of personal data','Personal data should not be copied into unrelated messages, notes, screenshots, or files when it is not needed. When discussing a task, include only the information required for the recipient to understand and complete it. Check recipients and application context before sending an update. Reducing unnecessary exposure helps keep student records focused and lowers the chance of information reaching the wrong person.',4),(30,7,'Keeping records appropriate and secure','Records should contain accurate information that is relevant to the education workflow and suitable for other authorised users to review. Keep descriptions professional, avoid speculative comments, and remove unnecessary detail from routine updates. Use the available system controls and do not share account access. If information appears incorrect or exposed, record the issue through the appropriate internal process and avoid spreading it further.',5),(31,8,'Accurate information','Professional practice begins with using information that has been checked and recorded accurately. Confirm programme details, application status, and student updates before relying on them in a communication or decision. If information is incomplete, state that clearly and identify what still needs to be checked. Accuracy helps students make informed choices and allows other advisers to continue work without correcting avoidable errors.',1),(32,8,'Avoiding unsupported claims','An adviser should distinguish between confirmed information, reasonable interpretation, and uncertainty. Do not claim that a programme, outcome, or pathway is guaranteed when the available information does not support that statement. Avoid using confident language to fill a gap in knowledge. A responsible response explains what is known, points to the relevant information, and identifies when further confirmation is needed.',2),(33,8,'Professional boundaries','Professional boundaries help an adviser remain useful, respectful, and consistent. Support the student with education information and application workflow tasks that are within the role. Do not present personal preference as professional advice or make decisions on behalf of the student without appropriate information. When a question falls outside the available knowledge or role, explain the limitation and direct the issue to the appropriate source.',3),(34,8,'Clear records and accountability','Clear records show what information was considered, what action was taken, and what follow-up remains. Record meaningful decisions and updates without exaggeration or personal commentary. Accurate records allow another authorised user to understand the work and identify responsibility for the next step. Accountability is easier when actions are visible, explanations are consistent, and unsupported changes are not hidden.',4),(35,8,'Acting consistently and responsibly','Responsible practice means applying the same careful standard across students and applications. Check information, protect student details, communicate honestly, and update records when circumstances change. Do not allow urgency, personal preference, or convenience to replace a proper review. Consistent behaviour helps create a dependable workflow and gives students a clearer understanding of what they can expect from the adviser process.',5),(36,9,'How the NZQCF is organised','The New Zealand Qualifications and Credentials Framework has ten levels. The level indicates the complexity and expected learning outcomes of a qualification, not its subject area or prestige. Advisers should use the framework to describe how qualifications relate to one another and to explain progression clearly. When comparing options, check both the qualification type and its NZQCF level rather than relying only on programme names.',1),(37,9,'Levels 7 to 10','At the upper end of the framework, Level 7 includes bachelor’s degrees, graduate certificates and graduate diplomas; Level 8 includes bachelor honours degrees, postgraduate certificates and postgraduate diplomas; Level 9 is the master’s degree level; and Level 10 is doctoral study. These distinctions matter when explaining progression and when checking external rules that refer to qualification level.',2),(38,9,'Qualification type is not the same as subject','Two programmes can sit at the same NZQCF level while serving very different academic purposes. A Level 7 bachelor’s degree and a Level 7 graduate diploma are both Level 7 qualifications, but they differ in structure, entry route and intended learner profile. Advisers should explain the exact qualification type before discussing possible progression or external outcomes.',3),(39,9,'Using levels in programme comparison','When comparing programmes, record the qualification name, provider, NZQCF level, duration and study area separately. This prevents advisers from making assumptions based on a title alone. Level is useful for broad comparison, but provider-specific entry requirements, professional accreditation, programme content and progression rules still need to be checked from the current provider source.',4),(40,9,'Keeping framework information current','Framework terminology and programme approvals can change. Use NZQA or the relevant university/provider source when confirming a qualification. If a programme record in EduBridge conflicts with the provider’s current page, the provider and official qualification source take priority and the internal record should be flagged for review rather than treated as definitive.',5),(41,10,'Why provider checks matter','A programme should not be recommended only because its marketing looks attractive. Advisers should confirm that the education organisation is legitimate and that the programme is offered through the appropriate quality-assurance system. For international learners, providers enrolling international students must also meet the requirements associated with the Tertiary and International Learners Code of Practice.',1),(42,10,'Code signatory status','The Code of Practice supports learner wellbeing and safety. Providers that enrol international learners must be approved signatories to the Code. Advisers should understand that Code signatory status is different from a programme’s academic subject or ranking. It is a compliance and learner-protection check that should be considered when evaluating a provider for international study.',2),(43,10,'Quality assurance in New Zealand','NZQA quality-assures many tertiary education organisations, while universities operate within the university quality-assurance system. The important adviser behaviour is to check the appropriate official source rather than assume that every provider is monitored in the same way. Where a provider’s status is unclear, do not present it as verified until the official source confirms it.',3),(44,10,'Provider status versus programme fit','A provider can be legitimate and still not be the right fit for a particular student. After provider checks are complete, advisers should separately compare programme content, entry requirements, location, duration, learner support and likely progression. Compliance checks establish that an option is credible; they do not replace individual programme research.',4),(45,10,'Documenting provider verification','When an adviser confirms a provider or programme, record the source and the date checked where practical. If information is time-sensitive, note that it should be rechecked before an application is submitted. This creates a clearer audit trail and reduces the risk that old screenshots or outdated brochures are treated as current provider policy.',5),(46,11,'The role of an education agent','Education agents commonly support international student recruitment, provider applications, study information, translation and pre-departure preparation. The role is broader than sales. Agents are often an early source of information for learners and families, so inaccurate or incomplete information can affect learner decisions and provider reputation.',1),(47,11,'Accurate and sufficient information','Prospective learners should receive clear and sufficient information to make informed choices. Advisers should distinguish verified facts from assumptions, avoid guaranteeing outcomes, and update students when provider information changes. Programme entry requirements, fees, refund conditions and support services should be checked from current provider information rather than reused indefinitely from old cases.',2),(48,11,'Learner interests and conflicts','Commission arrangements are part of the education-agent business model, but recommendations should still be suitable for the learner. Advisers should recognise potential conflicts of interest and avoid presenting a programme as objectively superior simply because it has a better commercial arrangement. The learner’s goals, eligibility and study fit remain central to the recommendation process.',3),(49,11,'Complaints and poor conduct','Providers are expected to manage and monitor education-agent conduct. Complaints, misleading information, poor communication or repeated process failures can become agent-management issues. Advisers should keep clear records of important communication and escalate material complaints rather than hiding them or altering records after the event.',4),(50,11,'Working with provider processes','Different providers have different agent portals, application rules and communication channels. Advisers should follow the provider’s current process, respond to requests promptly and avoid bypassing controls designed to protect the learner or provider. Internal systems such as EduBridge should support, not replace, authoritative provider workflows.',5),(51,12,'Information versus immigration advice','Education advisers can explain publicly available study information, but personalised recommendations about which New Zealand visa a person should choose or how they should answer immigration questions can become immigration advice. The safest approach is to separate education guidance from personalised immigration strategy and to refer immigration advice when licensing rules require it.',1),(52,12,'Who generally needs a licence','New Zealand immigration advice is generally restricted to licensed immigration advisers or people who are legally exempt. The licensing requirement can apply even when advice is given outside New Zealand. Advisers should not assume that working for an education business automatically gives them authority to advise on New Zealand immigration matters.',2),(53,12,'Education-agent exemption limits','An education agent outside New Zealand may have a limited exemption for advice about student visas. That does not create a general exemption for work, visitor, residence or other immigration matters. An education agent in New Zealand is not covered by that offshore student-visa exemption. Location and the type of advice both matter.',3),(54,12,'When to refer a student','If a learner asks which immigration pathway they should choose, how a complex personal circumstance affects eligibility, or how to structure a response to improve a visa outcome, the issue may require regulated advice. Advisers should recognise the boundary early and refer the student to a licensed adviser or another legally exempt professional.',4),(55,12,'Safe internal practice','EduBridge training and Knowledge content should provide factual public information, not personalised immigration decisions. Staff should avoid language such as \'you will qualify\' or \'this visa is best for you\' unless the speaker is authorised to give that advice. Records should make clear when information was provided and when a referral was recommended.',5),(56,13,'Offer of place and study evidence','A fee-paying student visa application is built around an approved course of study and evidence from the education provider. Advisers supporting an education application should make sure the student’s programme details, provider information and study dates are consistent across provider documents and any information supplied for the visa process.',1),(57,13,'Tuition and living-cost evidence','Applicants must show that they can meet tuition and living-cost requirements that apply to their circumstances. Evidence requirements can change, so staff should use current Immigration New Zealand sources rather than fixed internal formulas. Where a case needs personalised advice about funding strategy or sponsorship, refer it appropriately.',2),(58,13,'Genuine intentions','Immigration New Zealand considers whether the applicant genuinely intends to study and comply with visa conditions. False, misleading or inconsistent evidence can create serious problems. Advisers should never invent explanations, alter documents or encourage a learner to hide relevant information. Internal records should match the documents actually supplied.',3),(59,13,'Health, character and translations','Depending on the application, health evidence, police certificates and translations may be required. Medical and police documents that are not in English have specific translation requirements. Advisers should check the current visa instructions and avoid treating requirements from one previous case as automatically applicable to every new applicant.',4),(60,13,'Evidence quality and final checks','Before a student submits a visa application, supporting files should be readable, logically named and consistent with the application. Important dates, names and programme details should match. A checklist can improve completeness, but it does not replace current Immigration New Zealand instructions or regulated advice where the student has complex circumstances.',5),(61,14,'Always check the actual visa conditions','Work rights are conditions attached to an individual student visa. Even when general rules allow work for certain students, the adviser should tell the learner to check the eVisa or visa letter that applies to them. Never assume that two students on similar programmes have identical conditions without checking the granted visa.',1),(62,14,'Part-time work during study','Eligible tertiary students may have conditions allowing part-time work for up to 25 hours a week while studying. Eligibility depends on the course and visa conditions. Advisers should present the general rule as information, not as a guarantee, and should direct students to the current Immigration New Zealand criteria if their situation is unclear.',2),(63,14,'Scheduled holidays and full-time work','Some student visas allow full-time work during scheduled holidays. This depends on the student’s course and visa conditions, and the provider’s academic calendar can be relevant. Students should not assume that any break between classes automatically qualifies as a scheduled holiday for full-time work.',3),(64,14,'Practical work that is part of study','Where practical work experience is a compulsory part of the programme, visa conditions may deal with that practical component separately from ordinary part-time work. Evidence from the provider or course outline may be relevant. Advisers should avoid describing optional employment as compulsory practical training unless the programme actually requires it.',4),(65,14,'Changes of provider or study','Changing provider, course or level of study can affect visa conditions and may require a new visa rather than a simple variation. Students should check the current immigration rules before making a study change. Education advisers can explain provider processes, while complex immigration consequences should be referred when regulated advice is required.',5),(66,15,'What a Pathway Student Visa does','A Pathway Student Visa can cover a planned sequence of up to three programmes on one visa and may be granted for up to five years. It is designed for structured progression rather than unrelated study changes. Advisers should confirm that the proposed study pathway and providers meet the current Pathway Student Visa rules.',1),(67,15,'Provider eligibility matters','The Pathway Student Visa is available only through eligible pathway education providers and approved study arrangements. A programme being academically suitable does not automatically make it eligible for the pathway visa. Provider and course eligibility should be checked from current Immigration New Zealand information.',2),(68,15,'Progression between programmes','Students still need to meet the prerequisites for later programmes in the pathway. A visa covering multiple planned stages does not guarantee academic progression. Advisers should explain entry conditions clearly and record any requirements that must be met before the student can move to the next programme.',3),(69,15,'Work rights depend on the course','A Pathway Student Visa may include work rights depending on the student’s course and circumstances. Work conditions should be checked on the visa itself. Advisers should not describe the pathway visa as automatically giving the same work rights throughout every stage of study.',4),(70,15,'When the pathway changes','If a student’s academic plan changes, the visa implications should be checked before the student changes provider or programme. The pathway visa offers flexibility within approved arrangements, but it is not unlimited permission to substitute any programme. Complex changes should be escalated to the appropriate immigration professional.',5),(71,16,'Why the student’s qualification matters','A student’s qualification can affect whether their partner may be eligible for a Partner of a Student Work Visa. Level 9 and 10 study can support this route, while some Level 7 and 8 qualifications may also qualify under specified rules. Advisers should verify the exact qualification rather than relying on a broad label such as \'postgraduate\'.',1),(72,16,'Partner work visa basics','Where the supporting student meets the relevant study requirements, the partner may be able to apply for a work visa. The partner must also meet requirements that apply to their own application, including partnership and other visa criteria. Education advisers should describe the public rule but avoid deciding eligibility for a complex relationship case.',2),(73,16,'Dependent children','Family options can depend on the visa held by the student or their partner. In some situations, a partner who obtains a work visa may then be able to support student visas for dependent children. Because family pathways are case-specific, advisers should use current Immigration New Zealand information and refer complex questions appropriately.',3),(74,16,'Relationship evidence is separate','Qualification eligibility is only one part of a partner application. The applicant must still satisfy the relationship requirements that apply to partnership-based visas. Advisers should not tell a couple that the partner visa is guaranteed simply because the student is studying a qualifying programme.',4),(75,16,'How to discuss family outcomes safely','When comparing programmes, it is reasonable to note that qualification level can affect possible family visa options. The adviser should state that immigration eligibility must be checked separately and may depend on current policy and personal circumstances. This keeps programme guidance useful without turning it into unlicensed immigration advice.',5),(76,17,'Purpose of the Post-Study Work Visa','The Post-Study Work Visa allows eligible graduates to remain and work in New Zealand after completing qualifying study. The possible visa duration and work conditions depend on the qualification and current immigration rules. Advisers should not advertise a programme as guaranteeing a specific work visa without checking the current eligibility criteria.',1),(77,17,'Degree-level qualifications','Degree-level study at Level 7 or above can support post-study work eligibility when the applicable study requirements are met. For degree-level qualifications, work rights are generally broader than for eligible non-degree qualifications. The exact duration still depends on the qualification and study completed.',2),(78,17,'Level 7 graduate diploma change in 2026','From 16 November 2026, eligibility is being extended to certain Level 7 graduate diploma graduates who also hold a bachelor’s degree and meet the specified New Zealand full-time study conditions. Advisers should use the effective date and full rule, not present every Level 7 graduate diploma as automatically eligible.',3),(79,17,'Postgraduate diplomas and master’s degrees','Current Immigration New Zealand information notes that eligible Level 8 postgraduate diploma graduates may qualify for a one-year Post-Study Work Visa, while eligible Level 9 master’s graduates may qualify for up to three years. Programme length, completion and other visa criteria still need to be checked.',4),(80,17,'Programme advice versus immigration outcomes','Post-study work information can be relevant when a student compares programmes, but it should not become a promise of employment or residence. Advisers should explain the current public rule, identify the qualification level correctly, and encourage students to check immigration rules again before making major financial decisions.',5),(81,18,'Collect only what is needed','Personal information should be collected for a lawful purpose connected with the organisation’s work, and the collection should be necessary for that purpose. Advisers should avoid gathering identity documents, family details or financial information simply because they might be useful later. If the information is not needed for the current process, do not collect it by default.',1),(82,18,'Tell people about collection','When information is collected directly from a learner, they should be informed about the collection, its purpose and other relevant matters. From 1 May 2026, Privacy Principle 3A also adds notification requirements for certain indirect collection. Internal workflows should make the source and purpose of important learner data clear.',2),(83,18,'Keep learner information secure','Access to learner information should be limited to people who need it for their role. Screenshots, exported spreadsheets and messaging apps can create uncontrolled copies of personal data. Use approved systems where possible, avoid sharing unnecessary identifiers, and treat downloaded documents as sensitive records rather than casual working files.',3),(84,18,'Use information for the right purpose','Information collected for an application or support process should not automatically be reused for unrelated marketing or other purposes. Before reusing or disclosing learner information, staff should check whether that use is consistent with the original purpose or otherwise permitted. Convenience is not a sufficient reason to broaden use.',4),(85,18,'Access, correction and good records','Learners have privacy rights that include access to and correction of personal information in appropriate circumstances. Good internal records should be accurate, relevant and understandable. If a student points out an error, staff should follow the organisation’s correction process rather than silently creating conflicting versions across systems.',5);
/*!40000 ALTER TABLE `trainingmodulesections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainingprogress`
--

DROP TABLE IF EXISTS `trainingprogress`;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainingprogress`
--

LOCK TABLES `trainingprogress` WRITE;
/*!40000 ALTER TABLE `trainingprogress` DISABLE KEYS */;
INSERT INTO `trainingprogress` VALUES (1,3,1,'2026-09-15 06:43:40'),(2,1,1,'2026-09-17 09:40:31'),(3,4,1,'2026-09-22 08:34:01'),(4,4,9,'2026-09-22 11:54:52');
/*!40000 ALTER TABLE `trainingprogress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainingquizattempts`
--

DROP TABLE IF EXISTS `trainingquizattempts`;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainingquizattempts`
--

LOCK TABLES `trainingquizattempts` WRITE;
/*!40000 ALTER TABLE `trainingquizattempts` DISABLE KEYS */;
INSERT INTO `trainingquizattempts` VALUES (1,4,1,0,4,0,'2026-09-22 20:33:08'),(2,4,1,3,4,1,'2026-09-22 20:34:01'),(3,4,7,1,4,0,'2026-09-22 20:53:41'),(4,4,9,1,4,0,'2026-09-22 23:54:36'),(5,4,9,3,4,1,'2026-09-22 23:54:52'),(6,4,9,4,4,1,'2026-09-22 23:55:18');
/*!40000 ALTER TABLE `trainingquizattempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainingquizquestions`
--

DROP TABLE IF EXISTS `trainingquizquestions`;
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
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainingquizquestions`
--

LOCK TABLES `trainingquizquestions` WRITE;
/*!40000 ALTER TABLE `trainingquizquestions` DISABLE KEYS */;
INSERT INTO `trainingquizquestions` VALUES (1,1,'What should an adviser identify before comparing programmes?','The student goal','The cheapest available option','The most popular provider','The shortest programme','A',1),(2,1,'What should be compared when reviewing providers and qualifications?','Only the programme title','The provider, programme structure and qualification level','Only the study location','Only the programme duration','B',2),(3,1,'What should be reviewed for each programme before deciding whether it is suitable?','The adviser\'s personal preference','The provider\'s advertising style','The published academic and English-language entry requirements','The number of other students enrolled','C',3),(4,1,'How should a programme comparison be recorded?','As unsupported claims about the best programme','Only by recording the programme title','Without recording important differences','Clearly enough for another adviser to understand the differences','D',4),(5,2,'What should an adviser understand when following an application workflow?','Only the student name','The programme, submitted information, current stage, and next action','Only the final outcome','Only the application date','B',1),(6,2,'What should an adviser do when application information is unclear or incomplete?','Choose the most likely information','Ignore the issue until the application is finished','Move the application to a later stage','Record the issue and request clarification','D',2),(7,2,'What should an application status represent?','The current stage of work','How quickly the adviser wants the application completed','The preferred outcome','The number of notes in the record','A',3),(8,2,'How should an adviser communicate application progress?','Promise the student a confirmed result','Use general wording without explaining the next step','Explain what has happened and what still needs to happen without making unsupported promises','Wait until the application is complete before communicating','C',4),(9,4,'Why does EduBridge bring programmes, students, applications, training, knowledge, messages, and updates into one workspace?','To replace the need to review information','To allow every user to access every record','To help adviser work stay organised and visible','To guarantee application outcomes','C',1),(10,4,'What should an adviser do when a student record contains incomplete information?','Avoid making assumptions and review the relevant available information','Fill the missing information with a likely answer','Delete the student record','Ignore all related applications','A',2),(11,4,'What should an application record support?','A collection of unsupported notes','The next action in the student workflow','Only the programme title','Only the final outcome','D',3),(12,4,'How should programmes, training, and knowledge articles be used in EduBridge?','As interchangeable sources for every decision','With their different purposes kept clear','Only after an application is completed','Only for recording student contact details','B',4),(13,5,'When comparing study options, what should an adviser identify instead of relying only on a broad subject label?','Only the programme duration','Only the qualification level','Only the study location','The specific provider and programme','D',1),(14,5,'How should qualification level be considered when comparing a programme?','As automatic proof that the programme is better','Together with programme structure, subject area, entry requirements, and the student goal','As the only factor in a study decision','As a replacement for checking provider information','B',2),(15,5,'What should an adviser do when entry requirements for a programme are unclear?','Assume that similar programmes have the same requirements','Treat the programme as unsuitable immediately','Record the uncertainty and direct the student to confirm current information with the provider','Create requirements that appear reasonable','C',3),(16,5,'What should be considered when comparing possible study pathways?','The student goal and the available information about subject, level, structure, requirements, location, and duration','Only the programme title','Only the provider name','Only the shortest study duration','A',4),(17,6,'What makes a student communication clear and professional?','Direct language, a respectful tone, and information relevant to the situation','A long message containing every available record','Technical terms that the student may not understand','A confident outcome even when it is unconfirmed','A',1),(18,6,'What should an adviser explain when updating a student about application progress?','Only that the application exists','A result that has not been confirmed','The current status and the action connected to it','Only the date of the original application','C',2),(19,6,'What should a clear document request explain?','That every available document should be sent','What is needed, why it is relevant, and what the student should do next','Only the adviser preferred file format','A final application outcome','B',3),(20,6,'How should an adviser manage student expectations?','Promise a result or date to reassure the student','Avoid explaining uncertainty','Wait until every detail is known before communicating','Explain what is known, what is uncertain, and what the next step may depend on','D',4),(21,7,'How should student information be handled during adviser work?','Use it only for the work being completed and communicate it through the appropriate system area','Copy it into every related message','Share it casually with other users','Discuss it whenever it may be interesting','B',1),(22,7,'What information should be collected for a current workflow?','Only information needed for the task and supported workflow','Any personal information that might be useful later','All information available about the student','Information unrelated to the current application','A',2),(23,7,'What should a user do if system access appears incorrect?','Share another users credentials','Try to bypass the role controls','View the information before reporting the issue','Report the issue instead of bypassing the controls','D',3),(24,7,'How can an adviser reduce unnecessary exposure of personal data?','Copy personal data into unrelated files for convenience','Include all available details in every update','Include only the information required for the recipient to complete the task','Send the information to a wider group','C',4),(25,8,'What should an adviser do before relying on programme or application information?','Confirm that the information has been checked and recorded accurately','Assume that older information is still correct','Use the information that sounds most positive','Replace unclear information with a personal opinion','C',1),(26,8,'How should an adviser respond when the available information does not support a guaranteed outcome?','Present the outcome confidently anyway','Avoid mentioning the uncertainty','Choose the most favourable interpretation','Explain what is known and identify what still needs confirmation','D',2),(27,8,'What is an appropriate professional boundary?','Support education and application tasks within the role and explain limitations when needed','Make decisions for the student without sufficient information','Present personal preference as confirmed advice','Answer every question regardless of available knowledge','A',3),(28,8,'What do clear records help another authorised user understand?','Only the adviser personal preference','What information was considered, what action was taken, and what follow-up remains','Only the final result','Only the date of the last login','B',4),(29,9,'What does an NZQCF level primarily indicate?','The subject area of a programme','The complexity and expected learning outcomes of a qualification','The provider\'s ranking','The programme\'s tuition fee','B',1),(30,9,'Which qualification type is normally at NZQCF Level 9?','Graduate Diploma','Bachelor Honours Degree','Master\'s Degree','Doctoral Degree','C',2),(31,9,'Why should an adviser record qualification type separately from level?','Because different qualification types can sit at the same level','Because level is only used by universities','Because qualification type replaces provider research','Because every subject has its own level','A',3),(32,9,'What should happen if an internal programme record conflicts with the provider\'s current page?','Use the old internal record','Average the two versions','Ignore the provider page','Flag the internal record and use the authoritative current source','D',4),(33,10,'What additional status is important for a provider enrolling international learners?','Membership of a student club','Signatory status under the learner Code','A high social-media following','A commission agreement','B',1),(34,10,'What does provider quality verification establish?','That the programme is automatically suitable for every student','That the provider is the cheapest option','That the option is credible before individual fit is assessed','That immigration approval is guaranteed','C',2),(35,10,'Why should advisers record a source and date when practical?','To create a clearer audit trail for time-sensitive information','To avoid checking provider information again','To replace official provider systems','To increase application speed automatically','A',3),(36,10,'If a provider\'s status is unclear, what should an adviser do?','Present it as verified','Assume the marketing material is enough','Ask the student to decide','Wait for confirmation from the appropriate official source','D',4),(37,11,'Which is a common education-agent service identified by NZQA?','Issuing New Zealand visas','Changing government policy','Assisting with provider applications','Guaranteeing admission','C',1),(38,11,'What should guide a programme recommendation where commission is involved?','The highest commission','The learner\'s goals, eligibility and study fit','The fastest application portal','The provider with the most advertising','B',2),(39,11,'How should material learner complaints be handled?','Escalated and recorded appropriately','Deleted after resolution','Kept only in private messages','Ignored if the application succeeds','A',3),(40,11,'What should internal systems such as EduBridge do in relation to provider workflows?','Replace them entirely','Bypass their controls','Support them without pretending to be the authoritative provider system','Automatically approve exceptions','C',4),(41,12,'Which activity is most likely to be immigration advice?','Reading a university programme title','Explaining a provider\'s application deadline','Recommending which visa pathway a person should choose','Giving a campus address','C',1),(42,12,'Who generally may provide New Zealand immigration advice?','Any education agent','Licensed advisers or people who are legally exempt','Any person outside New Zealand','Any university graduate','B',2),(43,12,'What is a key limit on the offshore education-agent exemption?','It applies only to advice about student visas','It applies to residence visas only','It applies only in New Zealand','It removes all licensing rules','A',3),(44,12,'What should an unlicensed adviser do with a complex personalised immigration question?','Give a best guess','Reuse advice from another case','Refer the student to an authorised professional','Rewrite the question as programme advice','C',4),(45,13,'What should an adviser do when visa evidence requirements may have changed?','Use the last successful case','Use current Immigration New Zealand information','Use a social-media post','Assume the provider decides all visa evidence','B',1),(46,13,'Why is genuine-intentions evidence important?','It can be invented if the student has a strong academic record','INZ considers whether the student genuinely intends to study and comply with conditions','It replaces an offer of place','It is only relevant to visitor visas','B',2),(47,13,'What is a safe approach to health and police document requirements?','Apply every requirement from a previous case to all students','Check the current visa instructions for the applicant\'s circumstances','Never submit translations','Let the agent create replacement documents','B',3),(48,13,'What should a final evidence check focus on?','Readable, consistent documents and matching key details','Making every file as large as possible','Removing dates from documents','Changing provider information to match the application','A',4),(49,14,'Where should a student confirm their actual work rights?','On another student\'s visa','On their own eVisa or visa letter','In the programme brochure only','From an employer\'s preference','B',1),(50,14,'What is the current general part-time limit for eligible students?','10 hours','20 hours','25 hours','40 hours','C',2),(51,14,'Does any gap between classes automatically count as a scheduled holiday for full-time work?','Yes','No','Only if the student prefers','Only for postgraduate students','B',3),(52,14,'What should happen before a student changes provider or study level?','Assume the visa is unaffected','Check the possible visa consequences under current rules','Wait until after the change','Ask the new employer','B',4),(53,15,'What is the maximum number of programmes that a Pathway Student Visa can cover?','1','2','3','Unlimited','C',1),(54,15,'Can any education provider automatically support a Pathway Student Visa?','Yes','No, provider and pathway eligibility must be checked','Only universities can','Only private providers can','B',2),(55,15,'Does a pathway visa guarantee academic progression to later programmes?','Yes','No, the student must still meet progression requirements','Only for master\'s programmes','Only if tuition is prepaid','B',3),(56,15,'What should an adviser do if the planned pathway changes materially?','Assume the original visa covers any substitute course','Check the immigration implications before the change','Ignore the change until renewal','Change the database only','B',4),(57,16,'Which study level generally supports a partner work visa under the broad rule?','Level 3','Level 5','Level 9 or 10','Any short course','C',1),(58,16,'Can some Level 7 or 8 qualifications also support partner work eligibility?','No, never','Yes, where they meet specified rules','Only if the provider is private','Only if the student is under 25','B',2),(59,16,'Is qualification level the only requirement for a partner work visa?','Yes','No, the partner must also meet their own visa and relationship requirements','Only for married couples','Only for PhD students','B',3),(60,16,'How should an adviser describe family visa implications during programme comparison?','As guaranteed outcomes','As possible implications that need separate immigration checking','As irrelevant to programme choice','As provider-controlled benefits','B',4),(61,17,'What is the purpose of the Post-Study Work Visa?','To replace a student visa before study starts','To allow eligible graduates to work in New Zealand after qualifying study','To guarantee residence','To fund tuition fees','B',1),(62,17,'What change takes effect from 16 November 2026 for some Level 7 graduate diploma graduates?','All graduate diplomas become Level 9','Some may become eligible for a Post-Study Work Visa if specified conditions are met','They automatically receive residence','They no longer need a bachelor’s degree','B',2),(63,17,'What may an eligible Level 9 master\'s graduate qualify for under current rules?','Up to a three-year Post-Study Work Visa','A guaranteed resident visa','A ten-year student visa','Unlimited study without a visa','A',3),(64,17,'How should post-study work information be presented in programme advice?','As a guaranteed employment outcome','As current public information that must be checked again before major decisions','As a provider scholarship','As proof of residence eligibility','B',4),(65,18,'What is the best privacy approach to collecting learner information?','Collect everything in case it is useful later','Collect only information necessary for a lawful purpose','Collect only financial information','Collect data only by email','B',1),(66,18,'What new notification area applies from 1 May 2026 under IPP 3A?','Indirect collection of personal information in relevant circumstances','All information must be public','Students lose correction rights','Providers cannot use databases','A',2),(67,18,'Why are uncontrolled screenshots and exports a privacy risk?','They can create unnecessary copies of sensitive learner information','They always improve security','They automatically encrypt data','They remove access risks','A',3),(68,18,'What should happen when a learner identifies an error in their information?','Ignore it once the application is submitted','Follow the organisation\'s correction process','Delete the whole record','Create a second conflicting version','B',4);
/*!40000 ALTER TABLE `trainingquizquestions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainingresources`
--

DROP TABLE IF EXISTS `trainingresources`;
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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainingresources`
--

LOCK TABLES `trainingresources` WRITE;
/*!40000 ALTER TABLE `trainingresources` DISABLE KEYS */;
INSERT INTO `trainingresources` VALUES (16,1,'Official Link','Explore Courses & Programmes in New Zealand','https://www.studywithnewzealand.govt.nz/en/study-options/courses-and-programmes','Study with New Zealand',1,'2026-09-24 21:05:13'),(17,1,'Official Link','About the NZQCF','https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/','NZQA',2,'2026-09-24 21:05:13'),(18,2,'Official Link','5 Steps to studying in New Zealand','https://www.studywithnewzealand.govt.nz/en/plan-your-studies/steps-to-studying-in-new-zealand','Study with New Zealand',1,'2026-09-24 21:05:13'),(19,2,'Official Link','Agent Application Centre','https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-application-centre.html','University of Auckland',2,'2026-09-24 21:05:13'),(20,4,'YouTube','What\'s it like to be an international student studying in New Zealand?','https://www.youtube.com/watch?v=zZWAuE4O4Qg','Study with New Zealand',1,'2026-09-24 21:05:13'),(21,4,'Official Link','Study with New Zealand','https://www.studywithnewzealand.govt.nz/','Education New Zealand',2,'2026-09-24 21:05:13'),(22,5,'Official Link','New Zealand education quality and standards','https://www.studywithnewzealand.govt.nz/en/why-new-zealand/education-system/quality-and-standards','Study with New Zealand',1,'2026-09-24 21:05:13'),(23,5,'Official Link','About the NZQCF','https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/','NZQA',2,'2026-09-24 21:05:13'),(24,6,'Official Link','Guide to managing education agents','https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/','NZQA',1,'2026-09-24 21:05:13'),(25,6,'Official Link','Working with education agents','https://www.studywithnewzealand.govt.nz/en/plan-your-studies/education-agents','Study with New Zealand',2,'2026-09-24 21:05:13'),(26,7,'Official Link','Privacy principles','https://www.privacy.org.nz/privacy-principles/','Office of the Privacy Commissioner',1,'2026-09-24 21:05:13'),(27,7,'Official Link','What are the privacy principles?','https://www.privacy.org.nz/resources-and-learning/knowledge-base/view/376/','Office of the Privacy Commissioner',2,'2026-09-24 21:05:13'),(28,8,'Official Link','Guide to managing education agents','https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/','NZQA',1,'2026-09-24 21:05:13'),(29,8,'Official Link','Information for education agents','https://www.iaa.govt.nz/can-i-give-advice/information-for-education-agents/','Immigration Advisers Authority',2,'2026-09-24 21:05:13'),(30,9,'Official Link','About the NZQCF','https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/','NZQA',1,'2026-09-24 21:05:13'),(31,9,'Official Link','Understanding the NZQCF','https://www2.nzqa.govt.nz/about-us/news/understanding-the-new-zealand-qualifications-and-credentials-framework/','NZQA',2,'2026-09-24 21:05:13'),(32,10,'Official Link','The Tertiary and International Learners Code of Practice','https://www2.nzqa.govt.nz/tertiary/the-code/','NZQA',1,'2026-09-24 21:05:13'),(33,10,'Official Link','Education agents for tertiary providers','https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/code-resources-for-tertiary-providers/education-agents-for-tertiary/','NZQA',2,'2026-09-24 21:05:13'),(34,11,'Official Link','Guide to managing education agents','https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/','NZQA',1,'2026-09-24 21:05:13'),(35,11,'Official Link','Education agents for tertiary providers','https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/code-resources-for-tertiary-providers/education-agents-for-tertiary/','NZQA',2,'2026-09-24 21:05:13'),(36,12,'Official Link','Information for education agents','https://www.iaa.govt.nz/can-i-give-advice/information-for-education-agents/','Immigration Advisers Authority',1,'2026-09-24 21:05:13'),(37,12,'Official Link','Information for education providers','https://www.iaa.govt.nz/can-i-give-advice/information-for-education-providers/','Immigration Advisers Authority',2,'2026-09-24 21:05:13'),(38,13,'YouTube','Applying for a Student Visa to Study in New Zealand','https://www.youtube.com/watch?v=xcMWJ-yJ9KU','Study with New Zealand',1,'2026-09-24 21:05:13'),(39,13,'Official Link','Fee Paying Student Visa','https://www.immigration.govt.nz/visas/fee-paying-student-visa/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(40,13,'Official Link','Student fund requirements','https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/student-fund-requirements/','Immigration New Zealand',3,'2026-09-24 21:05:13'),(41,14,'Official Link','Working on a student visa','https://www.immigration.govt.nz/study/once-you-have-a-student-visa/working-on-a-student-visa/','Immigration New Zealand',1,'2026-09-24 21:05:13'),(42,14,'Official Link','Once you have a student visa','https://www.immigration.govt.nz/study/once-you-have-a-student-visa/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(43,15,'Official Link','Pathway Student Visa','https://www.immigration.govt.nz/visas/pathway-student-visa/','Immigration New Zealand',1,'2026-09-24 21:05:13'),(44,15,'Official Link','Pathway Student Visa education providers','https://www.immigration.govt.nz/study/study-visas/pathway-student-visa-education-providers/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(45,16,'YouTube','Can I bring my family when I study in New Zealand?','https://www.youtube.com/watch?v=ngpz9YFaxgU','Study with New Zealand',1,'2026-09-24 21:05:13'),(46,16,'Official Link','Partner of a Student Work Visa','https://www.immigration.govt.nz/visas/partner-of-a-student-work-visa/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(47,17,'Official Link','Post-Study Work Visa','https://www.immigration.govt.nz/visas/post-study-work-visa/','Immigration New Zealand',1,'2026-09-24 21:05:13'),(48,17,'Official Link','Staying to work after finishing your study','https://www.immigration.govt.nz/study/after-you-finish-your-study/staying-to-work-after-finishing-your-study/','Immigration New Zealand',2,'2026-09-24 21:05:13'),(49,17,'Official Link','New and updated post-study work visa options','https://www.immigration.govt.nz/about-us/news-centre/new-and-updated-post-study-work-visa-options/','Immigration New Zealand',3,'2026-09-24 21:05:13'),(50,18,'Official Link','Privacy principles','https://www.privacy.org.nz/privacy-principles/','Office of the Privacy Commissioner',1,'2026-09-24 21:05:13'),(51,18,'Official Link','What are the privacy principles?','https://www.privacy.org.nz/resources-and-learning/knowledge-base/view/376/','Office of the Privacy Commissioner',2,'2026-09-24 21:05:13');
/*!40000 ALTER TABLE `trainingresources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','20f107c5137e7c64fc12824748c5ba66:b25b94d3dcb6a2aef02913c45d5f0e8a7189d2f9f493ff706b8ccf449c5754bbe5c3d92795f2cfbf19e9d94bcab80736693fe92fd4b13650f5b0986663630863','a@a','admin',NULL),(3,'abc','0296a37ef02bccc8e0bc0f6de00cd0dc:0e2cf84980cd9752a588dba73dedda31948903bc4818cff952d455505122d6636d927a1007f8b7e0f85a1dd402b200195b75ff28aaa87f675730adfe11a90a9d','abc@a.com','student',4),(4,'agent','e0ba4bff5017166d50cdd60d2cad88e7:c1801064080629d9b8c0fb0bccbd74b9c22d01206a6256202b5ba1d11f3c09cdc1e24aab9c1fe36424759c3ffa11292a7d04b32c1b70fc791903a90f15d7e3aa','b@b.com','agent',NULL),(5,'student','55c50afe790071146cd79834ca45e194:42dd924d13b975ee0ba161b80866aeeba4d40fa993de76f55d234f56923f9e8dd8a64c8b904f6cae93f407d1c4bcbb09db09dc81c863a8f9493a9864bd16be29','c@c.com','student',4),(6,'sss','9103aa36a833e6c01399081d3aed0a99:841b25d67712b1b45947a253f2ed3b703c5998cd8a3b5549d949a88f7b7ae5f307f1dd959b2c256126c7353ae191133aa3ad87ee7abf84206e8ac2503333d19b','justin2tang@gmail.com','student',4);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-24 20:54:05
