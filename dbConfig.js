var mysql = require('mysql');

var conn = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'edubridge'
});

conn.connect(function (error) {
    if (error) {
        console.error('Database connection failed:', error.message);
        return;
    }

    console.log('DB is connected...');
});

module.exports = conn;