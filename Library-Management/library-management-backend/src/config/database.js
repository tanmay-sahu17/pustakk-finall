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
        logging: env.NODE_ENV === 'development' ? console.log : false,
        pool: {
            max: 5,
            min: 0,
            acquire: 30000,
            idle: 10000
        }
    }
);

// Test the connection
const connectDB = async () => {
    try {
        await sequelize.authenticate();
        console.log('MySQL connected successfully');
        
        // Sync all models (create tables if they don't exist)
        await sequelize.sync({ 
            force: false,  // Set to true to drop and recreate tables
            alter: false   // Set to true to alter existing tables
        });
        console.log('Database tables synchronized');
        
    } catch (error) {
        console.error('MySQL connection failed:', error.message);
        process.exit(1);
    }
};

module.exports = sequelize;
module.exports.connectDB = connectDB;