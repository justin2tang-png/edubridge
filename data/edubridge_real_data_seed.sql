-- EduBridge researched seed
-- 50 programme records + 10 training modules + 50 sections + 40 quiz questions
-- EduBridge programme and training seed data.
START TRANSACTION;

-- PROGRAMMES
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Architecture and Future Environments', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Architecture'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Architecture and Future Environments' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Arts and Humanities'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Business', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Business'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Business' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Communication Studies', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Communication and Media'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Communication Studies' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Computer and Information Sciences', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Computing and IT'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Computer and Information Sciences' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Construction', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Construction and Built Environment'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Construction' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Design Te Tohu Paetahi mō te Hoahoa', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Design'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Design Te Tohu Paetahi mō te Hoahoa' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Engineering (Honours)', 'Auckland University of Technology (AUT)', '8', 'Auckland', '4 years full-time', 'Engineering'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Engineering (Honours)' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Engineering Technology', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Engineering'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Engineering Technology' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Health Science', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Health Sciences'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Health Science' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Health Science (Midwifery)', 'Auckland University of Technology (AUT)', '7', 'Auckland', '4 years full-time', 'Midwifery'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Health Science (Midwifery)' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Health Science (Nursing)', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Nursing'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Health Science (Nursing)' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Health Science (Occupational Therapy)', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Occupational Therapy'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Health Science (Occupational Therapy)' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Health Science (Oral Health)', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Oral Health'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Health Science (Oral Health)' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Health Science (Physiotherapy)', 'Auckland University of Technology (AUT)', '7', 'Auckland', '4 years full-time', 'Physiotherapy'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Health Science (Physiotherapy)' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Health Science (Podiatry)', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Podiatry'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Health Science (Podiatry)' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of International Hospitality Management', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Hospitality'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of International Hospitality Management' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Laws', 'Auckland University of Technology (AUT)', '7', 'Auckland', '4 years full-time', 'Law'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Laws' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Medical Laboratory Science', 'Auckland University of Technology (AUT)', '7', 'Auckland', '4 years full-time', 'Medical Laboratory Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Medical Laboratory Science' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Science', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Science' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Sport, Exercise and Health', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Sport and Exercise'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Sport, Exercise and Health' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Visual Arts Te Tohu Paetahi mō Toi Ataata', 'Auckland University of Technology (AUT)', '7', 'Auckland', '3 years full-time', 'Visual Arts'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Visual Arts Te Tohu Paetahi mō Toi Ataata' AND provider='Auckland University of Technology (AUT)'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Science', 'University of Auckland', '7', 'Auckland – City / Grafton', '3 years full-time', 'Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Science' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts', 'University of Auckland', '7', 'Auckland – City', '3 years full-time', 'Arts and Humanities'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts/Bachelor of Science', 'University of Auckland', '7', 'Auckland – City / Grafton', '4 years full-time', 'Arts and Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts/Bachelor of Science' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Science (Honours)', 'University of Auckland', '8', 'Auckland – City / Grafton / Newmarket', '1 year full-time', 'Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Science (Honours)' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts/Bachelor of Commerce', 'University of Auckland', '7', 'Auckland – City', '4 years full-time', 'Arts and Business'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts/Bachelor of Commerce' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts (Honours)', 'University of Auckland', '8', 'Auckland – City', '1 year full-time', 'Arts and Humanities'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts (Honours)' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Communication', 'University of Auckland', '7', 'Auckland – City', '3 years full-time', 'Communication and Media'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Communication' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts/Bachelor of Fine Arts', 'University of Auckland', '7', 'Auckland – City', '4 years full-time', 'Arts and Fine Arts'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts/Bachelor of Fine Arts' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Fine Arts/Bachelor of Science', 'University of Auckland', '7', 'Auckland – City', '4 years full-time', 'Fine Arts and Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Fine Arts/Bachelor of Science' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Commerce', 'University of Auckland', '7', 'Auckland – City', '3 years full-time', 'Business and Commerce'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Commerce' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts/Bachelor of Global Studies', 'University of Auckland', '7', 'Auckland – City', '4 years full-time', 'Arts and Global Studies'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts/Bachelor of Global Studies' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Arts/Bachelor of Health Sciences', 'University of Auckland', '7', 'Auckland – City / Grafton', '4 years full-time', 'Arts and Health Sciences'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Arts/Bachelor of Health Sciences' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Arts', 'University of Auckland', '9', 'Auckland – City', '1–1.5 years full-time depending on entry route', 'Arts and Humanities'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Arts' AND provider='University of Auckland'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Science - Individual Major', 'Lincoln University', '7', 'Lincoln, Canterbury', '3 years full-time', 'Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Science - Individual Major' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Science with Honours', 'Lincoln University', '8', 'Lincoln, Canterbury', '1 year full-time', 'Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Science with Honours' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Applied Science', 'Lincoln University', '9', 'Lincoln, Canterbury', '2 years full-time', 'Applied Science'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Applied Science' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Tourism Management', 'Lincoln University', '9', 'Lincoln, Canterbury / Online', '1.5 years full-time', 'Tourism Management'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Tourism Management' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Applied Computing', 'Lincoln University', '9', 'Lincoln, Canterbury', '1.5 years full-time', 'Computing and IT'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Applied Computing' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Commerce and Management', 'Lincoln University', '9', 'Lincoln, Canterbury', '2 years full-time', 'Commerce and Management'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Commerce and Management' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Business in Global Management and Marketing', 'Lincoln University', '9', 'Lincoln, Canterbury / Online', '1.5 years full-time', 'Business and Marketing'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Business in Global Management and Marketing' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Environmental Policy and Management', 'Lincoln University', '9', 'Lincoln, Canterbury / Online', '1.5 years full-time', 'Environmental Management'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Environmental Policy and Management' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Commerce - Accounting and Finance Major', 'Lincoln University', '7', 'Lincoln, Canterbury', '3 years full-time', 'Accounting and Finance'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Commerce - Accounting and Finance Major' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Landscape Architecture', 'Lincoln University', '7', 'Lincoln, Canterbury', '4 years full-time', 'Landscape Architecture'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Landscape Architecture' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Landscape Architecture', 'Lincoln University', '9', 'Lincoln, Canterbury', '2 years full-time (240-credit route)', 'Landscape Architecture'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Landscape Architecture' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Master of Planning', 'Lincoln University', '9', 'Lincoln, Canterbury / Online', '2 years full-time', 'Planning'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Master of Planning' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Land and Property Management', 'Lincoln University', '7', 'Lincoln, Canterbury', '4 years full-time', 'Land and Property Management'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Land and Property Management' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Commerce - Marketing Major', 'Lincoln University', '7', 'Lincoln, Canterbury', '3 years full-time', 'Marketing'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Commerce - Marketing Major' AND provider='Lincoln University'
);
INSERT INTO programmes (programmeName, provider, level, location, duration, studyArea)
SELECT 'Bachelor of Commerce - Individual Major', 'Lincoln University', '7', 'Lincoln, Canterbury', '3 years full-time', 'Commerce'
WHERE NOT EXISTS (
  SELECT 1 FROM programmes WHERE programmeName='Bachelor of Commerce - Individual Major' AND provider='Lincoln University'
);

