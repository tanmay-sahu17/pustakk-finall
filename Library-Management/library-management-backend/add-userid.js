const sequelize = require('./src/config/database');

async function addUserIdColumn() {
    try {
        await sequelize.authenticate();
        console.log('Database connected');
        
        // Add userId column to users table
        await sequelize.query(`
            ALTER TABLE users 
            ADD COLUMN userId VARCHAR(50) UNIQUE AFTER id;
        `);
        
        console.log('userId column added successfully');
        process.exit(0);
    } catch (error) {
        if (error.original && error.original.code === 'ER_DUP_FIELDNAME') {
            console.log('userId column already exists');
            process.exit(0);
        }
        console.error('Error:', error.message);
        process.exit(1);
    }
}

addUserIdColumn();
