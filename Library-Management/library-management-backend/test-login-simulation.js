const mysql = require('mysql2/promise');
require('dotenv').config();

// Simple login API test - bypassing any middleware issues
async function testProductionLogin() {
    const dbConfig = {
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        port: process.env.DB_PORT
    };

    console.log('Testing production login logic...');
    
    try {
        const connection = await mysql.createConnection(dbConfig);
        console.log('Database connected');

        // Test known user from database
        const username = 'simple';
        const password = 'test123';

        const [users] = await connection.execute(
            'SELECT * FROM users WHERE username = ?',
            [username]
        );

        if (users.length === 0) {
            console.log('❌ User not found');
            return;
        }

        const user = users[0];
        console.log(`✅ User found: ${user.username}`);
        
        // Test password match
        if (password === user.password) {
            console.log('✅ Password match successful');
            
            // Generate token (simulate production behavior)
            const jwt = require('jsonwebtoken');
            const token = jwt.sign(
                { 
                    id: user.id, 
                    username: user.username,
                    role: user.role 
                }, 
                process.env.JWT_SECRET, 
                { expiresIn: '24h' }
            );

            console.log('✅ Token generated successfully');
            console.log('Login Response:');
            console.log(JSON.stringify({
                success: true,
                message: 'Login successful',
                token: token,
                user: {
                    id: user.id,
                    username: user.username,
                    role: user.role
                }
            }, null, 2));

        } else {
            console.log('❌ Password mismatch');
            console.log(`Expected: ${password}`);
            console.log(`Got: ${user.password}`);
        }

        await connection.end();
        
    } catch (error) {
        console.error('❌ Error:', error);
    }
}

testProductionLogin();