-- TRAINING
-- Source: https://www2.nzqa.govt.nz/qualifications-and-standards/about-new-zealand-qualifications-credentials-framework/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'NZQCF Qualification Levels for Education Advisers', 'Use the New Zealand Qualifications and Credentials Framework to explain qualification levels, compare study options, and avoid confusing qualification type with programme subject.', 'Programme Knowledge', 'Intermediate', 25
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='NZQCF Qualification Levels for Education Advisers');
SELECT moduleId INTO @m1 FROM trainingModules WHERE title='NZQCF Qualification Levels for Education Advisers' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m1, 'How the NZQCF is organised', 'The New Zealand Qualifications and Credentials Framework has ten levels. The level indicates the complexity and expected learning outcomes of a qualification, not its subject area or prestige. Advisers should use the framework to describe how qualifications relate to one another and to explain progression clearly. When comparing options, check both the qualification type and its NZQCF level rather than relying only on programme names.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m1 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m1, 'Levels 7 to 10', 'At the upper end of the framework, Level 7 includes bachelor’s degrees, graduate certificates and graduate diplomas; Level 8 includes bachelor honours degrees, postgraduate certificates and postgraduate diplomas; Level 9 is the master’s degree level; and Level 10 is doctoral study. These distinctions matter when explaining progression and when checking external rules that refer to qualification level.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m1 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m1, 'Qualification type is not the same as subject', 'Two programmes can sit at the same NZQCF level while serving very different academic purposes. A Level 7 bachelor’s degree and a Level 7 graduate diploma are both Level 7 qualifications, but they differ in structure, entry route and intended learner profile. Advisers should explain the exact qualification type before discussing possible progression or external outcomes.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m1 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m1, 'Using levels in programme comparison', 'When comparing programmes, record the qualification name, provider, NZQCF level, duration and study area separately. This prevents advisers from making assumptions based on a title alone. Level is useful for broad comparison, but provider-specific entry requirements, professional accreditation, programme content and progression rules still need to be checked from the current provider source.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m1 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m1, 'Keeping framework information current', 'Framework terminology and programme approvals can change. Use NZQA or the relevant university/provider source when confirming a qualification. If a programme record in EduBridge conflicts with the provider’s current page, the provider and official qualification source take priority and the internal record should be flagged for review rather than treated as definitive.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m1 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m1, 'What does an NZQCF level primarily indicate?', 'The subject area of a programme', 'The complexity and expected learning outcomes of a qualification', 'The provider''s ranking', 'The programme''s tuition fee', 'B', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m1 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m1, 'Which qualification type is normally at NZQCF Level 9?', 'Graduate Diploma', 'Bachelor Honours Degree', 'Master''s Degree', 'Doctoral Degree', 'C', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m1 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m1, 'Why should an adviser record qualification type separately from level?', 'Because different qualification types can sit at the same level', 'Because level is only used by universities', 'Because qualification type replaces provider research', 'Because every subject has its own level', 'A', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m1 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m1, 'What should happen if an internal programme record conflicts with the provider''s current page?', 'Use the old internal record', 'Average the two versions', 'Ignore the provider page', 'Flag the internal record and use the authoritative current source', 'D', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m1 AND sortOrder=4
);

