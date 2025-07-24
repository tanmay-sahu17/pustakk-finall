const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Donation = sequelize.define('Donation', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  donationId: {
    type: DataTypes.STRING(50),
    allowNull: false,
    unique: true
  },
  donorId: {
    type: DataTypes.INTEGER,
    allowNull: true // Make it nullable - no foreign key constraint for now
  },
  // Book details embedded in donation
  bookTitle: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  bookAuthor: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  bookIsbn: {
    type: DataTypes.STRING(20),
    allowNull: true
  },
  bookGenre: {
    type: DataTypes.STRING(100),
    allowNull: false
  },
  bookCondition: {
    type: DataTypes.ENUM('New', 'Like New', 'Good', 'Fair', 'Poor'),
    allowNull: false
  },
  bookDescription: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  bookImages: {
    type: DataTypes.JSON, // Array of image paths
    allowNull: true,
    defaultValue: []
  },
  bookPublishedYear: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  bookLanguage: {
    type: DataTypes.STRING(50),
    defaultValue: 'Hindi'
  },
  status: {
    type: DataTypes.ENUM('PENDING', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'ADDED_TO_LIBRARY'),
    defaultValue: 'PENDING'
  },
  submissionDate: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  reviewDate: {
    type: DataTypes.DATE,
    allowNull: true
  },
  reviewedById: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: 'Admins',
      key: 'id'
    }
  },
  reviewNotes: {
    type: DataTypes.TEXT,
    defaultValue: ''
  },
  rejectionReason: {
    type: DataTypes.TEXT,
    defaultValue: ''
  },
  estimatedValue: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0
  },
  // Pickup details as JSON
  pickupDetails: {
    type: DataTypes.JSON,
    allowNull: true,
    defaultValue: {
      isPickupRequired: false,
      pickupAddress: {
        street: '',
        city: '',
        state: '',
        zipCode: ''
      },
      pickupDate: null,
      pickupStatus: 'PENDING'
    }
  },
  // Donor preferences as JSON
  donorPreferences: {
    type: DataTypes.JSON,
    allowNull: true,
    defaultValue: {
      anonymousDonation: false,
      certificateRequired: true,
      taxReceiptRequired: false
    }
  },
  libraryBookId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: 'books',
      key: 'id'
    }
  }
}, {
  tableName: 'donations',
  timestamps: true,
  createdAt: 'createdAt',
  updatedAt: 'updatedAt',
  hooks: {
    beforeCreate: (donation) => {
      if (!donation.donationId) {
        donation.donationId = 'DON-' + Date.now() + '-' + Math.random().toString(36).substr(2, 6).toUpperCase();
      }
    }
  }
});

// Virtual fields (getters)
Donation.prototype.getDaysSinceSubmission = function() {
  const today = new Date();
  const submissionDate = new Date(this.submissionDate);
  const diffTime = Math.abs(today - submissionDate);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
};

Donation.prototype.getIsPendingTooLong = function() {
  return this.getDaysSinceSubmission() > 7 && this.status === 'PENDING';
};

Donation.prototype.getStatusHindi = function() {
  const statusMap = {
    'PENDING': 'लंबित',
    'UNDER_REVIEW': 'समीक्षा में',
    'APPROVED': 'स्वीकृत',
    'REJECTED': 'अस्वीकृत',
    'ADDED_TO_LIBRARY': 'पुस्तकालय में जोड़ा गया'
  };
  return statusMap[this.status] || this.status;
};

module.exports = Donation;
