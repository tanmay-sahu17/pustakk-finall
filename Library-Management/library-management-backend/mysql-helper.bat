@echo off
echo =================================================
echo MySQL Connection Helper for Library Management
echo =================================================
echo.
echo This script will help you connect to MySQL.
echo.
echo Step 1: Stop MySQL service
net stop mysql80
echo.
echo Step 2: Start MySQL in safe mode (skip grant tables)
echo Please run this command in a separate admin command prompt:
echo mysqld --skip-grant-tables --skip-networking
echo.
echo Step 3: In another command prompt, run:
echo mysql -u root
echo.
echo Step 4: Reset password with these SQL commands:
echo FLUSH PRIVILEGES;
echo ALTER USER 'root'@'localhost' IDENTIFIED BY '';
echo FLUSH PRIVILEGES;
echo EXIT;
echo.
echo Step 5: Stop mysqld and restart MySQL service
echo net stop mysql80
echo net start mysql80
echo.
echo Alternative: Try connecting with these common passwords:
echo - (empty password)
echo - root
echo - password
echo - 123456
echo - admin
echo.
echo =================================================
pause