-- Source: https://www2.nzqa.govt.nz/tertiary/the-code/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Checking Provider Quality and Code Signatory Status', 'Check provider legitimacy, quality assurance and Code signatory status before recommending New Zealand study options.', 'Compliance', 'Intermediate', 25
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Checking Provider Quality and Code Signatory Status');
SELECT moduleId INTO @m2 FROM trainingModules WHERE title='Checking Provider Quality and Code Signatory Status' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m2, 'Why provider checks matter', 'A programme should not be recommended only because its marketing looks attractive. Advisers should confirm that the education organisation is legitimate and that the programme is offered through the appropriate quality-assurance system. For international learners, providers enrolling international students must also meet the requirements associated with the Tertiary and International Learners Code of Practice.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m2 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m2, 'Code signatory status', 'The Code of Practice supports learner wellbeing and safety. Providers that enrol international learners must be approved signatories to the Code. Advisers should understand that Code signatory status is different from a programme’s academic subject or ranking. It is a compliance and learner-protection check that should be considered when evaluating a provider for international study.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m2 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m2, 'Quality assurance in New Zealand', 'NZQA quality-assures many tertiary education organisations, while universities operate within the university quality-assurance system. The important adviser behaviour is to check the appropriate official source rather than assume that every provider is monitored in the same way. Where a provider’s status is unclear, do not present it as verified until the official source confirms it.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m2 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m2, 'Provider status versus programme fit', 'A provider can be legitimate and still not be the right fit for a particular student. After provider checks are complete, advisers should separately compare programme content, entry requirements, location, duration, learner support and likely progression. Compliance checks establish that an option is credible; they do not replace individual programme research.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m2 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m2, 'Documenting provider verification', 'When an adviser confirms a provider or programme, record the source and the date checked where practical. If information is time-sensitive, note that it should be rechecked before an application is submitted. This creates a clearer audit trail and reduces the risk that old screenshots or outdated brochures are treated as current provider policy.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m2 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m2, 'What additional status is important for a provider enrolling international learners?', 'Membership of a student club', 'Signatory status under the learner Code', 'A high social-media following', 'A commission agreement', 'B', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m2 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m2, 'What does provider quality verification establish?', 'That the programme is automatically suitable for every student', 'That the provider is the cheapest option', 'That the option is credible before individual fit is assessed', 'That immigration approval is guaranteed', 'C', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m2 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m2, 'Why should advisers record a source and date when practical?', 'To create a clearer audit trail for time-sensitive information', 'To avoid checking provider information again', 'To replace official provider systems', 'To increase application speed automatically', 'A', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m2 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m2, 'If a provider''s status is unclear, what should an adviser do?', 'Present it as verified', 'Assume the marketing material is enough', 'Ask the student to decide', 'Wait for confirmation from the appropriate official source', 'D', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m2 AND sortOrder=4
);

