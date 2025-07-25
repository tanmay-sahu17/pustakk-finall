const sequelize = require('./src/config/database');

async function migrateUsersTable() {
    try {
        await sequelize.authenticate();
        console.log('Database connected');
        
        // Add missing columns one by one
        const migrations = [
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS email VARCHAR(255) UNIQUE AFTER password`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS firstName VARCHAR(100) AFTER email`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS lastName VARCHAR(100) AFTER firstName`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20) AFTER lastName`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS address TEXT AFTER phone`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS membershipType ENUM('Basic', 'Premium', 'Student', 'Faculty') DEFAULT 'Basic' AFTER address`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS isActive BOOLEAN DEFAULT true AFTER membershipType`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS joinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER isActive`,
            `ALTER TABLE users ADD COLUMN IF NOT EXISTS updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER joinDate`,
            `ALTER TABLE users MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`,
            `ALTER TABLE users MODIFY COLUMN userId VARCHAR(50) NOT NULL UNIQUE`,
            `ALTER TABLE users DROP COLUMN IF EXISTS role`
        ];
        
        for (let migration of migrations) {
            try {
                await sequelize.query(migration);
                console.log('✓ Executed:', migration.substring(0, 50) + '...');
            } catch (error) {
                if (!error.message.includes('Duplicate column name') && !error.message.includes("Can't DROP")) {
                    console.log('⚠ Warning:', migration.substring(0, 50) + '...', error.message);
                }
            }
        }
        
        console.log('\n✅ Migration completed!');
        
        // Check final structure
        const [results] = await sequelize.query(`DESCRIBE users`);
        console.log('\nFinal users table structure:');
        console.table(results);
        
        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

migrateUsersTable();
