@echo off
title Vista Veranda - Start Services
echo ========================================
echo Starting XAMPP Services
echo ========================================
echo.

REM Start Apache
echo [1/2] Starting Apache...
C:\xampp\apache_start.bat

REM Start MySQL (if not already running)
echo [2/2] Starting MySQL...
C:\xampp\mysql_start.bat

echo.
echo ========================================
echo Services Started Successfully!
echo ========================================
echo.
echo Access your project:
echo - Website: http://localhost:8000/
echo - phpMyAdmin: http://localhost/phpmyadmin/
echo.
pause
