const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Transaction = sequelize.define('Transaction', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  transactionId: {
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
  book: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'Books',
      key: 'id'
    }
  },
  transactionType: {
    type: DataTypes.ENUM('BORROW', 'RETURN', 'RESERVE', 'RENEW'),
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('ACTIVE', 'COMPLETED', 'OVERDUE', 'CANCELLED'),
    defaultValue: 'ACTIVE'
  },
  borrowDate: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  },
  dueDate: {
    type: DataTypes.DATE,
    allowNull: false
  },
  returnDate: {
    type: DataTypes.DATE,
    allowNull: true
  },
  renewalCount: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
    validate: {
      max: 3 // Maximum 3 renewals allowed
    }
  },
  fine: {
    type: DataTypes.JSON, // Store fine details as JSON object
    allowNull: true,
    defaultValue: {
      amount: 0,
      isPaid: false,
      paidDate: null
    }
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  issuedBy: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: 'Employees',
      key: 'id'
    }
  },
  returnedTo: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: 'Employees',
      key: 'id'
    }
  }
}, {
  timestamps: true,
  indexes: [
    {
      fields: ['user', 'status']
    },
    {
      fields: ['book', 'status']
    },
    {
      fields: ['dueDate', 'status']
    },
    {
      unique: true,
      fields: ['transactionId']
    }
  ]
});

// Calculate days overdue
Transaction.prototype.getDaysOverdue = function() {
  if (this.status === 'COMPLETED' || !this.dueDate) return 0;
  
  const today = new Date();
  const dueDate = new Date(this.dueDate);
  
  if (today > dueDate) {
    const diffTime = Math.abs(today - dueDate);
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  }
  
  return 0;
};

// Calculate fine amount based on days overdue
Transaction.prototype.calculateFine = function(finePerDay = 5) {
  const daysOverdue = this.getDaysOverdue();
  return daysOverdue > 0 ? daysOverdue * finePerDay : 0;
};

module.exports = Transaction;
