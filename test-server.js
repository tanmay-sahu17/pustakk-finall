const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 9000;

// Middleware
app.use(cors());
app.use(express.json());

// Test endpoint
app.get('/api/test', (req, res) => {
    res.json({ message: 'API is working', timestamp: new Date().toISOString() });
});

// Auth login endpoint
app.post('/api/auth/login', (req, res) => {
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
    console.log(`Test server running on http://localhost:${PORT}`);
});
