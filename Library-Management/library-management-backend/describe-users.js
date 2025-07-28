const mysql = require('mysql2/promise');
const env = require('./src/config/env');

async function describeUsers() {
    try {
        console.log('Connecting to database...');
        
        const connection = await mysql.createConnection({
            host: env.DB_HOST,
            user: env.DB_USER,
            password: env.DB_PASSWORD,
            database: env.DB_NAME,
            port: env.DB_PORT || 3306
        });

        console.log('Running DESCRIBE users command...\n');
        
        const [rows] = await connection.execute('DESCRIBE users');
        
        console.log('Table structure for "users":');
        console.table(rows);
        
        console.log('\nColumn names:');
        rows.forEach((row, index) => {
            console.log(`${index + 1}. ${row.Field} (${row.Type})`);
        });
        
        await connection.end();
        console.log('\nConnection closed.');
        
    } catch (error) {
        console.error('Error describing users table:', error.message);
    }
}

describeUsers();
