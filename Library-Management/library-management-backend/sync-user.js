const sequelize = require('./src/config/database');
const User = require('./src/models/User');

async function syncUserTable() {
    try {
        await sequelize.authenticate();
        console.log('Database connected');
        
        // Force sync User table only
        await User.sync({ force: true });
        console.log('User table recreated successfully');
        
        process.exit(0);
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

syncUserTable();
