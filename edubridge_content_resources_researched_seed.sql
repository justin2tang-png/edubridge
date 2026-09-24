-- EduBridge researched content resources seed
-- Generated 2026-09-24 from current official NZ sources and official Study with New Zealand YouTube.
START TRANSACTION;

-- Training: Programme Research and Comparison
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Explore Courses & Programmes in New Zealand', 'https://www.studywithnewzealand.govt.nz/en/study-options/courses-and-programmes', 'Study with New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Programme Research and Comparison'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.studywithnewzealand.govt.nz/en/study-options/courses-and-programmes');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'About the NZQCF', 'https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/', 'NZQA', 2
FROM trainingModules tm
WHERE tm.title = 'Programme Research and Comparison'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/');

-- Training: Managing Student Applications
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', '5 Steps to studying in New Zealand', 'https://www.studywithnewzealand.govt.nz/en/plan-your-studies/steps-to-studying-in-new-zealand', 'Study with New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Managing Student Applications'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.studywithnewzealand.govt.nz/en/plan-your-studies/steps-to-studying-in-new-zealand');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Agent Application Centre', 'https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-application-centre.html', 'University of Auckland', 2
FROM trainingModules tm
WHERE tm.title = 'Managing Student Applications'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-application-centre.html');

-- Training: Introduction to EduBridge
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'YouTube', 'What''s it like to be an international student studying in New Zealand?', 'https://www.youtube.com/watch?v=zZWAuE4O4Qg', 'Study with New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Introduction to EduBridge'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.youtube.com/watch?v=zZWAuE4O4Qg');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Study with New Zealand', 'https://www.studywithnewzealand.govt.nz/', 'Education New Zealand', 2
FROM trainingModules tm
WHERE tm.title = 'Introduction to EduBridge'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.studywithnewzealand.govt.nz/');

-- Training: Understanding the New Zealand Education System
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'New Zealand education quality and standards', 'https://www.studywithnewzealand.govt.nz/en/why-new-zealand/education-system/quality-and-standards', 'Study with New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Understanding the New Zealand Education System'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.studywithnewzealand.govt.nz/en/why-new-zealand/education-system/quality-and-standards');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'About the NZQCF', 'https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/', 'NZQA', 2
FROM trainingModules tm
WHERE tm.title = 'Understanding the New Zealand Education System'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/');

-- Training: Supporting Student Communication
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Guide to managing education agents', 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/', 'NZQA', 1
FROM trainingModules tm
WHERE tm.title = 'Supporting Student Communication'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Working with education agents', 'https://www.studywithnewzealand.govt.nz/en/plan-your-studies/education-agents', 'Study with New Zealand', 2
FROM trainingModules tm
WHERE tm.title = 'Supporting Student Communication'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.studywithnewzealand.govt.nz/en/plan-your-studies/education-agents');

-- Training: Privacy and Data Handling
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Privacy principles', 'https://www.privacy.org.nz/privacy-principles/', 'Office of the Privacy Commissioner', 1
FROM trainingModules tm
WHERE tm.title = 'Privacy and Data Handling'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.privacy.org.nz/privacy-principles/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'What are the privacy principles?', 'https://www.privacy.org.nz/resources-and-learning/knowledge-base/view/376/', 'Office of the Privacy Commissioner', 2
FROM trainingModules tm
WHERE tm.title = 'Privacy and Data Handling'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.privacy.org.nz/resources-and-learning/knowledge-base/view/376/');

-- Training: Ethics and Professional Practice
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Guide to managing education agents', 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/', 'NZQA', 1
FROM trainingModules tm
WHERE tm.title = 'Ethics and Professional Practice'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Information for education agents', 'https://www.iaa.govt.nz/can-i-give-advice/information-for-education-agents/', 'Immigration Advisers Authority', 2
FROM trainingModules tm
WHERE tm.title = 'Ethics and Professional Practice'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.iaa.govt.nz/can-i-give-advice/information-for-education-agents/');

