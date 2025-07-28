# 🚀 Remote Server Deployment Instructions

## Ready Package Created: `library-backend-final.zip` (26KB)

### Step 1: Upload to Remote Server
```bash
# Option A: Using SCP (if you have command line access)
scp library-backend-final.zip root@165.22.208.62:/var/www/

# Option B: Use SFTP client like WinSCP, FileZilla
# Upload library-backend-final.zip to /var/www/ directory
```

### Step 2: SSH to Remote Server & Deploy
```bash
# SSH to server
ssh root@165.22.208.62

# Navigate to web directory
cd /var/www/

# Create project directory
mkdir -p library-backend
cd library-backend

# Extract files
unzip ../library-backend-final.zip

# Make deploy script executable
chmod +x production-deploy.sh

# Run deployment script
./production-deploy.sh
```

### Step 3: Verify Deployment
```bash
# Check if service is running
pm2 status

# Check logs
pm2 logs library-backend

# Test API endpoint
curl http://165.22.208.62:5010/api/test
```

---

## 📋 What's Included in Package:

✅ **Updated AuthController** - Fixed login with database users  
✅ **Production Environment** - NODE_ENV=production  
✅ **Database Config** - Points to 165.22.208.62 MySQL  
✅ **PM2 Setup** - Auto-restart & process management  
✅ **All Dependencies** - package.json with required modules  

---

## 🔐 Login Credentials (From Your Database):

| Username | Password | Role |
|----------|----------|------|
| simple   | test123  | employee |
| admin123 | (encrypted) | admin |
| test123  | (encrypted) | employee |
| user1    | (encrypted) | employee |

---

## 🌐 After Deployment URLs:

- **API Base:** `http://165.22.208.62:5010/api`
- **Login Endpoint:** `http://165.22.208.62:5010/api/auth/login`
- **Test Endpoint:** `http://165.22.208.62:5010/api/test`

---

## 🔧 Troubleshooting:

If deployment fails, check:
1. Node.js installed: `node --version`
2. npm installed: `npm --version`  
3. Port 5010 not blocked: `netstat -tulpn | grep 5010`
4. PM2 status: `pm2 status`

---

**Ready to deploy! 🚀**
