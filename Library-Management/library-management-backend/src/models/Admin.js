const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
const sequelize = require('../config/database');

const Admin = sequelize.define('Admin', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  adminId: {
    type: DataTypes.STRING(50),
    allowNull: false,
    unique: true
  },
  username: {
    type: DataTypes.STRING(100),
    allowNull: false,
    unique: true
  },
  password: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  email: {
    type: DataTypes.STRING(255),
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  firstName: {
    type: DataTypes.STRING(100),
    allowNull: false
  },
  lastName: {
    type: DataTypes.STRING(100),
    allowNull: false
  },
  role: {
    type: DataTypes.ENUM('Super Admin', 'Admin', 'Moderator'),
    defaultValue: 'Admin'
  },
  permissions: {
    type: DataTypes.TEXT, // Store permissions array as JSON, using TEXT for MySQL compatibility
    allowNull: true,
    defaultValue: '[]',
    get() {
      const value = this.getDataValue('permissions');
      try {
        return value ? JSON.parse(value) : [];
      } catch (e) {
        return [];
      }
    },
    set(value) {
      this.setDataValue('permissions', JSON.stringify(value || []));
    }
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  lastLogin: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  timestamps: true,
  hooks: {
    // Hash password before saving
    beforeSave: async (admin) => {
      if (admin.changed('password')) {
        admin.password = await bcrypt.hash(admin.password, 12);
      }
    }
  }
});

// Compare password for login
Admin.prototype.comparePassword = function (enteredPassword) {
  return bcrypt.compareSync(enteredPassword, this.password);
};

// Get full name
Admin.prototype.getFullName = function() {
  return `${this.firstName} ${this.lastName}`;
};

module.exports = Admin;
