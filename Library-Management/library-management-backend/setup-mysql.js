// Manual MySQL connection test with user input
const { Sequelize } = require('sequelize');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function askQuestion(question) {
    return new Promise((resolve) => {
        rl.question(question, resolve);
    });
}

async function testManualConnection() {
    console.log('🔧 Manual MySQL Connection Test\n');
    
    try {
        const user = await askQuestion('Enter MySQL username (default: root): ') || 'root';
        const password = await askQuestion('Enter MySQL password (press Enter if empty): ');
        const host = await askQuestion('Enter MySQL host (default: localhost): ') || 'localhost';
        const port = await askQuestion('Enter MySQL port (default: 3306): ') || '3306';
        
        console.log('\n🔍 Testing connection...');
        
        const sequelize = new Sequelize({
            host: host,
            port: parseInt(port),
            username: user,
            password: password,
            dialect: 'mysql',
            logging: false
        });
        
        await sequelize.authenticate();
        console.log('✅ Connection successful!');
        
        // Try to create database
        await sequelize.query('CREATE DATABASE IF NOT EXISTS library_management');
        console.log('✅ Database "library_management" created/verified!');
        
        // Update .env file
        const fs = require('fs');
        const envContent = `PORT=9000
USE_MEMORY_DB=false

# MySQL Database Configuration
DB_NAME=library_management
DB_USER=${user}
DB_PASSWORD=${password}
DB_HOST=${host}
DB_PORT=${port}

# Legacy MongoDB configuration (not used anymore)
#DB_URI=mongodb://127.0.0.1:27017/library_management
MONGODB_DB=library_management

JWT_SECRET=jvbndflbjdlfbndlnbldkfnbdfklnkmfbndlf
UPLOADS_PATH=uploads/
CERTIFICATES_PATH=uploads/certificates/`;
        
        fs.writeFileSync('.env', envContent);
        console.log('✅ .env file updated with working configuration!');
        
        await sequelize.close();
        console.log('\n🎉 Setup complete! You can now restart the server with MySQL.');
        
    } catch (error) {
        console.log(`❌ Failed: ${error.message}`);
        console.log('\n💡 Troubleshooting tips:');
        console.log('1. Make sure MySQL server is running');
        console.log('2. Check if the password is correct');
        console.log('3. Try connecting with MySQL Workbench first');
        console.log('4. Reset MySQL root password if needed');
    }
    
    rl.close();
}

testManualConnection();
