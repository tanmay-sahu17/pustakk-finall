-- ============================================================================
-- LIBRARY MANAGEMENT SYSTEM - DATABASE SETUP
-- ============================================================================
-- Database: library_management
-- MySQL Version: 8.0+
-- Created: 2025-07-26
-- Description: Complete database setup for Pustakalay Library Management System
-- ============================================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS `library_management` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Use the database
USE `library_management`;

-- ============================================================================
-- DROP EXISTING TABLES (if they exist) - BE CAREFUL IN PRODUCTION!
-- ============================================================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `donations`;
DROP TABLE IF EXISTS `certificates`;
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `employees`;
DROP TABLE IF EXISTS `books`;
DROP TABLE IF EXISTS `admins`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- TABLE: users
-- ============================================================================
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'employee',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `membershipType` enum('Basic','Premium','Student','Faculty') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Basic',
  `isActive` tinyint(1) DEFAULT '1',
  `joinDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userId` (`userId`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: admins
-- ============================================================================
CREATE TABLE `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `adminId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `firstName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'admin',
  `permissions` json DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT '1',
  `lastLogin` timestamp NULL DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `adminId` (`adminId`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: books
-- ============================================================================
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `isbn` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `genre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `publishedYear` int DEFAULT NULL,
  `publisher` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Hindi',
  `pages` int DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `condition` enum('New','Like New','Good','Fair','Poor') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Good',
  `availability` enum('Available','Borrowed','Reserved','Maintenance','Lost') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Available',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) DEFAULT '0.00',
  `donatedBy` int DEFAULT NULL,
  `donationDate` timestamp NULL DEFAULT NULL,
  `images` json DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bookId` (`bookId`),
  KEY `idx_title` (`title`),
  KEY `idx_author` (`author`),
  KEY `idx_genre` (`genre`),
  KEY `idx_availability` (`availability`),
  KEY `donatedBy` (`donatedBy`),
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`donatedBy`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: donations
-- ============================================================================
CREATE TABLE `donations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `donationId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `donorId` int DEFAULT NULL,
  `bookTitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bookAuthor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bookIsbn` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bookGenre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bookCondition` enum('New','Like New','Good','Fair','Poor') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bookDescription` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `bookImages` json DEFAULT NULL,
  `bookPublishedYear` int DEFAULT NULL,
  `bookLanguage` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Hindi',
  `status` enum('PENDING','UNDER_REVIEW','APPROVED','REJECTED','ADDED_TO_LIBRARY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `submissionDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewDate` timestamp NULL DEFAULT NULL,
  `reviewedById` int DEFAULT NULL,
  `reviewNotes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `rejectionReason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `estimatedValue` decimal(10,2) DEFAULT '0.00',
  `pickupDetails` json DEFAULT NULL,
  `donorPreferences` json DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `donationId` (`donationId`),
  KEY `idx_donor` (`donorId`),
  KEY `idx_status` (`status`),
  KEY `idx_submission_date` (`submissionDate`),
  KEY `reviewedById` (`reviewedById`),
  CONSTRAINT `donations_ibfk_1` FOREIGN KEY (`donorId`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `donations_ibfk_2` FOREIGN KEY (`reviewedById`) REFERENCES `admins` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: transactions
-- ============================================================================
CREATE TABLE `transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `bookId` int NOT NULL,
  `type` enum('BORROW','RETURN','RESERVE','EXTEND') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `borrowDate` timestamp NULL DEFAULT NULL,
  `dueDate` timestamp NULL DEFAULT NULL,
  `returnDate` timestamp NULL DEFAULT NULL,
  `status` enum('ACTIVE','COMPLETED','OVERDUE','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `fine` decimal(10,2) DEFAULT '0.00',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `processedBy` int DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transactionId` (`transactionId`),
  KEY `idx_user` (`userId`),
  KEY `idx_book` (`bookId`),
  KEY `idx_type` (`type`),
  KEY `idx_status` (`status`),
  KEY `idx_due_date` (`dueDate`),
  KEY `processedBy` (`processedBy`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`bookId`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transactions_ibfk_3` FOREIGN KEY (`processedBy`) REFERENCES `admins` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: employees
-- ============================================================================
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employeeId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `hireDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `isActive` tinyint(1) DEFAULT '1',
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `emergencyContact` json DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employeeId` (`employeeId`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_position` (`position`),
  KEY `idx_department` (`department`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: certificates
-- ============================================================================
CREATE TABLE `certificates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `certificateId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `donationId` int DEFAULT NULL,
  `type` enum('DONATION','VOLUNTEER','ACHIEVEMENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'DONATION',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `issueDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `validUntil` timestamp NULL DEFAULT NULL,
  `filePath` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `issuedBy` int DEFAULT NULL,
  `status` enum('ACTIVE','EXPIRED','REVOKED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `certificateId` (`certificateId`),
  KEY `idx_user` (`userId`),
  KEY `idx_type` (`type`),
  KEY `idx_issue_date` (`issueDate`),
  KEY `donationId` (`donationId`),
  KEY `issuedBy` (`issuedBy`),
  CONSTRAINT `certificates_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `certificates_ibfk_2` FOREIGN KEY (`donationId`) REFERENCES `donations` (`id`) ON DELETE SET NULL,
  CONSTRAINT `certificates_ibfk_3` FOREIGN KEY (`issuedBy`) REFERENCES `admins` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- INSERT SAMPLE DATA
-- ============================================================================

-- Insert sample users
INSERT INTO `users` (`userId`, `username`, `password`, `email`, `firstName`, `lastName`, `phone`, `membershipType`) VALUES
('USER001', 'testuser', '$2a$10$WpKKR9wGz7rZ6qCc5VzKtOHrXyGzKGZXxOy5GnN0QbMhJKmDfYrNO', 'user@test.com', 'Test', 'User', '9876543210', 'Basic'),
('karsh722', 'Karsh', '$2a$10$WpKKR9wGz7rZ6qCc5VzKtOHrXyGzKGZXxOy5GnN0QbMhJKmDfYrNO', 'karsh@library.com', 'Karsh', 'Verma', '7223053241', 'Premium'),
('tanmay626', 'Tanmay Sahu', '$2a$10$WpKKR9wGz7rZ6qCc5VzKtOHrXyGzKGZXxOy5GnN0QbMhJKmDfYrNO', 'tanmay@gmail.com', 'Tanmay', 'Sahu', '9876543211', 'Student'),
('autouser876', 'Auto User', '$2a$10$WpKKR9wGz7rZ6qCc5VzKtOHrXyGzKGZXxOy5GnN0QbMhJKmDfYrNO', 'auto@example.com', 'Auto', 'User', '9876543212', 'Faculty');

-- Insert sample admin
INSERT INTO `admins` (`adminId`, `username`, `password`, `email`, `firstName`, `lastName`, `role`) VALUES
('ADMIN001', 'admin123', '$2a$10$WpKKR9wGz7rZ6qCc5VzKtOHrXyGzKGZXxOy5GnN0QbMhJKmDfYrNO', 'admin@library.com', 'Library', 'Admin', 'super_admin');

-- Insert sample books
INSERT INTO `books` (`bookId`, `title`, `author`, `isbn`, `genre`, `publishedYear`, `language`, `condition`, `donatedBy`) VALUES
('BOOK001', 'गीता', 'महर्षि वेदव्यास', '9788129116123', 'Religious', 2020, 'Hindi', 'Good', 2),
('BOOK002', 'रामायण', 'महर्षि वाल्मीकि', '9788129116124', 'Religious', 2019, 'Hindi', 'Like New', 2),
('BOOK003', 'हरी घास के ये दिन', 'फणीश्वरनाथ रेणु', '9788126721589', 'Fiction', 2018, 'Hindi', 'Good', 3),
('BOOK004', 'गोदान', 'मुंशी प्रेमचंद', '9788126721590', 'Fiction', 2017, 'Hindi', 'Fair', 3);

-- Insert sample donations
INSERT INTO `donations` (`donationId`, `donorId`, `bookTitle`, `bookAuthor`, `bookGenre`, `bookCondition`, `bookDescription`, `status`) VALUES
('DON001', 2, 'भगवद् गीता', 'महर्षि वेदव्यास', 'Religious', 'Good', 'Donor: Karsh Verma, Mobile: 7223053241', 'APPROVED'),
('DON002', 3, 'गबन', 'मुंशी प्रेमचंद', 'Fiction', 'Like New', 'Donor: Tanmay Sahu, Mobile: 9876543211', 'PENDING'),
('DON003', 2, 'कपिल की डायरी', 'कपिल शर्मा', 'Biography', 'New', 'Donor: Karsh Verma, Mobile: 7223053241', 'UNDER_REVIEW');

-- ============================================================================
-- CREATE INDEXES FOR BETTER PERFORMANCE
-- ============================================================================

-- Additional indexes for better query performance
CREATE INDEX `idx_books_genre_availability` ON `books` (`genre`, `availability`);
CREATE INDEX `idx_donations_status_date` ON `donations` (`status`, `submissionDate`);
CREATE INDEX `idx_transactions_user_status` ON `transactions` (`userId`, `status`);
CREATE INDEX `idx_users_membership_active` ON `users` (`membershipType`, `isActive`);

-- ============================================================================
-- CREATE VIEWS FOR COMMON QUERIES
-- ============================================================================

-- View for available books
CREATE VIEW `available_books` AS
SELECT 
    b.id,
    b.bookId,
    b.title,
    b.author,
    b.genre,
    b.condition,
    b.language,
    b.publishedYear,
    u.username as donatedByUser
FROM books b
LEFT JOIN users u ON b.donatedBy = u.id
WHERE b.availability = 'Available';

-- View for user donations summary
CREATE VIEW `user_donations_summary` AS
SELECT 
    u.id as userId,
    u.username,
    u.email,
    COUNT(d.id) as totalDonations,
    COUNT(CASE WHEN d.status = 'APPROVED' THEN 1 END) as approvedDonations,
    COUNT(CASE WHEN d.status = 'PENDING' THEN 1 END) as pendingDonations
FROM users u
LEFT JOIN donations d ON u.id = d.donorId
GROUP BY u.id, u.username, u.email;

-- View for current borrowings
CREATE VIEW `current_borrowings` AS
SELECT 
    t.id,
    t.transactionId,
    u.username,
    b.title as bookTitle,
    b.author as bookAuthor,
    t.borrowDate,
    t.dueDate,
    DATEDIFF(NOW(), t.dueDate) as daysOverdue,
    t.status
FROM transactions t
JOIN users u ON t.userId = u.id
JOIN books b ON t.bookId = b.id
WHERE t.type = 'BORROW' AND t.status IN ('ACTIVE', 'OVERDUE');

-- ============================================================================
-- STORED PROCEDURES
-- ============================================================================

DELIMITER $$

-- Procedure to calculate fine for overdue books
CREATE PROCEDURE `CalculateFine`(
    IN transactionId VARCHAR(50),
    IN finePerDay DECIMAL(10,2)
)
BEGIN
    DECLARE daysOverdue INT DEFAULT 0;
    DECLARE calculatedFine DECIMAL(10,2) DEFAULT 0.00;
    
    SELECT GREATEST(0, DATEDIFF(NOW(), dueDate)) 
    INTO daysOverdue
    FROM transactions 
    WHERE transactions.transactionId = transactionId;
    
    SET calculatedFine = daysOverdue * finePerDay;
    
    UPDATE transactions 
    SET fine = calculatedFine,
        status = CASE 
            WHEN daysOverdue > 0 THEN 'OVERDUE'
            ELSE status
        END
    WHERE transactions.transactionId = transactionId;
    
    SELECT daysOverdue, calculatedFine;
END$$

-- Procedure to get user statistics
CREATE PROCEDURE `GetUserStats`(IN userId INT)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM donations WHERE donorId = userId) as totalDonations,
        (SELECT COUNT(*) FROM donations WHERE donorId = userId AND status = 'APPROVED') as approvedDonations,
        (SELECT COUNT(*) FROM transactions WHERE transactions.userId = userId AND type = 'BORROW') as totalBorrowings,
        (SELECT COUNT(*) FROM transactions WHERE transactions.userId = userId AND status = 'ACTIVE') as currentBorrowings,
        (SELECT COALESCE(SUM(fine), 0) FROM transactions WHERE transactions.userId = userId) as totalFines;
END$$

DELIMITER ;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

DELIMITER $$

-- Trigger to automatically update book availability when borrowed
CREATE TRIGGER `update_book_availability_on_borrow`
AFTER INSERT ON `transactions`
FOR EACH ROW
BEGIN
    IF NEW.type = 'BORROW' AND NEW.status = 'ACTIVE' THEN
        UPDATE books SET availability = 'Borrowed' WHERE id = NEW.bookId;
    END IF;
END$$

-- Trigger to automatically update book availability when returned
CREATE TRIGGER `update_book_availability_on_return`
AFTER UPDATE ON `transactions`
FOR EACH ROW
BEGIN
    IF NEW.type = 'RETURN' AND NEW.status = 'COMPLETED' THEN
        UPDATE books SET availability = 'Available' WHERE id = NEW.bookId;
    END IF;
END$$

DELIMITER ;

-- ============================================================================
-- GRANTS AND PERMISSIONS
-- ============================================================================

-- Create application user (optional, for security)
-- CREATE USER 'library_app'@'localhost' IDENTIFIED BY 'Ssipmt@2025DODB';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON library_management.* TO 'library_app'@'localhost';
-- FLUSH PRIVILEGES;

-- ============================================================================
-- FINAL SETUP INFORMATION
-- ============================================================================

SELECT 'Database setup completed successfully!' as Status;
SELECT 
    'Users created: 4' as Users,
    'Sample books: 4' as Books,
    'Sample donations: 3' as Donations,
    'Views created: 3' as Views,
    'Procedures created: 2' as Procedures,
    'Triggers created: 2' as Triggers;

-- Show all tables
SHOW TABLES;

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
