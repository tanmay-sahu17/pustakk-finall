const mysql = require('mysql2/promise');

async function testSimpleInsert() {
  try {
    const connection = await mysql.createConnection({
      host: '165.22.208.62',
      port: 3306,
      user: 'root',
      password: 'Ssipmt@2025DODB',
      database: 'library_management'
    });
    
    console.log('Testing simple INSERT...');
    
    // Try a very basic insert with just required fields
    const [result] = await connection.execute(
      'INSERT INTO donations (name, email, title, address) VALUES (?, ?, ?, ?)',
      ['Test Name', 'test@test.com', 'Test Book', 'Test Address']
    );
    
    console.log('✅ INSERT successful! ID:', result.insertId);
    
    // Now get all donations to see structure
    const [donations] = await connection.execute('SELECT * FROM donations LIMIT 1');
    console.log('Sample donation:', donations[0]);
    
    await connection.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

testSimpleInsert();
