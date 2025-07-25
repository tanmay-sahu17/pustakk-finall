const { Sequelize } = require('sequelize');
const env = require('./env');

// Initialize Sequelize with MySQL configuration
const sequelize = new Sequelize(
    env.DB_NAME || 'library_management',  // database name
    env.DB_USER || 'root',                // username  
    env.DB_PASSWORD || '',                // password
    {
        host: env.DB_HOST || 'localhost',
        port: env.DB_PORT || 3306,
        dialect: 'mysql',
        logging: false, // Disable SQL logging for faster startup
        pool: {
            max: 3,        // Reduced from 5
            min: 0,
            acquire: 10000, // Reduced from 30000
            idle: 5000     // Reduced from 10000
        },
        dialectOptions: {
            connectTimeout: 5000,  // 5 seconds connection timeout
            // Removed acquireTimeout and timeout - not supported in MySQL2
        }
    }
);

// Test the connection
const connectDB = async () => {
    try {
        console.log('Connecting to MySQL...');
        await sequelize.authenticate();
        console.log('MySQL connected successfully');
        
        // Only sync if tables don't exist (faster startup)
        if (env.NODE_ENV === 'development') {
            await sequelize.sync({ 
                force: false,  // Don't drop existing tables
                alter: true   // Allow altering existing tables to match models
            });
            console.log('Database tables synchronized');
        }
        
    } catch (error) {
        console.error('MySQL connection failed:', error.message);
        process.exit(1);
    }
};

module.exports = sequelize;
module.exports.connectDB = connectDB;