-- Training: NZQCF Qualification Levels for Education Advisers
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'About the NZQCF', 'https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/', 'NZQA', 1
FROM trainingModules tm
WHERE tm.title = 'NZQCF Qualification Levels for Education Advisers'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Understanding the NZQCF', 'https://www2.nzqa.govt.nz/about-us/news/understanding-the-new-zealand-qualifications-and-credentials-framework/', 'NZQA', 2
FROM trainingModules tm
WHERE tm.title = 'NZQCF Qualification Levels for Education Advisers'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/about-us/news/understanding-the-new-zealand-qualifications-and-credentials-framework/');

-- Training: Checking Provider Quality and Code Signatory Status
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'The Tertiary and International Learners Code of Practice', 'https://www2.nzqa.govt.nz/tertiary/the-code/', 'NZQA', 1
FROM trainingModules tm
WHERE tm.title = 'Checking Provider Quality and Code Signatory Status'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/tertiary/the-code/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Education agents for tertiary providers', 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/code-resources-for-tertiary-providers/education-agents-for-tertiary/', 'NZQA', 2
FROM trainingModules tm
WHERE tm.title = 'Checking Provider Quality and Code Signatory Status'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/code-resources-for-tertiary-providers/education-agents-for-tertiary/');

-- Training: Education Agent Responsibilities under the Learner Code
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Guide to managing education agents', 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/', 'NZQA', 1
FROM trainingModules tm
WHERE tm.title = 'Education Agent Responsibilities under the Learner Code'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Education agents for tertiary providers', 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/code-resources-for-tertiary-providers/education-agents-for-tertiary/', 'NZQA', 2
FROM trainingModules tm
WHERE tm.title = 'Education Agent Responsibilities under the Learner Code'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/code-resources-for-tertiary-providers/education-agents-for-tertiary/');

-- Training: Immigration Advice Boundaries for Education Agents
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Information for education agents', 'https://www.iaa.govt.nz/can-i-give-advice/information-for-education-agents/', 'Immigration Advisers Authority', 1
FROM trainingModules tm
WHERE tm.title = 'Immigration Advice Boundaries for Education Agents'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.iaa.govt.nz/can-i-give-advice/information-for-education-agents/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Information for education providers', 'https://www.iaa.govt.nz/can-i-give-advice/information-for-education-providers/', 'Immigration Advisers Authority', 2
FROM trainingModules tm
WHERE tm.title = 'Immigration Advice Boundaries for Education Agents'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.iaa.govt.nz/can-i-give-advice/information-for-education-providers/');

-- Training: Fee-Paying Student Visa Evidence Essentials
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'YouTube', 'Applying for a Student Visa to Study in New Zealand', 'https://www.youtube.com/watch?v=xcMWJ-yJ9KU', 'Study with New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Fee-Paying Student Visa Evidence Essentials'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.youtube.com/watch?v=xcMWJ-yJ9KU');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Fee Paying Student Visa', 'https://www.immigration.govt.nz/visas/fee-paying-student-visa/', 'Immigration New Zealand', 2
FROM trainingModules tm
WHERE tm.title = 'Fee-Paying Student Visa Evidence Essentials'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/visas/fee-paying-student-visa/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Student fund requirements', 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/student-fund-requirements/', 'Immigration New Zealand', 3
FROM trainingModules tm
WHERE tm.title = 'Fee-Paying Student Visa Evidence Essentials'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/student-fund-requirements/');

-- Training: Student Work Rights and Study Conditions
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Working on a student visa', 'https://www.immigration.govt.nz/study/once-you-have-a-student-visa/working-on-a-student-visa/', 'Immigration New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Student Work Rights and Study Conditions'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/study/once-you-have-a-student-visa/working-on-a-student-visa/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Once you have a student visa', 'https://www.immigration.govt.nz/study/once-you-have-a-student-visa/', 'Immigration New Zealand', 2
FROM trainingModules tm
WHERE tm.title = 'Student Work Rights and Study Conditions'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/study/once-you-have-a-student-visa/');

-- Training: Pathway Student Visas and Study Progression
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Pathway Student Visa', 'https://www.immigration.govt.nz/visas/pathway-student-visa/', 'Immigration New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Pathway Student Visas and Study Progression'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/visas/pathway-student-visa/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Pathway Student Visa education providers', 'https://www.immigration.govt.nz/study/study-visas/pathway-student-visa-education-providers/', 'Immigration New Zealand', 2
FROM trainingModules tm
WHERE tm.title = 'Pathway Student Visas and Study Progression'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/study/study-visas/pathway-student-visa-education-providers/');

