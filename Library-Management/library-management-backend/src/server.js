// Load environment variables directly
require('dotenv').config();
const app = require('./app');
const env = require('./config/env');
const net = require('net');

// Function to find an available port
const findAvailablePort = (startPort, callback) => {
    // Ensure port is a number and within valid range (1-65535)
    let port = parseInt(startPort, 10);
    
    // Validate port range
    if (isNaN(port) || port < 1) {
        port = 3000; // Default to 3000 if invalid
    }
    
    // Maximum port number is 65535
    const MAX_PORT = 65535;
    
    function tryPort(currentPort) {
        // Ensure we don't exceed maximum port
        if (currentPort > MAX_PORT) {
            console.error(`Exceeded maximum port number (${MAX_PORT}). Using port 3000.`);
            callback(null, 3000);
            return;
        }

        const server = net.createServer();
        
        server.once('error', (err) => {
            if (err.code === 'EADDRINUSE') {
                // Remove verbose port trying messages
                tryPort(currentPort + 1);
            } else {
                callback(err);
            }
        });
        
        server.once('listening', () => {
            server.close(() => {
                callback(null, currentPort);
            });
        });
        
        server.listen(currentPort);
    }
    
    tryPort(port);
};

// Try to start the server on an available port
const preferredPort = process.env.PORT || 5010;
let serverHost = '0.0.0.0'; // Bind to all local interfaces (this is correct for local development)

console.log(`Starting server on ${serverHost}:${preferredPort}...`);
console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
console.log(`⚠️  Note: Server will bind to local machine, accessible via network`);

findAvailablePort(preferredPort, (err, availablePort) => {
    if (err) {
        console.error('Error finding available port:', err);
        process.exit(1);
    }
    
    const server = app.listen(availablePort, serverHost, () => {
        const serverUrl = `http://localhost:${availablePort}`;
        const externalUrl = `http://165.22.208.62:${availablePort}`;
        console.log(`🚀 Server running on ${serverUrl}`);
        console.log(`🌐 External URL (after deployment): ${externalUrl}`);
        console.log(`📡 Environment: ${process.env.NODE_ENV || 'development'}`);
        console.log(`🗄️  Database: ${process.env.DB_HOST || ''}:${process.env.DB_PORT || 3306}`);
    });
    
    // Handle server errors
    server.on('error', (err) => {
        console.error('Server error:', err);
        process.exit(1);
    });
    
    // Graceful shutdown
    process.on('SIGTERM', () => {
        console.log('SIGTERM received. Shutting down gracefully...');
        server.close(() => {
            console.log('Server closed.');
            process.exit(0);
        });
    });
});