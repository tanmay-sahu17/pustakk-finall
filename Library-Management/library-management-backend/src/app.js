const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const adminRoutes = require('./routes/adminRoutes');
const adminBookRoutes = require('./routes/adminBookRoutes');
const authRoutes = require('./routes/authRoutes');
const bookRoutes = require('./routes/bookRoutes');
const certificateRoutes = require('./routes/certificateRoutes');
const transactionRoutes = require('./routes/transactionRoutes');
const employeeRoutes = require('./routes/employeeRoutes');
const donationRoutes = require('./routes/donationRoutes');
const errorHandler = require('./middlewares/errorHandler');
const env = require('./config/env');

// Initialize Express app
const app = express();

// Middleware
app.use(cors({
    origin: [
        'http://localhost:3000', 
        'http://127.0.0.1:3000', 
        'http://localhost:8080',
        'http://localhost:8000',
        'http://localhost:9000',
        'http://localhost:3001',
        'http://10.0.2.2:9005',
        'http://10.0.2.2:8080',
        '*' // Allow all origins for development
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: false // Set to false for broader compatibility
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Test endpoint for API connectivity
app.get('/api/test', (req, res) => {
    res.json({ message: 'API is working', timestamp: new Date().toISOString() });
});

// Database connection
const { connectDB } = require('./config/database');

// Check if we should use in-memory DB (for development/testing) or real MySQL
const useInMemoryDb = env.USE_MEMORY_DB;

if (useInMemoryDb) {
    console.log('Using in-memory database for development/testing...');
    const dbConfig = require('./config/in-memory-db');
    dbConfig.connect()
        .then(() => console.log('In-memory database connected successfully'))
        .catch(err => console.error('In-memory database connection error:', err));
} else {
    console.log(`Attempting to connect to MySQL database...`);
    
    // Connect to MySQL database
    connectDB()
        .then(() => console.log('MySQL database connection and sync completed'))
        .catch(err => {
            console.error('MySQL connection error:', err.message);
            console.log('\nPossible solutions:');
            console.log('1. Make sure MySQL is installed and running');
            console.log('2. Check your database credentials in .env file');
            console.log('3. Make sure the database exists or create it');
            console.log('4. Set USE_MEMORY_DB=true in your .env to use in-memory database');
            process.exit(1); // Exit with error
        });
}

// Simple test route
app.get('/api/test', (req, res) => {
    res.json({ 
        success: true, 
        message: 'API is working!', 
        timestamp: new Date().toISOString() 
    });
});

// Routes
app.use('/api/admin', adminRoutes);
app.use('/api/admin/books', adminBookRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/books', bookRoutes);
app.use('/api/certificates', certificateRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/employees', employeeRoutes);
app.use('/api/donations', donationRoutes);

// Serve static files
app.use('/uploads', express.static('uploads'));

// Error handling middleware
app.use(errorHandler);

// Export the app
module.exports = app;