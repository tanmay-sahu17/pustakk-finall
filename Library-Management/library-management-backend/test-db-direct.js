const mysql = require('mysql2/promise');

// Test direct database query
async function testDatabaseQuery() {
    const dbConfig = {
        host: '165.22.208.62',
        user: 'root',
        password: 'Ssipmt@2025DODB',
        database: 'library_management',
        port: 3306
    };

    try {
        console.log('Connecting to database...');
        const connection = await mysql.createConnection(dbConfig);
        console.log('Connected successfully!');

        // Test 1: Check users table structure
        console.log('\n=== TESTING USERS TABLE ===');
        const [tableInfo] = await connection.execute('DESCRIBE users');
        console.log('Users table structure:');
        tableInfo.forEach(col => {
            console.log(`- ${col.Field}: ${col.Type} (${col.Null === 'YES' ? 'NULL' : 'NOT NULL'})`);
        });

        // Test 2: Test the exact query from auth controller
        console.log('\n=== TESTING LOGIN QUERY ===');
        const username = 'simple';
        console.log(`Searching for username: ${username}`);
        
        const [users] = await connection.execute(
            'SELECT * FROM users WHERE username = ?',
            [username]
        );
        
        console.log(`Found ${users.length} users`);
        if (users.length > 0) {
            const user = users[0];
            console.log('User data:');
            console.log(`- ID: ${user.id}`);
            console.log(`- Username: ${user.username}`);
            console.log(`- Password: ${user.password}`);
            console.log(`- Role: ${user.role || 'N/A'}`);
        }

        await connection.end();
        console.log('\nDatabase connection closed successfully');
        
    } catch (error) {
        console.error('Database error:', error);
    }
}

testDatabaseQuery();
