const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
const PORT = 9003;

// Middleware
app.use(cors());
app.use(express.json());

// MySQL connection
const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '', // Your MySQL password
  database: 'library_management'
};

// Test endpoint
app.get('/api/test', (req, res) => {
    res.json({ message: 'API is working', timestamp: new Date().toISOString() });
});

// Get donations
app.get('/api/donations', async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute('SELECT * FROM donations ORDER BY createdAt DESC');
        await connection.end();
        
        res.json({
            success: true,
            donations: rows
        });
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching donations',
            error: error.message
        });
    }
});

// Add donation
app.post('/api/donations', async (req, res) => {
    try {
        const { bookName, author, donorName, mobile, category, bookCondition, isbn } = req.body;
        
        const connection = await mysql.createConnection(dbConfig);
        
        // Create table if not exists
        await connection.execute(`
            CREATE TABLE IF NOT EXISTS donations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                bookName VARCHAR(255) NOT NULL,
                author VARCHAR(255),
                donorName VARCHAR(255) NOT NULL,
                mobile VARCHAR(20),
                category VARCHAR(100),
                bookCondition VARCHAR(50),
                isbn VARCHAR(20),
                status VARCHAR(50) DEFAULT 'समीक्षा में',
                donationDate DATE DEFAULT (CURRENT_DATE),
                createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `);
        
        const [result] = await connection.execute(
            'INSERT INTO donations (bookName, author, donorName, mobile, category, bookCondition, isbn) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [bookName, author, donorName, mobile, category, bookCondition, isbn]
        );
        
        await connection.end();
        
        res.json({
            success: true,
            message: 'Donation added successfully',
            donationId: result.insertId
        });
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({
            success: false,
            message: 'Error adding donation',
            error: error.message
        });
    }
});

// Delete donation
app.delete('/api/donations/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const connection = await mysql.createConnection(dbConfig);
        
        await connection.execute('DELETE FROM donations WHERE id = ?', [id]);
        await connection.end();
        
        res.json({
            success: true,
            message: 'Donation deleted successfully'
        });
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({
            success: false,
            message: 'Error deleting donation',
            error: error.message
        });
    }
});

// Auth login endpoint
app.post('/api/auth/login', async (req, res) => {
    const { userId, password } = req.body;
    
    console.log('Login attempt:', { userId, password });
    
    // Test credentials
    if ((userId === 'user1' && password === 'sml@2025') || 
        (userId === 'test' && password === 'password') ||
        (userId === 'testuser' && password === 'password123')) {
        
        res.json({
            message: 'Login successful',
            token: 'test_token_12345',
            user: {
                id: '1',
                userId: userId,
                username: 'Test User',
                email: 'test@example.com'
            }
        });
    } else {
        res.status(401).json({ message: 'Invalid credentials' });
    }
});

app.listen(PORT, () => {
    console.log(`Simple backend server running on http://localhost:${PORT}`);
    console.log('✅ API endpoints ready:');
    console.log('   - GET /api/test');
    console.log('   - POST /api/auth/login');
    console.log('   - GET /api/donations');
    console.log('   - POST /api/donations');
    console.log('   - DELETE /api/donations/:id');
});
