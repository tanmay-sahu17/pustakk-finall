#!/bin/bash

# Deployment script for production server
echo "🚀 Starting deployment to production server..."

# Set environment to production
export NODE_ENV=production

# Install dependencies
echo "📦 Installing dependencies..."
npm install --production

# Create uploads directory if it doesn't exist
mkdir -p uploads/books
mkdir -p uploads/certificates

# Set proper permissions
chmod -R 755 uploads/

# Start the application with PM2 (process manager)
echo "▶️  Starting application..."

# Install PM2 globally if not installed
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# Stop existing instance if running
pm2 stop library-backend 2>/dev/null || true
pm2 delete library-backend 2>/dev/null || true

# Start new instance
pm2 start src/server.js --name "library-backend" --env production

# Save PM2 configuration
pm2 save

# Setup PM2 to start on system reboot
pm2 startup

echo "✅ Deployment completed!"
echo "🌐 Server should be running on http://165.22.208.6:5010"
echo "📊 Monitor logs with: pm2 logs library-backend"
echo "🔄 Restart with: pm2 restart library-backend"