-- Source: https://www2.nzqa.govt.nz/tertiary/the-code/the-code-for-education-providers/guide-to-managing-education-agents/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Education Agent Responsibilities under the Learner Code', 'Understand the education-agent role, accurate information duties, learner-centred conduct and provider monitoring expectations.', 'Compliance', 'Intermediate', 30
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Education Agent Responsibilities under the Learner Code');
SELECT moduleId INTO @m3 FROM trainingModules WHERE title='Education Agent Responsibilities under the Learner Code' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m3, 'The role of an education agent', 'Education agents commonly support international student recruitment, provider applications, study information, translation and pre-departure preparation. The role is broader than sales. Agents are often an early source of information for learners and families, so inaccurate or incomplete information can affect learner decisions and provider reputation.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m3 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m3, 'Accurate and sufficient information', 'Prospective learners should receive clear and sufficient information to make informed choices. Advisers should distinguish verified facts from assumptions, avoid guaranteeing outcomes, and update students when provider information changes. Programme entry requirements, fees, refund conditions and support services should be checked from current provider information rather than reused indefinitely from old cases.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m3 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m3, 'Learner interests and conflicts', 'Commission arrangements are part of the education-agent business model, but recommendations should still be suitable for the learner. Advisers should recognise potential conflicts of interest and avoid presenting a programme as objectively superior simply because it has a better commercial arrangement. The learner’s goals, eligibility and study fit remain central to the recommendation process.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m3 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m3, 'Complaints and poor conduct', 'Providers are expected to manage and monitor education-agent conduct. Complaints, misleading information, poor communication or repeated process failures can become agent-management issues. Advisers should keep clear records of important communication and escalate material complaints rather than hiding them or altering records after the event.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m3 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m3, 'Working with provider processes', 'Different providers have different agent portals, application rules and communication channels. Advisers should follow the provider’s current process, respond to requests promptly and avoid bypassing controls designed to protect the learner or provider. Internal systems such as EduBridge should support, not replace, authoritative provider workflows.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m3 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m3, 'Which is a common education-agent service identified by NZQA?', 'Issuing New Zealand visas', 'Changing government policy', 'Assisting with provider applications', 'Guaranteeing admission', 'C', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m3 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m3, 'What should guide a programme recommendation where commission is involved?', 'The highest commission', 'The learner''s goals, eligibility and study fit', 'The fastest application portal', 'The provider with the most advertising', 'B', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m3 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m3, 'How should material learner complaints be handled?', 'Escalated and recorded appropriately', 'Deleted after resolution', 'Kept only in private messages', 'Ignored if the application succeeds', 'A', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m3 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m3, 'What should internal systems such as EduBridge do in relation to provider workflows?', 'Replace them entirely', 'Bypass their controls', 'Support them without pretending to be the authoritative provider system', 'Automatically approve exceptions', 'C', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m3 AND sortOrder=4
);

-- Source: https://www.iaa.govt.nz/can-i-give-advice/information-for-education-agents/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Immigration Advice Boundaries for Education Agents', 'Know when education information becomes regulated New Zealand immigration advice and when a learner must be referred to a licensed or exempt adviser.', 'Compliance', 'Advanced', 30
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Immigration Advice Boundaries for Education Agents');
SELECT moduleId INTO @m4 FROM trainingModules WHERE title='Immigration Advice Boundaries for Education Agents' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m4, 'Information versus immigration advice', 'Education advisers can explain publicly available study information, but personalised recommendations about which New Zealand visa a person should choose or how they should answer immigration questions can become immigration advice. The safest approach is to separate education guidance from personalised immigration strategy and to refer immigration advice when licensing rules require it.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m4 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m4, 'Who generally needs a licence', 'New Zealand immigration advice is generally restricted to licensed immigration advisers or people who are legally exempt. The licensing requirement can apply even when advice is given outside New Zealand. Advisers should not assume that working for an education business automatically gives them authority to advise on New Zealand immigration matters.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m4 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m4, 'Education-agent exemption limits', 'An education agent outside New Zealand may have a limited exemption for advice about student visas. That does not create a general exemption for work, visitor, residence or other immigration matters. An education agent in New Zealand is not covered by that offshore student-visa exemption. Location and the type of advice both matter.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m4 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m4, 'When to refer a student', 'If a learner asks which immigration pathway they should choose, how a complex personal circumstance affects eligibility, or how to structure a response to improve a visa outcome, the issue may require regulated advice. Advisers should recognise the boundary early and refer the student to a licensed adviser or another legally exempt professional.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m4 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m4, 'Safe internal practice', 'EduBridge training and Knowledge content should provide factual public information, not personalised immigration decisions. Staff should avoid language such as ''you will qualify'' or ''this visa is best for you'' unless the speaker is authorised to give that advice. Records should make clear when information was provided and when a referral was recommended.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m4 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m4, 'Which activity is most likely to be immigration advice?', 'Reading a university programme title', 'Explaining a provider''s application deadline', 'Recommending which visa pathway a person should choose', 'Giving a campus address', 'C', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m4 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m4, 'Who generally may provide New Zealand immigration advice?', 'Any education agent', 'Licensed advisers or people who are legally exempt', 'Any person outside New Zealand', 'Any university graduate', 'B', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m4 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m4, 'What is a key limit on the offshore education-agent exemption?', 'It applies only to advice about student visas', 'It applies to residence visas only', 'It applies only in New Zealand', 'It removes all licensing rules', 'A', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m4 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m4, 'What should an unlicensed adviser do with a complex personalised immigration question?', 'Give a best guess', 'Reuse advice from another case', 'Refer the student to an authorised professional', 'Rewrite the question as programme advice', 'C', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m4 AND sortOrder=4
);

