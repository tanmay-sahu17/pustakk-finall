const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

// Import referenced models
const Admin = require('./Admin');
const User = require('./User');

const Book = sequelize.define('Book', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    title: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    author: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    genre: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    description: {
        type: DataTypes.TEXT,
        allowNull: true,
    },
    publishedYear: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    isbn: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
    },
    coverImage: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    pdfUrl: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    hasEbook: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
    },
    availableCopies: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 1,
    },
    totalCopies: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 1,
    },
    status: {
        type: DataTypes.ENUM('pending', 'approved', 'rejected'),
        defaultValue: 'pending'
    },
    approvedAt: {
        type: DataTypes.DATE,
        allowNull: true,
    },
    approvedBy: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: Admin,
            key: 'id'
        }
    },
    donatedBy: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: User,
            key: 'id'
        }
    },
    borrowedBy: {
        type: DataTypes.JSON,
        allowNull: true,
        defaultValue: []
    },
}, {
    timestamps: true,
    createdAt: 'createdAt',
    updatedAt: 'updatedAt',
    freezeTableName: true // Optional: disables plural table names
});

// Virtual methods
Book.prototype.addBorrower = function(userId, borrowDate = new Date()) {
    const borrowedBy = this.borrowedBy || [];
    borrowedBy.push({
        user: userId,
        borrowDate: borrowDate,
        returnDate: null
    });
    this.borrowedBy = borrowedBy;
    return this.save();
};

Book.prototype.returnBook = function(userId, returnDate = new Date()) {
    const borrowedBy = this.borrowedBy || [];
    const borrowRecord = borrowedBy.find(record => 
        record.user === userId && !record.returnDate
    );
    if (borrowRecord) {
        borrowRecord.returnDate = returnDate;
        this.borrowedBy = borrowedBy;
        return this.save();
    }
    return false;
};

Book.prototype.getCurrentBorrowers = function() {
    const borrowedBy = this.borrowedBy || [];
    return borrowedBy.filter(record => !record.returnDate);
};

module.exports = Book;
