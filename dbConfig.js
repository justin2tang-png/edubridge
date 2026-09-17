var mysql = require('mysql');

var conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'edubridge'
});

conn.connect(function (error) {
    if (error) {
        console.error('Database connection failed:', error.message);
        return;
    }

    console.log('DB is connected...');
});

module.exports = conn;