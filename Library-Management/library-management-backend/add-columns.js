const mysql = require('mysql2/promise');

async function addMissingColumns() {
  try {
    const connection = await mysql.createConnection({
      host: '165.22.208.62',
      port: 3306,
      user: 'root',
      password: 'Ssipmt@2025DODB',
      database: 'library_management'
    });
    
    console.log('Checking current donations table structure...');
    
    // First check existing columns
    const [columns] = await connection.execute('DESCRIBE donations');
    console.log('\nCurrent columns:');
    columns.forEach(col => {
      console.log(`- ${col.Field} (${col.Type})`);
    });
    
    // Check if required columns exist
    const hasdonor_name = columns.find(col => col.Field === 'donor_name');
    const hasbook_title = columns.find(col => col.Field === 'book_title');
    const hasdonor_email = columns.find(col => col.Field === 'donor_email');
    
    console.log('\nAdding missing columns...');
    
    if (!hasdonor_name) {
      await connection.execute('ALTER TABLE donations ADD COLUMN donor_name VARCHAR(255)');
      console.log('✅ Added donor_name column');
    } else {
      console.log('- donor_name already exists');
    }
    
    if (!hasbook_title) {
      await connection.execute('ALTER TABLE donations ADD COLUMN book_title VARCHAR(255)');
      console.log('✅ Added book_title column');
    } else {
      console.log('- book_title already exists');
    }
    
    if (!hasdonor_email) {
      await connection.execute('ALTER TABLE donations ADD COLUMN donor_email VARCHAR(255)');
      console.log('✅ Added donor_email column');
    } else {
      console.log('- donor_email already exists');
    }
    
    // Show final structure
    console.log('\nFinal table structure:');
    const [finalColumns] = await connection.execute('DESCRIBE donations');
    finalColumns.forEach(col => {
      console.log(`- ${col.Field} (${col.Type})`);
    });
    
    await connection.end();
    console.log('\nDatabase connection closed.');
  } catch (error) {
    console.error('Database error:', error.message);
  }
}

addMissingColumns();
