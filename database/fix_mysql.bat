@echo off
echo ========================================
echo MySQL XAMPP Startup Fix Script
echo ========================================
echo.

echo Step 1: Stopping any MySQL services...
net stop MySQL 2>nul
taskkill /F /IM mysqld.exe 2>nul
timeout /t 2 >nul

echo Step 2: Checking MySQL data directory...
if not exist "C:\xampp\mysql\data" (
    echo ERROR: MySQL data directory not found!
    echo Please reinstall XAMPP.
    pause
    exit /b 1
)

echo Step 3: Checking for corrupted files...
if exist "C:\xampp\mysql\data\ibdata1" (
    echo MySQL data files found.
) else (
    echo WARNING: MySQL data files missing!
)

echo Step 4: Attempting to start MySQL...
echo.
cd /d C:\xampp\mysql\bin
echo Starting MySQL daemon...
mysqld --console

pause
