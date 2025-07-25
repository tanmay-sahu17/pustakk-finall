const sequelize = require('./src/config/database');

async function addMissingColumns() {
    try {
        await sequelize.authenticate();
        console.log('Database connected');
        
        // Add columns individually with error handling
        const columns = [
            {name: 'email', definition: 'VARCHAR(255) UNIQUE'},
            {name: 'firstName', definition: 'VARCHAR(100)'},
            {name: 'lastName', definition: 'VARCHAR(100)'},
            {name: 'phone', definition: 'VARCHAR(20)'},
            {name: 'address', definition: 'TEXT'},
            {name: 'membershipType', definition: "ENUM('Basic', 'Premium', 'Student', 'Faculty') DEFAULT 'Basic'"},
            {name: 'isActive', definition: 'BOOLEAN DEFAULT true'},
            {name: 'joinDate', definition: 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP'},
            {name: 'updatedAt', definition: 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'}
        ];
        
        for (let col of columns) {
            try {
                await sequelize.query(`ALTER TABLE users ADD COLUMN ${col.name} ${col.definition}`);
                console.log(`✓ Added column: ${col.name}`);
            } catch (error) {
                if (error.original && error.original.code === 'ER_DUP_FIELDNAME') {
                    console.log(`- Column ${col.name} already exists`);
                } else {
                    console.log(`⚠ Error adding ${col.name}:`, error.message);
                }
            }
        }
        
        console.log('\n✅ All columns processed!');
        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

addMissingColumns();
