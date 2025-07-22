const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Certificate = sequelize.define('Certificate', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  certificateId: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  user: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'Users',
      key: 'id'
    }
  },
  certificateType: {
    type: DataTypes.ENUM('DONATION', 'READING_ACHIEVEMENT', 'MEMBERSHIP', 'VOLUNTEER', 'APPRECIATION'),
    allowNull: false
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  achievementDetails: {
    type: DataTypes.JSON, // Store achievement details as JSON object
    allowNull: true,
    defaultValue: {
      booksRead: 0,
      booksDonated: 0,
      volunteerHours: 0,
      membershipDuration: 0
    }
  },
  issuedBy: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'Admins',
      key: 'id'
    }
  },
  issuedDate: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  validUntil: {
    type: DataTypes.DATE,
    allowNull: true // Some certificates might not expire
  },
  status: {
    type: DataTypes.ENUM('ACTIVE', 'EXPIRED', 'REVOKED'),
    defaultValue: 'ACTIVE'
  },
  template: {
    type: DataTypes.JSON, // Store template settings as JSON object
    allowNull: true,
    defaultValue: {
      templateName: 'default',
      backgroundColor: '#ffffff',
      textColor: '#000000',
      borderStyle: 'classic'
    }
  },
  verificationCode: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  downloadCount: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  pdfPath: {
    type: DataTypes.STRING,
    allowNull: true // Path to generated PDF file
  }
}, {
  timestamps: true,
  hooks: {
    // Generate verification code before saving
    beforeCreate: (certificate) => {
      if (!certificate.verificationCode) {
        certificate.verificationCode = 'CERT-' + Date.now() + '-' + Math.random().toString(36).substr(2, 9).toUpperCase();
      }
    }
  },
  indexes: [
    {
      fields: ['user', 'certificateType']
    },
    {
      unique: true,
      fields: ['verificationCode']
    },
    {
      unique: true,
      fields: ['certificateId']
    },
    {
      fields: ['issuedDate']
    }
  ]
});

// Check if certificate is valid
Certificate.prototype.getIsValid = function() {
  if (this.status !== 'ACTIVE') return false;
  if (!this.validUntil) return true; // No expiration date
  return new Date() <= this.validUntil;
};

// Get certificate age in days
Certificate.prototype.getAgeInDays = function() {
  const today = new Date();
  const issueDate = new Date(this.issuedDate);
  const diffTime = Math.abs(today - issueDate);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
};

module.exports = Certificate;
