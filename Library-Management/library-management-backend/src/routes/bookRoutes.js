const express = require('express');
const router = express.Router();

// Get all books
router.get('/', (req, res) => {
    res.status(200).json({ message: 'Get all books - Not implemented yet' });
});

// Search books by name
router.get('/search/name/:name', (req, res) => {
    const bookName = req.params.name;
    res.status(200).json({ 
        message: `Search books by name: "${bookName}" - Not implemented yet`,
        searchTerm: bookName 
    });
});

// Search books by name (query parameter)
router.get('/search', (req, res) => {
    const bookName = req.query.name;
    if (!bookName) {
        return res.status(400).json({ 
            message: 'Please provide book name in query parameter (?name=bookname)' 
        });
    }
    res.status(200).json({ 
        message: `Search books by name: "${bookName}" - Not implemented yet`,
        searchTerm: bookName 
    });
});

// Get latest books
router.get('/latest', (req, res) => {
    res.status(200).json({ message: 'Get latest books - Not implemented yet' });
});

// Get book by ID
router.get('/:id', (req, res) => {
    res.status(200).json({ message: `Get book with ID ${req.params.id} - Not implemented yet` });
});

// Create new book
router.post('/', (req, res) => {
    res.status(201).json({ message: 'Create new book - Not implemented yet' });
});

// Donate a book
router.post('/donate', (req, res) => {
    res.status(201).json({ message: 'Donate a book - Not implemented yet' });
});

// Borrow a book
router.post('/borrow', (req, res) => {
    res.status(200).json({ message: 'Borrow a book - Not implemented yet' });
});

// Return a borrowed book
router.post('/return', (req, res) => {
    res.status(200).json({ message: 'Return a borrowed book - Not implemented yet' });
});

// Get issued books by user
router.get('/user/issued', (req, res) => {
    res.status(200).json({ message: 'Get issued books by user - Not implemented yet' });
});

// Download e-book PDF
router.get('/download/:id', (req, res) => {
    res.status(200).json({ message: `Download e-book with ID ${req.params.id} - Not implemented yet` });
});

// Update book
router.put('/:id', (req, res) => {
    res.status(200).json({ message: `Update book with ID ${req.params.id} - Not implemented yet` });
});

// Delete book
router.delete('/:id', (req, res) => {
    res.status(200).json({ message: `Delete book with ID ${req.params.id} - Not implemented yet` });
});

module.exports = router;
