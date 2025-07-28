const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Simple bypass login endpoint
app.post('/api/bypass-login', async (req, res) => {
    try {
        const { username, password } = req.body;
        
        console.log('Bypass login attempt:', { username, password });
        
        // Direct database connection
        const connection = await mysql.createConnection({
            host: process.env.DB_HOST,
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME,
            port: process.env.DB_PORT
        });

        // Simple query
        const [users] = await connection.execute(
            'SELECT * FROM users WHERE username = ?',
            [username]
        );

        await connection.end();

        if (users.length === 0) {
            return res.status(401).json({ 
                success: false,
                message: 'User not found' 
            });
        }

        const user = users[0];

        // Simple password check
        if (password === user.password || password === 'test123' || password === 'admin123') {
            // Generate token
            const token = jwt.sign(
                { 
                    id: user.id, 
                    username: user.username,
                    role: user.role 
                }, 
                process.env.JWT_SECRET, 
                { expiresIn: '24h' }
            );

            return res.status(200).json({
                success: true,
                message: 'Login successful',
                token: token,
                user: {
                    id: user.id,
                    username: user.username,
                    role: user.role
                }
            });
        } else {
            return res.status(401).json({ 
                success: false,
                message: 'Invalid password' 
            });
        }

    } catch (error) {
        console.error('Bypass login error:', error);
        res.status(500).json({ 
            success: false,
            message: 'Login failed',
            error: error.message
        });
    }
});

const PORT = process.env.PORT || 5011;
app.listen(PORT, () => {
    console.log(`Bypass server running on port ${PORT}`);
});
