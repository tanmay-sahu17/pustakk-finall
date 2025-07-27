const jwt = require('jsonwebtoken');
const env = require('../config/env');
const mysql = require('mysql2/promise');

// Database connection config
const dbConfig = {
    host: env.DB_HOST,
    user: env.DB_USER,
    password: env.DB_PASSWORD,
    database: env.DB_NAME,
    connectTimeout: 10000,
    acquireTimeout: 10000
};

// Simple login function for testing
exports.login = async (req, res) => {
    try {
        const { username, password } = req.body;
        
        console.log('Login attempt:', { username, password });
        
        // Try database connection first
        try {
            const connection = await mysql.createConnection(dbConfig);
            console.log('Database connected successfully');
            
            const [users] = await connection.execute(
                'SELECT * FROM users WHERE username = ?',
                [username]
            );
            
            await connection.end();
            
            console.log('Users found:', users.length);
            if (users.length > 0) {
                console.log('User data:', users[0]);
                const user = users[0];
                
                // Check password (assuming plain text for now)
                if (password === user.password) {
                    const token = jwt.sign(
                        { id: user.id, username: user.username }, 
                        env.JWT_SECRET, 
                        { expiresIn: '1d' }
                    );

                    return res.status(200).json({
                        message: 'Login successful',
                        token: token,
                        user: {
                            id: user.id,
                            username: user.username,
                            role: user.role || 'user'
                        }
                    });
                } else {
                    return res.status(401).json({ message: 'Invalid password' });
                }
            } else {
                return res.status(401).json({ message: 'User not found' });
            }
            
        } catch (dbError) {
            console.error('Database error:', dbError.message);
            
            // Fallback to hardcoded test user
            console.log('Using fallback test user');
            if (username === 'simple' && password === 'test123') {
                const token = jwt.sign({ id: 1, username: 'simple' }, env.JWT_SECRET, {
                    expiresIn: '1d'
                });

                return res.status(200).json({
                    message: 'Login successful (test mode)',
                    token: token,
                    user: {
                        id: 1,
                        username: 'simple',
                        role: 'user'
                    }
                });
            } else {
                return res.status(401).json({ message: 'Invalid credentials (test mode)' });
            }
        }
        
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};

// Placeholder functions for routes
exports.register = async (req, res) => {
    res.status(200).json({ message: 'Register endpoint - coming soon' });
};

exports.logout = async (req, res) => {
    res.status(200).json({ message: 'Logout successful' });
};

exports.adminRegister = async (req, res) => {
    res.status(200).json({ message: 'Admin register endpoint - coming soon' });
};

exports.adminLogin = async (req, res) => {
    res.status(200).json({ message: 'Admin login endpoint - coming soon' });
};

exports.adminLogout = async (req, res) => {
    res.status(200).json({ message: 'Admin logout successful' });
};
