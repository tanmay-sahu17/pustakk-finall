const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const env = require('./config/env');

// Initialize Express app
const app = express();

// Middleware
app.use(cors({
    origin: [
        // 'http://localhost:3000', 
        'http://127.0.0.1:3000', 
        // 'http://localhost:8080',
        // 'http://localhost:8000',
        // 'http://localhost:9000',
        'http://127.0.0.1:3306',
        'http://localhost:3001',
        'http://10.0.2.2:9005',
        'http://10.0.2.2:8080',
        'http://165.22.208.62:5010',  // Production server
        'http://165.22.208.62',       // Production server without port
        'https://165.22.208.62:5010', // HTTPS version
        'https://165.22.208.62',      // HTTPS version without port
        '*' // Allow all origins for development
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept', 'Origin'],
    credentials: true // Enable credentials for production
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Test endpoint for API connectivity
app.get('/api/test', (req, res) => {
    res.json({ message: 'API is working', timestamp: new Date().toISOString() });
});

// Database connection (disabled for testing)
console.log('Connecting to MySQL...');
/*
const { connectDB } = require('./config/database');
const useInMemoryDb = env.USE_MEMORY_DB;
if (useInMemoryDb) {
    console.log('Using in-memory database for development/testing...');
    const dbConfig = require('./config/in-memory-db');
    dbConfig.connect()
        .then(() => console.log('In-memory database connected successfully'))
        .catch(err => console.error('In-memory database connection error:', err));
} else {
    connectDB()
        .then(() => console.log('MySQL database connection and sync completed'))
        .catch(err => {
            console.error('MySQL connection error:', err.message);
            console.log('\nPossible solutions:');
            console.log('1. Make sure MySQL is installed and running');
            console.log('2. Check your database credentials in .env file');
            console.log('3. Make sure the database exists or create it');
            console.log('4. Set USE_MEMORY_DB=true in your .env to use in-memory database');
        });
}
*/

// Simple test route
app.get('/api/test', (req, res) => {
    res.json({ 
        success: true, 
        message: 'API is working!', 
        timestamp: new Date().toISOString() 
    });
});

// Routes
app.use('/api/auth', authRoutes);

// Serve static files
app.use('/uploads', express.static('uploads'));

// Simple error handler
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ message: 'Something went wrong!' });
});

// Export the app
module.exports = app;