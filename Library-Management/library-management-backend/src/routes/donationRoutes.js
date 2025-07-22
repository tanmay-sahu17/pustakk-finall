const express = require('express');
const router = express.Router();

// Get all donations
router.get('/', (req, res) => {
    res.status(200).json({ message: 'Get all donations - Not implemented yet' });
});

// Get donation by ID
router.get('/:id', (req, res) => {
    res.status(200).json({ message: `Get donation with ID ${req.params.id} - Not implemented yet` });
});

// Create new donation
router.post('/', (req, res) => {
    res.status(201).json({ message: 'Create new donation - Not implemented yet' });
});

// Update donation
router.put('/:id', (req, res) => {
    res.status(200).json({ message: `Update donation with ID ${req.params.id} - Not implemented yet` });
});

// Delete donation
router.delete('/:id', (req, res) => {
    res.status(200).json({ message: `Delete donation with ID ${req.params.id} - Not implemented yet` });
});

// Accept/Approve donation
router.patch('/:id/approve', (req, res) => {
    res.status(200).json({ message: `Approve donation with ID ${req.params.id} - Not implemented yet` });
});

// Reject donation
router.patch('/:id/reject', (req, res) => {
    res.status(200).json({ message: `Reject donation with ID ${req.params.id} - Not implemented yet` });
});

module.exports = router;
