const mysql = require('mysql2/promise');
const env = require('../config/env');

// Database connection configuration
const dbConfig = {
    host: env.DB_HOST,
    port: env.DB_PORT,
    user: env.DB_USER,
    password: env.DB_PASSWORD,
    database: env.DB_NAME
};

// Get all donations
const getAllDonations = async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);
        const [donations] = await connection.execute('SELECT * FROM donations ORDER BY id DESC');
        await connection.end();
        
        res.status(200).json({
            success: true,
            data: donations,
            count: donations.length
        });
    } catch (error) {
        console.error('Get all donations error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch donations',
            error: error.message
        });
    }
};

// Get donation by ID
const getDonationById = async (req, res) => {
    try {
        const { id } = req.params;
        const connection = await mysql.createConnection(dbConfig);
        const [donations] = await connection.execute('SELECT * FROM donations WHERE id = ?', [id]);
        await connection.end();
        
        if (donations.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Donation not found'
            });
        }
        
        res.status(200).json({
            success: true,
            data: donations[0]
        });
    } catch (error) {
        console.error('Get donation by ID error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch donation',
            error: error.message
        });
    }
};

// Create new donation - COMPREHENSIVE FIX
const createDonation = async (req, res) => {
    try {
        const {
            donor_name,
            book_title,
            donor_email
        } = req.body;

        // Basic validation
        if (!donor_name || !book_title || !donor_email) {
            return res.status(400).json({
                success: false,
                message: 'Required fields: donor_name, book_title, donor_email'
            });
        }

        const connection = await mysql.createConnection(dbConfig);
        
        // First, find or create a user for the donor to satisfy foreign key constraint
        let donorId;
        try {
            // Try to find existing user by email
            const [existingUsers] = await connection.execute(
                'SELECT id FROM users WHERE email = ? OR username = ?',
                [donor_email, donor_name]
            );
            
            if (existingUsers.length > 0) {
                donorId = existingUsers[0].id;
            } else {
                // Create a new user for the donor
                const [newUser] = await connection.execute(
                    'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
                    [donor_name, donor_email, 'donor123'] // Default password for donors
                );
                donorId = newUser.insertId;
            }
        } catch (userError) {
            // If user creation fails, use existing user ID 1 (assuming it exists)
            console.log('Using default user ID due to error:', userError.message);
            const [defaultUser] = await connection.execute('SELECT id FROM users LIMIT 1');
            donorId = defaultUser.length > 0 ? defaultUser[0].id : 1;
        }
        
        // Generate unique donation ID
        const donationId = 'DON' + Date.now();
        
        // Insert with ALL required fields to avoid default value errors
        const [result] = await connection.execute(
            `INSERT INTO donations 
            (donationId, donorId, bookTitle, bookAuthor, bookIsbn, bookGenre, 
             bookCondition, bookDescription, bookPublishedYear, bookLanguage, 
             status, submissionDate, createdAt, updatedAt, 
             donor_name, book_title, donor_email) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW(), NOW(), ?, ?, ?)`,
            [
                donationId,           // donationId
                donorId,              // donorId (valid foreign key)
                book_title,           // bookTitle (using our input)
                'Unknown',            // bookAuthor (default)
                '',                   // bookIsbn (empty)
                'General',            // bookGenre (default)
                'Good',               // bookCondition (default)
                'Book donated via API', // bookDescription (default)
                2024,                 // bookPublishedYear (default)
                'English',            // bookLanguage (default)
                'PENDING',            // status
                donor_name,           // donor_name (our custom field)
                book_title,           // book_title (our custom field)
                donor_email           // donor_email (our custom field)
            ]
        );
        
        await connection.end();
        
        res.status(201).json({
            success: true,
            message: 'Donation created successfully',
            data: {
                id: result.insertId,
                donationId: donationId,
                donorId: donorId,
                donor_name,
                book_title,
                donor_email,
                donorId: donorId,
                donor_name,
                book_title,
                donor_email,
                status: 'PENDING'
            }
        });
    } catch (error) {
        console.error('Create donation error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to create donation',
            error: error.message
        });
    }
};

// Update donation status
const updateDonationStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        
        const connection = await mysql.createConnection(dbConfig);
        const [result] = await connection.execute(
            'UPDATE donations SET status = ? WHERE id = ?',
            [status, id]
        );
        await connection.end();
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Donation not found'
            });
        }
        
        res.status(200).json({
            success: true,
            message: `Donation ${status} successfully`,
            data: { id, status }
        });
    } catch (error) {
        console.error('Update donation status error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to update donation status',
            error: error.message
        });
    }
};

// Get donation statistics
const getDonationStats = async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);
        const [stats] = await connection.execute('SELECT COUNT(*) as total_donations FROM donations');
        await connection.end();
        
        res.status(200).json({
            success: true,
            data: stats[0]
        });
    } catch (error) {
        console.error('Get donation stats error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch donation statistics',
            error: error.message
        });
    }
};

// Delete donation
const deleteDonation = async (req, res) => {
    try {
        const { id } = req.params;
        const connection = await mysql.createConnection(dbConfig);
        const [result] = await connection.execute('DELETE FROM donations WHERE id = ?', [id]);
        await connection.end();
        
        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Donation not found'
            });
        }
        
        res.status(200).json({
            success: true,
            message: 'Donation deleted successfully'
        });
    } catch (error) {
        console.error('Delete donation error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to delete donation',
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
