const mysql = require('mysql2/promise');

async function checkDonationsTableStructure() {
  try {
    const connection = await mysql.createConnection({
      host: '165.22.208.62',
      port: 3306,
      user: 'root',
      password: 'Ssipmt@2025DODB',
      database: 'library_management'
    });
    
    console.log('Checking donations table structure...');
    const [columns] = await connection.execute('DESCRIBE donations');
    console.log('\nActual table columns:');
    columns.forEach(col => {
      console.log(`- ${col.Field} (${col.Type}) ${col.Null === 'YES' ? 'NULL' : 'NOT NULL'} ${col.Key ? col.Key : ''}`);
    });
    
    console.log('\nSample data:');
    const [rows] = await connection.execute('SELECT * FROM donations LIMIT 3');
    console.log('Total rows:', rows.length);
    if (rows.length > 0) {
      console.log('Sample row:', rows[0]);
    }
    
    await connection.end();
    console.log('\nDatabase connection closed.');
  } catch (error) {
    console.error('Database error:', error.message);
  }
}

checkDonationsTableStructure();
