const express = require('express');
const router = express.Router();
const {
    getAllDonations,
    getDonationById,
    createDonation,
    updateDonationStatus,
    getDonationStats,
    deleteDonation
} = require('../controllers/donationController');

// Get all donations
router.get('/', getAllDonations);

// Get donation statistics
router.get('/stats', getDonationStats);

// Get donation by ID
router.get('/:id', getDonationById);

// Create new donation
router.post('/', createDonation);

// Update donation status
router.put('/:id/status', updateDonationStatus);

// Delete donation
router.delete('/:id', deleteDonation);

// Legacy routes for approve/reject (keeping for compatibility)
router.patch('/:id/approve', async (req, res) => {
    req.body.status = 'approved';
    updateDonationStatus(req, res);
});

router.patch('/:id/reject', async (req, res) => {
    req.body.status = 'rejected';
    updateDonationStatus(req, res);
});

module.exports = router;
