const jwt = require('jsonwebtoken');
const User = require('../models/User');

const userAuth = async (req, res, next) => {
    try {
        // For development - allow requests without auth
        const authHeader = req.headers['authorization'];
        if (!authHeader) {
            console.log('No auth header - allowing for development');
            return next();
        }

        const token = authHeader.split(' ')[1];
        if (!token) {
            console.log('No token - allowing for development');
            return next();
        }

        // If it's a mock token, allow it
        if (token === 'mock_token_12345') {
            console.log('Mock token detected - allowing');
            req.user = { id: 'user1', userId: 'user1' };
            return next();
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = await User.findById(decoded.id);
        if (!req.user) {
            return res.status(404).json({ message: 'User not found' });
        }

        next();
    } catch (error) {
        console.log('Auth error - allowing for development:', error.message);
        return next();
    }
};

module.exports = userAuth;