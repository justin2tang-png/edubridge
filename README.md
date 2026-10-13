# EduBridge

EduBridge is a Level 5 software development project for managing education programmes, student applications, agent training and a knowledge base.

## Technology

- Node.js and Express — routes, form handling and application logic
- EJS, HTML and CSS — server-rendered pages
- MySQL / MariaDB — relational data storage
- express-session — login sessions and role-based access
- Multer — application and knowledge file uploads

## Main features

- Student registration, login and logout
- Programme listings, search and details
- Student application creation, details and permitted updates
- Agent training modules and knowledge checks
- Knowledge Base articles and search
- Administration of accounts, programmes, training and knowledge content

## Installation (local Windows / XAMPP)

1. Start **MySQL** in XAMPP.
2. In phpMyAdmin, create an empty database called `edubridge` with the `utf8mb4` character set.
3. In phpMyAdmin's **Import** tab, import these three files into `edubridge` **in this order**:
   - `data/schema.sql` — 22 empty tables, relationships and indexes
   - `data/edubridge_real_data_seed.sql` — sample programmes, training modules and quizzes
   - `data/content_resources_seed.sql` — links to learning resources
4. In the project folder, run `npm ci` and then `npm start`.
5. Open `http://localhost:3000`.

The application assumes local MySQL user `root` with a blank password, as in a default local XAMPP setup. When different credentials are used, configure `DB_HOST`, `DB_USER`, `DB_PASSWORD` and `DB_NAME` environment variables. Set `SESSION_SECRET` for any environment beyond a local classroom demo. The `PORT` environment variable changes the default port of 3000.

**Existing database:** If EduBridge is already running with a populated database, do not re-import `schema.sql`. The `data/phase-*.sql` files are historical changes for earlier database versions, not extra steps needed after importing the complete `schema.sql`.

## User roles

New registrations start with the **student** role. For an isolated classroom demo, register separate test users and change their roles to `agent` and `admin` using phpMyAdmin's SQL tab:

```sql
UPDATE users SET role = 'agent' WHERE name = 'DemoAgent';
UPDATE users SET role = 'admin' WHERE name = 'DemoAdmin';
```

Only use these statements for accounts you control in your local demonstration database. The admin screen can then manage roles and application content. No real student records are included in the SQL seed files.

## Basic presentation checklist

1. Register and sign in as a student; sign out and confirm a protected page requires login.
2. Search for a programme and open its details.
3. Create an application, view it, and show that another student cannot access it.
4. Sign in as an agent, open Training and a module or quiz.
5. Sign in as an admin, open the dashboard, create a Knowledge Base article, then find it in search.

These steps cover basic database interaction, CRUD, sessions, role permissions, server-side rendering and functional testing. This is a local course project, not a production deployment.