-- Source: https://www.immigration.govt.nz/visas/fee-paying-student-visa/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Fee-Paying Student Visa Evidence Essentials', 'Review the main evidence areas in a New Zealand fee-paying student visa application without turning factual guidance into personalised immigration advice.', 'Application Process', 'Intermediate', 30
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Fee-Paying Student Visa Evidence Essentials');
SELECT moduleId INTO @m5 FROM trainingModules WHERE title='Fee-Paying Student Visa Evidence Essentials' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m5, 'Offer of place and study evidence', 'A fee-paying student visa application is built around an approved course of study and evidence from the education provider. Advisers supporting an education application should make sure the student’s programme details, provider information and study dates are consistent across provider documents and any information supplied for the visa process.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m5 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m5, 'Tuition and living-cost evidence', 'Applicants must show that they can meet tuition and living-cost requirements that apply to their circumstances. Evidence requirements can change, so staff should use current Immigration New Zealand sources rather than fixed internal formulas. Where a case needs personalised advice about funding strategy or sponsorship, refer it appropriately.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m5 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m5, 'Genuine intentions', 'Immigration New Zealand considers whether the applicant genuinely intends to study and comply with visa conditions. False, misleading or inconsistent evidence can create serious problems. Advisers should never invent explanations, alter documents or encourage a learner to hide relevant information. Internal records should match the documents actually supplied.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m5 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m5, 'Health, character and translations', 'Depending on the application, health evidence, police certificates and translations may be required. Medical and police documents that are not in English have specific translation requirements. Advisers should check the current visa instructions and avoid treating requirements from one previous case as automatically applicable to every new applicant.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m5 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m5, 'Evidence quality and final checks', 'Before a student submits a visa application, supporting files should be readable, logically named and consistent with the application. Important dates, names and programme details should match. A checklist can improve completeness, but it does not replace current Immigration New Zealand instructions or regulated advice where the student has complex circumstances.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m5 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m5, 'What should an adviser do when visa evidence requirements may have changed?', 'Use the last successful case', 'Use current Immigration New Zealand information', 'Use a social-media post', 'Assume the provider decides all visa evidence', 'B', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m5 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m5, 'Why is genuine-intentions evidence important?', 'It can be invented if the student has a strong academic record', 'INZ considers whether the student genuinely intends to study and comply with conditions', 'It replaces an offer of place', 'It is only relevant to visitor visas', 'B', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m5 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m5, 'What is a safe approach to health and police document requirements?', 'Apply every requirement from a previous case to all students', 'Check the current visa instructions for the applicant''s circumstances', 'Never submit translations', 'Let the agent create replacement documents', 'B', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m5 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m5, 'What should a final evidence check focus on?', 'Readable, consistent documents and matching key details', 'Making every file as large as possible', 'Removing dates from documents', 'Changing provider information to match the application', 'A', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m5 AND sortOrder=4
);

