// Load environment variables from .env file
require('dotenv').config();

// Export environment variables with fallbacks for safety
module.exports = {
    PORT: process.env.PORT || 5000,
    
    // MySQL Database Configuration
    DB_NAME: process.env.DB_NAME || 'library_management',
    DB_USER: process.env.DB_USER || 'root',
    DB_PASSWORD: process.env.DB_PASSWORD || '',
    DB_HOST: process.env.DB_HOST || 'localhost',
    DB_PORT: process.env.DB_PORT || 3306,
    
    // Legacy MongoDB (keep for compatibility)
    DB_URI: process.env.DB_URI || 'mongodb://localhost:27017/library',
    MONGODB_DB: process.env.MONGODB_DB || 'library_management',
    
    JWT_SECRET: process.env.JWT_SECRET || 'your_secure_jwt_secret_key',
    UPLOADS_PATH: process.env.UPLOADS_PATH || 'uploads/',
    CERTIFICATES_PATH: process.env.CERTIFICATES_PATH || 'uploads/certificates/',
    
    // Database selection
    USE_MEMORY_DB: process.env.USE_MEMORY_DB === 'true', // Use MySQL by default
};