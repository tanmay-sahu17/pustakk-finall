const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  userId: {
    type: DataTypes.STRING(20),
    allowNull: false,
    unique: true
  },
  username: {
    type: DataTypes.STRING(50),
    allowNull: false,
    unique: true
  },
  password: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  role: {
    type: DataTypes.ENUM('admin', 'employee'),
    allowNull: false,
    defaultValue: 'employee'
  },
  created_at: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'users', // Exact table name in database
  timestamps: false,  // Don't use Sequelize's automatic timestamps
  hooks: {
    // Hash password before saving (if needed)
    beforeSave: async (user) => {
      if (user.changed('password') && user.password.length < 20) {
        // Only hash if it's not already hashed
        user.password = await bcrypt.hash(user.password, 12);
      }
    }
  }
});

// Compare password for login
User.prototype.comparePassword = function (enteredPassword) {
  // For plain text passwords
  if (this.password === enteredPassword) {
    return true;
  }
  // For hashed passwords
  try {
    return bcrypt.compareSync(enteredPassword, this.password);
  } catch (error) {
    return false;
  }
};

// Get user by username or userId
User.findByLogin = async function(identifier) {
  return await User.findOne({
    where: {
      [sequelize.Sequelize.Op.or]: [
        { username: identifier },
        { userId: identifier }
      ]
    }
  });
};

module.exports = User;
