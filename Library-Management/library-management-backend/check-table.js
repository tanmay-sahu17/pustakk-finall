const sequelize = require('./src/config/database');

async function checkTableStructure() {
    try {
        await sequelize.authenticate();
        console.log('Database connected');
        
        // Check current table structure
        const [results] = await sequelize.query(`DESCRIBE users`);
        console.log('Current users table structure:');
        console.table(results);
        
        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

checkTableStructure();
