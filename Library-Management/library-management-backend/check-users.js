const mysql = require('mysql2/promise');

async function checkUsers() {
  try {
    const connection = await mysql.createConnection({
      host: '165.22.208.62',
      port: 3306,
      user: 'root',
      password: 'Ssipmt@2025DODB',
      database: 'library_management'
    });
    
    console.log('\n=== USERS TABLE ===');
    const [users] = await connection.execute('SELECT username, password FROM users LIMIT 10');
    users.forEach((user, index) => {
      console.log(`${index + 1}. Username: ${user.username}, Password: ${user.password}`);
    });
    
    console.log('\n=== ADMINS TABLE ===');
    const [admins] = await connection.execute('SELECT username, password FROM admins LIMIT 10');
    admins.forEach((admin, index) => {
      console.log(`${index + 1}. Username: ${admin.username}, Password: ${admin.password}`);
    });
    
    await connection.end();
    console.log('\nDatabase connection closed.');
  } catch (error) {
    console.error('Database error:', error.message);
  }
}

checkUsers();
