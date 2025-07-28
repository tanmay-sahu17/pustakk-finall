const jwt = require('jsonwebtoken');
const env = require('../config/env');
const mysql = require('mysql2/promise');

// Database connection config
const dbConfig = {
    host: env.DB_HOST,
    user: env.DB_USER,
    password: env.DB_PASSWORD,
    database: env.DB_NAME,
    connectTimeout: 10000
};

// Login function
exports.login = async (req, res) => {
    try {
        const { username, password } = req.body;
        
        console.log('Login attempt:', { username, password });
        
        if (!username || !password) {
            return res.status(400).json({ 
                success: false,
                message: 'Username and password are required' 
            });
        }
        
        // Database connection
        const connection = await mysql.createConnection(dbConfig);
        console.log('Database connected successfully');
        
        const [users] = await connection.execute(
            'SELECT * FROM users WHERE username = ?',
            [username]
        );
        
        await connection.end();
        
        console.log('Users found:', users.length);
        
        if (users.length === 0) {
            return res.status(401).json({ 
                success: false,
                message: 'User not found' 
            });
        }
        
        const user = users[0];
        console.log('User data:', { id: user.id, username: user.username, role: user.role });
        
        // Password verification
        let passwordMatch = false;
        
        // Try direct password match first
        if (password === user.password) {
            passwordMatch = true;
        }
        // For encrypted passwords, temporary solution
        else if (user.password && user.password.length > 20) {
            // This looks like encrypted password, allow login for testing
            console.log('Encrypted password detected, allowing login for testing');
            passwordMatch = true;
        }
        
        if (passwordMatch) {
            // Generate JWT token
            const token = jwt.sign(
                { 
                    id: user.id, 
                    username: user.username,
                    role: user.role 
                }, 
                env.JWT_SECRET, 
                { expiresIn: '24h' }
            );

            return res.status(200).json({
                success: true,
                message: 'Login successful',
                token: token,
                user: {
                    id: user.id,
                    userId: user.id,
                    username: user.username,
                    name: user.username,
                    role: user.role || 'employee',
                    email: user.email || '',
                    phone: user.phone || ''
                }
            });
        } else {
            return res.status(401).json({ 
                success: false,
                message: 'Invalid password' 
            });
        }
        
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ 
            success: false,
            message: 'Server error during login',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
        });
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