-- Source: https://www.immigration.govt.nz/study/once-you-have-a-student-visa/working-on-a-student-visa/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Student Work Rights and Study Conditions', 'Explain how to check student work conditions, scheduled-break work rights and common limits without assuming every student has the same visa conditions.', 'Student Support', 'Intermediate', 25
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Student Work Rights and Study Conditions');
SELECT moduleId INTO @m6 FROM trainingModules WHERE title='Student Work Rights and Study Conditions' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m6, 'Always check the actual visa conditions', 'Work rights are conditions attached to an individual student visa. Even when general rules allow work for certain students, the adviser should tell the learner to check the eVisa or visa letter that applies to them. Never assume that two students on similar programmes have identical conditions without checking the granted visa.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m6 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m6, 'Part-time work during study', 'Eligible tertiary students may have conditions allowing part-time work for up to 25 hours a week while studying. Eligibility depends on the course and visa conditions. Advisers should present the general rule as information, not as a guarantee, and should direct students to the current Immigration New Zealand criteria if their situation is unclear.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m6 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m6, 'Scheduled holidays and full-time work', 'Some student visas allow full-time work during scheduled holidays. This depends on the student’s course and visa conditions, and the provider’s academic calendar can be relevant. Students should not assume that any break between classes automatically qualifies as a scheduled holiday for full-time work.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m6 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m6, 'Practical work that is part of study', 'Where practical work experience is a compulsory part of the programme, visa conditions may deal with that practical component separately from ordinary part-time work. Evidence from the provider or course outline may be relevant. Advisers should avoid describing optional employment as compulsory practical training unless the programme actually requires it.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m6 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m6, 'Changes of provider or study', 'Changing provider, course or level of study can affect visa conditions and may require a new visa rather than a simple variation. Students should check the current immigration rules before making a study change. Education advisers can explain provider processes, while complex immigration consequences should be referred when regulated advice is required.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m6 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m6, 'Where should a student confirm their actual work rights?', 'On another student''s visa', 'On their own eVisa or visa letter', 'In the programme brochure only', 'From an employer''s preference', 'B', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m6 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m6, 'What is the current general part-time limit for eligible students?', '10 hours', '20 hours', '25 hours', '40 hours', 'C', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m6 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m6, 'Does any gap between classes automatically count as a scheduled holiday for full-time work?', 'Yes', 'No', 'Only if the student prefers', 'Only for postgraduate students', 'B', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m6 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m6, 'What should happen before a student changes provider or study level?', 'Assume the visa is unaffected', 'Check the possible visa consequences under current rules', 'Wait until after the change', 'Ask the new employer', 'B', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m6 AND sortOrder=4
);

-- Source: https://www.immigration.govt.nz/visas/pathway-student-visa/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Pathway Student Visas and Study Progression', 'Understand the Pathway Student Visa concept, provider eligibility, multi-programme study plans and progression checks.', 'Student Visa Guidance', 'Intermediate', 25
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Pathway Student Visas and Study Progression');
SELECT moduleId INTO @m7 FROM trainingModules WHERE title='Pathway Student Visas and Study Progression' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m7, 'What a Pathway Student Visa does', 'A Pathway Student Visa can cover a planned sequence of up to three programmes on one visa and may be granted for up to five years. It is designed for structured progression rather than unrelated study changes. Advisers should confirm that the proposed study pathway and providers meet the current Pathway Student Visa rules.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m7 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m7, 'Provider eligibility matters', 'The Pathway Student Visa is available only through eligible pathway education providers and approved study arrangements. A programme being academically suitable does not automatically make it eligible for the pathway visa. Provider and course eligibility should be checked from current Immigration New Zealand information.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m7 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m7, 'Progression between programmes', 'Students still need to meet the prerequisites for later programmes in the pathway. A visa covering multiple planned stages does not guarantee academic progression. Advisers should explain entry conditions clearly and record any requirements that must be met before the student can move to the next programme.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m7 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m7, 'Work rights depend on the course', 'A Pathway Student Visa may include work rights depending on the student’s course and circumstances. Work conditions should be checked on the visa itself. Advisers should not describe the pathway visa as automatically giving the same work rights throughout every stage of study.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m7 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m7, 'When the pathway changes', 'If a student’s academic plan changes, the visa implications should be checked before the student changes provider or programme. The pathway visa offers flexibility within approved arrangements, but it is not unlimited permission to substitute any programme. Complex changes should be escalated to the appropriate immigration professional.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m7 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m7, 'What is the maximum number of programmes that a Pathway Student Visa can cover?', '1', '2', '3', 'Unlimited', 'C', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m7 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m7, 'Can any education provider automatically support a Pathway Student Visa?', 'Yes', 'No, provider and pathway eligibility must be checked', 'Only universities can', 'Only private providers can', 'B', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m7 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m7, 'Does a pathway visa guarantee academic progression to later programmes?', 'Yes', 'No, the student must still meet progression requirements', 'Only for master''s programmes', 'Only if tuition is prepaid', 'B', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m7 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m7, 'What should an adviser do if the planned pathway changes materially?', 'Assume the original visa covers any substitute course', 'Check the immigration implications before the change', 'Ignore the change until renewal', 'Change the database only', 'B', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m7 AND sortOrder=4
);

