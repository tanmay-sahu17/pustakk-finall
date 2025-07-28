@echo off
echo 🚀 Remote Server Deployment Script
echo ===================================

echo Step 1: Zip the application for upload
powershell -Command "Compress-Archive -Path 'src\*', 'package.json', '.env', 'deploy.sh', 'ecosystem.config.json' -DestinationPath 'library-backend-deploy.zip' -Force"

echo Step 2: Upload to remote server (Manual step)
echo Please upload 'library-backend-deploy.zip' to your remote server at 165.22.208.62

echo Step 3: SSH Commands to run on remote server:
echo ssh root@165.22.208.62
echo cd /var/www/
echo unzip library-backend-deploy.zip -d library-backend/
echo cd library-backend/
echo npm install --production
echo pm2 stop library-backend 2^>^&1 ^|^| true
echo pm2 start src/server.js --name "library-backend" --env production
echo pm2 save
echo pm2 startup

echo ✅ Deployment package created: library-backend-deploy.zip
pause