-- Training: Partner and Family Visa Awareness for Student Advisers
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'YouTube', 'Can I bring my family when I study in New Zealand?', 'https://www.youtube.com/watch?v=ngpz9YFaxgU', 'Study with New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Partner and Family Visa Awareness for Student Advisers'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.youtube.com/watch?v=ngpz9YFaxgU');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Partner of a Student Work Visa', 'https://www.immigration.govt.nz/visas/partner-of-a-student-work-visa/', 'Immigration New Zealand', 2
FROM trainingModules tm
WHERE tm.title = 'Partner and Family Visa Awareness for Student Advisers'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/visas/partner-of-a-student-work-visa/');

-- Training: Post-Study Work Pathways after New Zealand Study
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Post-Study Work Visa', 'https://www.immigration.govt.nz/visas/post-study-work-visa/', 'Immigration New Zealand', 1
FROM trainingModules tm
WHERE tm.title = 'Post-Study Work Pathways after New Zealand Study'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/visas/post-study-work-visa/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Staying to work after finishing your study', 'https://www.immigration.govt.nz/study/after-you-finish-your-study/staying-to-work-after-finishing-your-study/', 'Immigration New Zealand', 2
FROM trainingModules tm
WHERE tm.title = 'Post-Study Work Pathways after New Zealand Study'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/study/after-you-finish-your-study/staying-to-work-after-finishing-your-study/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'New and updated post-study work visa options', 'https://www.immigration.govt.nz/about-us/news-centre/new-and-updated-post-study-work-visa-options/', 'Immigration New Zealand', 3
FROM trainingModules tm
WHERE tm.title = 'Post-Study Work Pathways after New Zealand Study'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.immigration.govt.nz/about-us/news-centre/new-and-updated-post-study-work-visa-options/');

