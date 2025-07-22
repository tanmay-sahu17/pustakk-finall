const express = require('express');
const router = express.Router();
const Donation = require('../models/Donation');
const User = require('../models/User');

// Get all donations
router.get('/', async (req, res) => {
    try {
        const donations = await Donation.findAll({
            include: [{
                model: User,
                as: 'donor',
                attributes: ['name', 'email']
            }],
            order: [['createdAt', 'DESC']]
        });
        
        console.log('=== BACKEND: Fetched donations ===');
        console.log('Count:', donations.length);
        console.log('Data:', JSON.stringify(donations, null, 2));
        console.log('=================================');
        
        res.status(200).json({
            success: true,
            data: donations,
            count: donations.length
        });
    } catch (error) {
        console.error('Error fetching donations:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching donations',
            error: error.message
        });
    }
});

// Create new donation
router.post('/', async (req, res) => {
    try {
        const {
            donorId,
            bookTitle,
            bookAuthor,
            bookGenre,
            bookCondition,
            bookIsbn,
            bookDescription,
            bookLanguage
        } = req.body;
        
        const donation = await Donation.create({
            donorId: donorId || 1,
            bookTitle,
            bookAuthor,
            bookGenre,
            bookCondition,
            bookIsbn,
            bookDescription,
            bookLanguage: bookLanguage || 'Hindi'
        });
        
        console.log('=== BACKEND: Created donation ===');
        console.log('Data:', JSON.stringify(donation, null, 2));
        console.log('================================');
        
        res.status(201).json({
            success: true,
            data: donation,
            message: 'Donation created successfully'
        });
    } catch (error) {
        console.error('Error creating donation:', error);
        res.status(500).json({
            success: false,
            message: 'Error creating donation',
            error: error.message
        });
    }
});

module.exports = router;
