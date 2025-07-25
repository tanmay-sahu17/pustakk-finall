const mysql = require('mysql2/promise');

async function fixDonorIdColumn() {
  try {
    const connection = await mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: '', // Empty password
      database: 'library_management'
    });

    console.log('Connected to MySQL database');

    // Make donorId column nullable
    const alterQuery = `
      ALTER TABLE donations 
      MODIFY COLUMN donorId VARCHAR(255) NULL;
    `;

    await connection.execute(alterQuery);
    console.log('✅ Successfully made donorId column nullable');

    await connection.end();
    console.log('✅ Database connection closed');

  } catch (error) {
    console.error('❌ Error fixing donorId column:', error);
  }
}

fixDonorIdColumn();
