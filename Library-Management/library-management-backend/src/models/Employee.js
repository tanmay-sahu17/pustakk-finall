const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
const sequelize = require('../config/database');

const Employee = sequelize.define('Employee', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  employeeId: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true  // ✅ for login and identification using employeeId
  },
  firstName: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  lastName: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      len: [6, 255]
    }
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: false
  },
  address: {
    type: DataTypes.JSON, // Store address as JSON object
    allowNull: false
  },
  position: {
    type: DataTypes.ENUM('Librarian', 'Assistant Librarian', 'Library Manager', 'IT Support', 'Security', 'Cleaner', 'Other'),
    allowNull: false
  },
  department: {
    type: DataTypes.ENUM('Administration', 'Circulation', 'Reference', 'Technical Services', 'IT', 'Security', 'Maintenance'),
    allowNull: false
  },
  salary: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
    validate: {
      min: 0
    }
  },
  dateOfJoining: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  },
  dateOfBirth: {
    type: DataTypes.DATE,
    allowNull: false
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  emergencyContact: {
    type: DataTypes.JSON, // Store emergency contact as JSON object
    allowNull: false
  },
  profileImage: {
    type: DataTypes.STRING, // Path to the uploaded image file
    allowNull: true
  },
  permissions: {
    type: DataTypes.JSON, // Store permissions array as JSON
    allowNull: true,
    defaultValue: []
  },
  workingHours: {
    type: DataTypes.JSON, // Store working hours as JSON object
    allowNull: true,
    defaultValue: {
      startTime: "09:00",
      endTime: "17:00",
      workingDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
    }
  }
}, {
  timestamps: true,
  hooks: {
    // 🔐 Hash password before saving
    beforeSave: async (employee) => {
      if (employee.changed('password')) {
        employee.password = await bcrypt.hash(employee.password, 12);
      }
    }
  }
});

// 🔐 Compare password for login
Employee.prototype.comparePassword = function (enteredPassword) {
  return bcrypt.compareSync(enteredPassword, this.password);
};

// 🔍 Get full name
Employee.prototype.getFullName = function() {
  return `${this.firstName} ${this.lastName}`;
};

// 📊 Get employee age
Employee.prototype.getAge = function() {
  const today = new Date();
  const birthDate = new Date(this.dateOfBirth);
  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDiff = today.getMonth() - birthDate.getMonth();
  
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  
  return age;
};

// 📈 Get years of service
Employee.prototype.getYearsOfService = function() {
  const today = new Date();
  const joinDate = new Date(this.dateOfJoining);
  let years = today.getFullYear() - joinDate.getFullYear();
  const monthDiff = today.getMonth() - joinDate.getMonth();
  
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < joinDate.getDate())) {
    years--;
  }
  
  return years;
};

module.exports = Employee;
