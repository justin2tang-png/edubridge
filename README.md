# EduBridge

EduBridge is a web application for managing education programmes, student applications, training content and learning resources.

## Technology

- Node.js and Express for server routes
- EJS for rendered pages
- MySQL for application data
- Express Session for login sessions
- Multer for document uploads
- HTML and CSS for the interface

## Main features

- Accounts for students, agents and administrators
- Programme search, details and favourites
- Student records and application management
- Document uploads, reviews and application conversations
- Recommendations, notifications and application status tracking
- Training modules, quizzes and progress tracking
- Knowledge articles, FAQs and resource files

## Project files

- `app.js` — Express application, routes and database operations
- `dbConfig.js` — local MySQL connection configuration
- `views/` — EJS page templates and shared partials
- `public/` — styles and provider images
- `data/` — database updates and programme, training and resource seed data

## Running locally

1. Install Node.js and MySQL.
2. Prepare a MySQL database named `edubridge` with the application's core tables.
3. Review and apply the relevant SQL updates in `data/` to match the current application schema.
4. Import `data/edubridge_real_data_seed.sql` for programme and training data, then `data/content_resources_seed.sql` for linked learning resources.
5. Set the MySQL connection details in `dbConfig.js` for your local environment.
6. Run `npm install` and `npm start`.
7. Open `http://localhost:3000`.

Set `SESSION_SECRET` in the environment when running outside a local development setup. The server port can be changed using `PORT`.

**Database note:** The repository includes feature-level SQL updates and sample content, but not a complete initial database schema. A matching base database is required before these updates and seed files can be imported.