-- Source: https://www.immigration.govt.nz/visas/partner-of-a-student-work-visa/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Partner and Family Visa Awareness for Student Advisers', 'Recognise the qualification-level rules that may affect partners and dependent children, while keeping personalised immigration decisions outside an unlicensed adviser role.', 'Student Support', 'Intermediate', 30
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Partner and Family Visa Awareness for Student Advisers');
SELECT moduleId INTO @m8 FROM trainingModules WHERE title='Partner and Family Visa Awareness for Student Advisers' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m8, 'Why the student’s qualification matters', 'A student’s qualification can affect whether their partner may be eligible for a Partner of a Student Work Visa. Level 9 and 10 study can support this route, while some Level 7 and 8 qualifications may also qualify under specified rules. Advisers should verify the exact qualification rather than relying on a broad label such as ''postgraduate''.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m8 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m8, 'Partner work visa basics', 'Where the supporting student meets the relevant study requirements, the partner may be able to apply for a work visa. The partner must also meet requirements that apply to their own application, including partnership and other visa criteria. Education advisers should describe the public rule but avoid deciding eligibility for a complex relationship case.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m8 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m8, 'Dependent children', 'Family options can depend on the visa held by the student or their partner. In some situations, a partner who obtains a work visa may then be able to support student visas for dependent children. Because family pathways are case-specific, advisers should use current Immigration New Zealand information and refer complex questions appropriately.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m8 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m8, 'Relationship evidence is separate', 'Qualification eligibility is only one part of a partner application. The applicant must still satisfy the relationship requirements that apply to partnership-based visas. Advisers should not tell a couple that the partner visa is guaranteed simply because the student is studying a qualifying programme.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m8 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m8, 'How to discuss family outcomes safely', 'When comparing programmes, it is reasonable to note that qualification level can affect possible family visa options. The adviser should state that immigration eligibility must be checked separately and may depend on current policy and personal circumstances. This keeps programme guidance useful without turning it into unlicensed immigration advice.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m8 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m8, 'Which study level generally supports a partner work visa under the broad rule?', 'Level 3', 'Level 5', 'Level 9 or 10', 'Any short course', 'C', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m8 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m8, 'Can some Level 7 or 8 qualifications also support partner work eligibility?', 'No, never', 'Yes, where they meet specified rules', 'Only if the provider is private', 'Only if the student is under 25', 'B', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m8 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m8, 'Is qualification level the only requirement for a partner work visa?', 'Yes', 'No, the partner must also meet their own visa and relationship requirements', 'Only for married couples', 'Only for PhD students', 'B', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m8 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m8, 'How should an adviser describe family visa implications during programme comparison?', 'As guaranteed outcomes', 'As possible implications that need separate immigration checking', 'As irrelevant to programme choice', 'As provider-controlled benefits', 'B', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m8 AND sortOrder=4
);

-- Source: https://www.immigration.govt.nz/visas/post-study-work-visa/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Post-Study Work Pathways after New Zealand Study', 'Understand the broad relationship between completed New Zealand qualifications and post-study work options, including 2026 rule changes.', 'Programme Knowledge', 'Advanced', 30
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Post-Study Work Pathways after New Zealand Study');
SELECT moduleId INTO @m9 FROM trainingModules WHERE title='Post-Study Work Pathways after New Zealand Study' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m9, 'Purpose of the Post-Study Work Visa', 'The Post-Study Work Visa allows eligible graduates to remain and work in New Zealand after completing qualifying study. The possible visa duration and work conditions depend on the qualification and current immigration rules. Advisers should not advertise a programme as guaranteeing a specific work visa without checking the current eligibility criteria.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m9 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m9, 'Degree-level qualifications', 'Degree-level study at Level 7 or above can support post-study work eligibility when the applicable study requirements are met. For degree-level qualifications, work rights are generally broader than for eligible non-degree qualifications. The exact duration still depends on the qualification and study completed.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m9 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m9, 'Level 7 graduate diploma change in 2026', 'From 16 November 2026, eligibility is being extended to certain Level 7 graduate diploma graduates who also hold a bachelor’s degree and meet the specified New Zealand full-time study conditions. Advisers should use the effective date and full rule, not present every Level 7 graduate diploma as automatically eligible.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m9 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m9, 'Postgraduate diplomas and master’s degrees', 'Current Immigration New Zealand information notes that eligible Level 8 postgraduate diploma graduates may qualify for a one-year Post-Study Work Visa, while eligible Level 9 master’s graduates may qualify for up to three years. Programme length, completion and other visa criteria still need to be checked.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m9 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m9, 'Programme advice versus immigration outcomes', 'Post-study work information can be relevant when a student compares programmes, but it should not become a promise of employment or residence. Advisers should explain the current public rule, identify the qualification level correctly, and encourage students to check immigration rules again before making major financial decisions.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m9 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m9, 'What is the purpose of the Post-Study Work Visa?', 'To replace a student visa before study starts', 'To allow eligible graduates to work in New Zealand after qualifying study', 'To guarantee residence', 'To fund tuition fees', 'B', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m9 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m9, 'What change takes effect from 16 November 2026 for some Level 7 graduate diploma graduates?', 'All graduate diplomas become Level 9', 'Some may become eligible for a Post-Study Work Visa if specified conditions are met', 'They automatically receive residence', 'They no longer need a bachelor’s degree', 'B', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m9 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m9, 'What may an eligible Level 9 master''s graduate qualify for under current rules?', 'Up to a three-year Post-Study Work Visa', 'A guaranteed resident visa', 'A ten-year student visa', 'Unlimited study without a visa', 'A', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m9 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m9, 'How should post-study work information be presented in programme advice?', 'As a guaranteed employment outcome', 'As current public information that must be checked again before major decisions', 'As a provider scholarship', 'As proof of residence eligibility', 'B', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m9 AND sortOrder=4
);

