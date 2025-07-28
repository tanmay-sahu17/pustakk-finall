const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/User');

// Login function
exports.login = async (req, res) => {
    try {
        const { username, userId, password } = req.body;
        const loginIdentifier = userId || username; // Use userId first, then username
        
        console.log('Login attempt:', { username, userId, loginIdentifier, password });
        
        if (!loginIdentifier || !password) {
            return res.status(400).json({ 
                success: false,
                message: 'Username/UserID and password are required' 
            });
        }
        
        // Find user using Sequelize model
        const user = await User.findByLogin(loginIdentifier);
        
        if (!user) {
            return res.status(401).json({ 
                success: false,
                message: 'Invalid credentials' 
            });
        }
        
        // Verify password
        const isPasswordValid = user.comparePassword(password);
        
        if (!isPasswordValid) {
            return res.status(401).json({ 
                success: false,
                message: 'Invalid credentials' 
            });
        }
        
        // Generate JWT token
        const token = jwt.sign(
            { 
                id: user.id, 
                username: user.username,
                role: user.role 
            },
            env.JWT_SECRET || 'your-secret-key',
            { expiresIn: '24h' }
        );
        
        console.log('Login successful for user:', user.username);
        
        res.json({
            success: true,
            message: 'Login successful',
            token: token,
            user: {
                id: user.id,
                username: user.username,
                role: user.role
            }
        });
        
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ 
            success: false,
            message: 'Error during login',
            error: error.message
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
