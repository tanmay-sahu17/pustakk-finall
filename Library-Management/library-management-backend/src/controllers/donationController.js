const Donation = require('../models/Donation');
const { Op } = require('sequelize');

// Get all donations
const getAllDonations = async (req, res) => {
    try {
        const donations = await Donation.findAll({
            order: [['createdAt', 'DESC']]
        });

        // Transform data for frontend compatibility
        const transformedDonations = donations.map(donation => ({
            id: donation.id,
            bookName: donation.bookTitle,
            author: donation.bookAuthor,
            donor: `Donor ${donation.donorId}`, // Temporary - will link with user table later
            date: new Date(donation.createdAt).toLocaleDateString('hi-IN'),
            category: donation.bookGenre,
            status: donation.status === 'PENDING' ? 'समीक्षा में' : 
                   donation.status === 'APPROVED' ? 'स्वीकृत' : 
                   donation.status === 'REJECTED' ? 'अस्वीकृत' : 'समीक्षा में',
            condition: donation.bookCondition,
            description: donation.bookDescription
        }));

        res.status(200).json({
            success: true,
            data: transformedDonations,
            count: transformedDonations.length
        });
    } catch (error) {
        console.error('Error fetching donations:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching donations',
            error: error.message
        });
    }
};

// Get donation by ID
const getDonationById = async (req, res) => {
    try {
        const donation = await Donation.findByPk(req.params.id);
        
        if (!donation) {
            return res.status(404).json({
                success: false,
                message: 'Donation not found'
            });
        }

        const transformedDonation = {
            id: donation.id,
            bookName: donation.bookTitle,
            author: donation.bookAuthor,
            donor: `Donor ${donation.donorId}`, // Temporary - will link with user table later
            date: new Date(donation.createdAt).toLocaleDateString('hi-IN'),
            category: donation.bookGenre,
            status: donation.status === 'PENDING' ? 'समीक्षा में' : 
                   donation.status === 'APPROVED' ? 'स्वीकृत' : 
                   donation.status === 'REJECTED' ? 'अस्वीकृत' : 'समीक्षा में',
            condition: donation.bookCondition,
            description: donation.bookDescription
        };

        res.status(200).json({
            success: true,
            data: transformedDonation
        });
    } catch (error) {
        console.error('Error fetching donation:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching donation',
            error: error.message
        });
    }
};

// Create new donation
const createDonation = async (req, res) => {
    try {
        const {
            bookName,
            author,
            donorName,
            category,
            condition = 'Good',
            description
        } = req.body;

        // Validate required fields
        if (!bookName || !author || !donorName || !category) {
            return res.status(400).json({
                success: false,
                message: 'Book name, author, donor name, and category are required'
            });
        }

        // Generate donation ID
        const donationId = `DON-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

        const newDonation = await Donation.create({
            donationId,
            donorId: 1, // Default donor ID for now
            bookTitle: bookName,
            bookAuthor: author,
            bookGenre: category,
            bookCondition: condition,
            bookDescription: description,
            status: 'PENDING',
            submissionDate: new Date()
        });

        const transformedDonation = {
            id: newDonation.id,
            bookName: newDonation.bookTitle,
            author: newDonation.bookAuthor,
            donor: `Donor ${newDonation.donorId}`,
            date: new Date(newDonation.createdAt).toLocaleDateString('hi-IN'),
            category: newDonation.bookGenre,
            status: 'समीक्षा में',
            condition: newDonation.bookCondition,
            description: newDonation.bookDescription
        };

        res.status(201).json({
            success: true,
            message: 'Donation created successfully',
            data: transformedDonation
        });
    } catch (error) {
        console.error('Error creating donation:', error);
        res.status(500).json({
            success: false,
            message: 'Error creating donation',
            error: error.message
        });
    }
};

// Update donation status
const updateDonationStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;

        const donation = await Donation.findByPk(id);
        
        if (!donation) {
            return res.status(404).json({
                success: false,
                message: 'Donation not found'
            });
        }

        // Map Hindi status to English
        let englishStatus = status;
        if (status === 'समीक्षा में') englishStatus = 'PENDING';
        else if (status === 'स्वीकृत') englishStatus = 'APPROVED';
        else if (status === 'अस्वीकृत') englishStatus = 'REJECTED';

        await donation.update({ status: englishStatus });

        res.status(200).json({
            success: true,
            message: 'Donation status updated successfully',
            data: {
                id: donation.id,
                status: status
            }
        });
    } catch (error) {
        console.error('Error updating donation status:', error);
        res.status(500).json({
            success: false,
            message: 'Error updating donation status',
            error: error.message
        });
    }
};

// Get donation statistics
const getDonationStats = async (req, res) => {
    try {
        const totalDonations = await Donation.count();
        const pendingDonations = await Donation.count({ where: { status: 'PENDING' } });
        const approvedDonations = await Donation.count({ where: { status: 'APPROVED' } });
        const rejectedDonations = await Donation.count({ where: { status: 'REJECTED' } });

        // Get unique donors count
        const uniqueDonors = await Donation.findAll({
            attributes: ['donorId'],
            group: ['donorId']
        });

        res.status(200).json({
            success: true,
            data: {
                totalDonations,
                pendingDonations,
                approvedDonations,
                rejectedDonations,
                uniqueDonors: uniqueDonors.length
            }
        });
    } catch (error) {
        console.error('Error fetching donation stats:', error);
        res.status(500).json({
            success: false,
            message: 'Error fetching donation statistics',
            error: error.message
        });
    }
};

// Delete donation
const deleteDonation = async (req, res) => {
    try {
        const { id } = req.params;

        const donation = await Donation.findByPk(id);
        
        if (!donation) {
            return res.status(404).json({
                success: false,
                message: 'Donation not found'
            });
        }

        await donation.destroy();

        res.status(200).json({
            success: true,
            message: 'Donation deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting donation:', error);
        res.status(500).json({
            success: false,
            message: 'Error deleting donation',
            error: error.message
        });
    }
};

module.exports = {
    getAllDonations,
    getDonationById,
    createDonation,
    updateDonationStatus,
    getDonationStats,
    deleteDonation
};