-- Source: https://www.privacy.org.nz/privacy-principles/
INSERT INTO trainingModules (title, description, category, level, durationMinutes)
SELECT 'Advanced Learner Privacy and Information Handling', 'Apply New Zealand privacy principles to education-adviser records, including necessary collection, transparency, secure handling, use and access rights.', 'Compliance', 'Advanced', 30
WHERE NOT EXISTS (SELECT 1 FROM trainingModules WHERE title='Advanced Learner Privacy and Information Handling');
SELECT moduleId INTO @m10 FROM trainingModules WHERE title='Advanced Learner Privacy and Information Handling' ORDER BY moduleId LIMIT 1;
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m10, 'Collect only what is needed', 'Personal information should be collected for a lawful purpose connected with the organisation’s work, and the collection should be necessary for that purpose. Advisers should avoid gathering identity documents, family details or financial information simply because they might be useful later. If the information is not needed for the current process, do not collect it by default.', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m10 AND sortOrder=1
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m10, 'Tell people about collection', 'When information is collected directly from a learner, they should be informed about the collection, its purpose and other relevant matters. From 1 May 2026, Privacy Principle 3A also adds notification requirements for certain indirect collection. Internal workflows should make the source and purpose of important learner data clear.', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m10 AND sortOrder=2
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m10, 'Keep learner information secure', 'Access to learner information should be limited to people who need it for their role. Screenshots, exported spreadsheets and messaging apps can create uncontrolled copies of personal data. Use approved systems where possible, avoid sharing unnecessary identifiers, and treat downloaded documents as sensitive records rather than casual working files.', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m10 AND sortOrder=3
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m10, 'Use information for the right purpose', 'Information collected for an application or support process should not automatically be reused for unrelated marketing or other purposes. Before reusing or disclosing learner information, staff should check whether that use is consistent with the original purpose or otherwise permitted. Convenience is not a sufficient reason to broaden use.', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m10 AND sortOrder=4
);
INSERT INTO trainingModuleSections (moduleId, sectionTitle, sectionContent, sortOrder)
SELECT @m10, 'Access, correction and good records', 'Learners have privacy rights that include access to and correction of personal information in appropriate circumstances. Good internal records should be accurate, relevant and understandable. If a student points out an error, staff should follow the organisation’s correction process rather than silently creating conflicting versions across systems.', 5
WHERE NOT EXISTS (
  SELECT 1 FROM trainingModuleSections WHERE moduleId=@m10 AND sortOrder=5
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m10, 'What is the best privacy approach to collecting learner information?', 'Collect everything in case it is useful later', 'Collect only information necessary for a lawful purpose', 'Collect only financial information', 'Collect data only by email', 'B', 1
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m10 AND sortOrder=1
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m10, 'What new notification area applies from 1 May 2026 under IPP 3A?', 'Indirect collection of personal information in relevant circumstances', 'All information must be public', 'Students lose correction rights', 'Providers cannot use databases', 'A', 2
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m10 AND sortOrder=2
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m10, 'Why are uncontrolled screenshots and exports a privacy risk?', 'They can create unnecessary copies of sensitive learner information', 'They always improve security', 'They automatically encrypt data', 'They remove access risks', 'A', 3
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m10 AND sortOrder=3
);
INSERT INTO trainingQuizQuestions (moduleId, questionText, optionA, optionB, optionC, optionD, correctOption, sortOrder)
SELECT @m10, 'What should happen when a learner identifies an error in their information?', 'Ignore it once the application is submitted', 'Follow the organisation''s correction process', 'Delete the whole record', 'Create a second conflicting version', 'B', 4
WHERE NOT EXISTS (
  SELECT 1 FROM trainingQuizQuestions WHERE moduleId=@m10 AND sortOrder=4
);

COMMIT;
