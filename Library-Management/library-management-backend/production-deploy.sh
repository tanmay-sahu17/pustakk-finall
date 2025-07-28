#!/bin/bash

# Production Deployment Script for 165.22.208.62
echo "🚀 Starting production deployment..."

# Set production environment
export NODE_ENV=production
export PORT=5010

# Create required directories
mkdir -p uploads/books
mkdir -p uploads/certificates
chmod -R 755 uploads/

# Install production dependencies
echo "📦 Installing dependencies..."
npm install --production --silent

# Install PM2 if not available
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# Stop existing instance
echo "🛑 Stopping existing instance..."
pm2 stop library-backend 2>/dev/null || true
pm2 delete library-backend 2>/dev/null || true

# Start new instance
echo "▶️ Starting application..."
pm2 start src/server.js --name "library-backend" --env production

# Save PM2 configuration
pm2 save

# Setup PM2 to start on system reboot (run once)
pm2 startup

# Show status
pm2 status

echo "✅ Deployment completed!"
echo "🌐 Server running on: http://165.22.208.62:5010"
echo "📊 View logs: pm2 logs library-backend"
echo "🔄 Restart: pm2 restart library-backend"
echo "⏹️ Stop: pm2 stop library-backend"
