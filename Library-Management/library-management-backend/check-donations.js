const mysql = require('mysql2/promise');

async function checkDonationsTable() {
  try {
    const connection = await mysql.createConnection({
      host: '165.22.208.62',
      port: 3306,
      user: 'root',
      password: 'Ssipmt@2025DODB',
      database: 'library_management'
    });
    
    console.log('Checking donations table...');
    const [tables] = await connection.execute("SHOW TABLES LIKE 'donations'");
    
    if (tables.length === 0) {
      console.log('❌ Donations table does not exist!');
      console.log('Creating donations table...');
      
      await connection.execute(`
        CREATE TABLE donations (
          id INT AUTO_INCREMENT PRIMARY KEY,
          donor_name VARCHAR(255) NOT NULL,
          donor_email VARCHAR(255) NOT NULL,
          donor_phone VARCHAR(20),
          book_title VARCHAR(255) NOT NULL,
          book_author VARCHAR(255),
          book_isbn VARCHAR(50),
          book_condition VARCHAR(50),
          pickup_address TEXT NOT NULL,
          pickup_date DATE,
          notes TEXT,
          status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
      `);
      
      console.log('✅ Donations table created successfully!');
    } else {
      console.log('✅ Donations table exists');
      const [count] = await connection.execute('SELECT COUNT(*) as count FROM donations');
      console.log(`Total donations: ${count[0].count}`);
    }
    
    await connection.end();
    console.log('Database connection closed.');
  } catch (error) {
    console.error('Database error:', error.message);
  }
}

checkDonationsTable();