-- Training: Advanced Learner Privacy and Information Handling
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'Privacy principles', 'https://www.privacy.org.nz/privacy-principles/', 'Office of the Privacy Commissioner', 1
FROM trainingModules tm
WHERE tm.title = 'Advanced Learner Privacy and Information Handling'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.privacy.org.nz/privacy-principles/');
INSERT INTO trainingResources (moduleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT tm.moduleId, 'Official Link', 'What are the privacy principles?', 'https://www.privacy.org.nz/resources-and-learning/knowledge-base/view/376/', 'Office of the Privacy Commissioner', 2
FROM trainingModules tm
WHERE tm.title = 'Advanced Learner Privacy and Information Handling'
  AND NOT EXISTS (SELECT 1 FROM trainingResources tr WHERE tr.moduleId = tm.moduleId AND tr.resourceUrl = 'https://www.privacy.org.nz/resources-and-learning/knowledge-base/view/376/');

-- Knowledge resources
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'YouTube', 'Applying for a Student Visa to Study in New Zealand', 'https://www.youtube.com/watch?v=xcMWJ-yJ9KU', 'Study with New Zealand', 1
FROM knowledgeArticles ka
WHERE ka.title = 'New Zealand Student Visa Funds and Tuition Fee Evidence'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.youtube.com/watch?v=xcMWJ-yJ9KU');
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Student fund requirements', 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/student-fund-requirements/', 'Immigration New Zealand', 2
FROM knowledgeArticles ka
WHERE ka.title = 'New Zealand Student Visa Funds and Tuition Fee Evidence'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/student-fund-requirements/');
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Fee Paying Student Visa', 'https://www.immigration.govt.nz/visas/fee-paying-student-visa/', 'Immigration New Zealand', 3
FROM knowledgeArticles ka
WHERE ka.title = 'New Zealand Student Visa Funds and Tuition Fee Evidence'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.immigration.govt.nz/visas/fee-paying-student-visa/');

INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Agent guidelines', 'https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-guidelines.html', 'University of Auckland', 1
FROM knowledgeArticles ka
WHERE ka.title = 'Changing Education Agents at the University of Auckland'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-guidelines.html');

INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Agent Application Centre', 'https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-application-centre.html', 'University of Auckland', 1
FROM knowledgeArticles ka
WHERE ka.title = 'University of Auckland Doctoral Applications and Agent Access'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.auckland.ac.nz/en/study/international-students/agent-resources/agent-forms-and-guides/agent-application-centre.html');

INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'New Zealand Traveller Declaration', 'https://www.travellerdeclaration.govt.nz/', 'New Zealand Traveller Declaration', 1
FROM knowledgeArticles ka
WHERE ka.title = 'Outward Travel Evidence and the New Zealand Traveller Declaration'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.travellerdeclaration.govt.nz/');
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'About the New Zealand Traveller Declaration', 'https://www.travellerdeclaration.govt.nz/about/', 'New Zealand Traveller Declaration', 2
FROM knowledgeArticles ka
WHERE ka.title = 'Outward Travel Evidence and the New Zealand Traveller Declaration'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.travellerdeclaration.govt.nz/about/');

INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'YouTube', 'Applying for a Student Visa to Study in New Zealand', 'https://www.youtube.com/watch?v=xcMWJ-yJ9KU', 'Study with New Zealand', 1
FROM knowledgeArticles ka
WHERE ka.title = 'Health Evidence for a New Zealand Fee-Paying Student Visa'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.youtube.com/watch?v=xcMWJ-yJ9KU');
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Health requirements', 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/health-requirements/', 'Immigration New Zealand', 2
FROM knowledgeArticles ka
WHERE ka.title = 'Health Evidence for a New Zealand Fee-Paying Student Visa'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/health-requirements/');
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Who needs an X-ray or medical examination', 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/health-requirements/who-needs-an-x-ray-or-medical-examination/', 'Immigration New Zealand', 3
FROM knowledgeArticles ka
WHERE ka.title = 'Health Evidence for a New Zealand Fee-Paying Student Visa'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/health-requirements/who-needs-an-x-ray-or-medical-examination/');

INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Police certificates', 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/character-requirements-third-party-checks-and-police-certificates/police-certificates/', 'Immigration New Zealand', 1
FROM knowledgeArticles ka
WHERE ka.title = 'Police Certificates and Supporting Documents for New Zealand Student Visas'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/character-requirements-third-party-checks-and-police-certificates/police-certificates/');
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Providing English translations of supporting documents', 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/providing-english-translations-of-supporting-documents/', 'Immigration New Zealand', 2
FROM knowledgeArticles ka
WHERE ka.title = 'Police Certificates and Supporting Documents for New Zealand Student Visas'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.immigration.govt.nz/process-to-apply/applying-for-a-visa/providing-evidence-and-documents-to-support-your-visa-application/providing-english-translations-of-supporting-documents/');

INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'University of Waikato College entry requirements', 'https://college.waikato.ac.nz/admissions/entry-requirements/', 'University of Waikato College', 1
FROM knowledgeArticles ka
WHERE ka.title = 'Pre-Master''s Pathways for Students Without a Bachelor''s Degree'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://college.waikato.ac.nz/admissions/entry-requirements/');

INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'YouTube', 'Can I bring my family when I study in New Zealand?', 'https://www.youtube.com/watch?v=ngpz9YFaxgU', 'Study with New Zealand', 1
FROM knowledgeArticles ka
WHERE ka.title = 'Partner Work Rights While a Student Is Studying in New Zealand'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.youtube.com/watch?v=ngpz9YFaxgU');
INSERT INTO knowledgeResources (articleId, resourceType, title, resourceUrl, sourceLabel, sortOrder)
SELECT ka.articleId, 'Official Link', 'Partner of a Student Work Visa', 'https://www.immigration.govt.nz/visas/partner-of-a-student-work-visa/', 'Immigration New Zealand', 2
FROM knowledgeArticles ka
WHERE ka.title = 'Partner Work Rights While a Student Is Studying in New Zealand'
  AND NOT EXISTS (SELECT 1 FROM knowledgeResources kr WHERE kr.articleId = ka.articleId AND kr.resourceUrl = 'https://www.immigration.govt.nz/visas/partner-of-a-student-work-visa/');

COMMIT;
