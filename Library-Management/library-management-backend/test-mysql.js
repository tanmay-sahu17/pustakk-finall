// Simple MySQL connection test
const { Sequelize } = require('sequelize');

// Try different configurations
const configs = [
    { user: 'root', password: '', host: 'localhost', port: 3306 },
    { user: 'root', password: 'root', host: 'localhost', port: 3306 },
    { user: 'root', password: 'password', host: 'localhost', port: 3306 },
    { user: 'root', password: '123456', host: 'localhost', port: 3306 }
];

async function testConnection() {
    console.log('🔍 Testing MySQL connection with different configurations...\n');
    
    for (let i = 0; i < configs.length; i++) {
        const config = configs[i];
        console.log(`Testing config ${i + 1}: user=${config.user}, password=${config.password || '(empty)'}`);
        
        try {
            const sequelize = new Sequelize({
                host: config.host,
                port: config.port,
                username: config.user,
                password: config.password,
                dialect: 'mysql',
                logging: false
            });
            
            await sequelize.authenticate();
            console.log('✅ Connection successful!');
            
            // Try to create database
            await sequelize.query('CREATE DATABASE IF NOT EXISTS library_management');
            console.log('✅ Database "library_management" created/verified!');
            
            await sequelize.close();
            
            console.log(`\n🎉 Success! Use this configuration in your .env file:`);
            console.log(`DB_USER=${config.user}`);
            console.log(`DB_PASSWORD=${config.password}`);
            console.log(`DB_HOST=${config.host}`);
            console.log(`DB_PORT=${config.port}`);
            console.log(`DB_NAME=library_management`);
            return;
            
        } catch (error) {
            console.log(`❌ Failed: ${error.message}`);
        }
        console.log('');
    }
    
    console.log('❌ All connection attempts failed. Please check your MySQL installation.');
    console.log('\nPossible solutions:');
    console.log('1. Make sure MySQL server is running');
    console.log('2. Reset MySQL root password');
    console.log('3. Check if MySQL is running on port 3306');
    console.log('4. Try connecting with MySQL Workbench first');
}

testConnection();
