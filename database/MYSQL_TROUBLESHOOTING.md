# MySQL XAMPP Troubleshooting Guide

## Error: "MySQL shutdown unexpectedly"

This error typically occurs due to port conflicts, corrupted files, or missing dependencies.

---

## 🔧 Solution 1: Change MySQL Port (Quickest Fix)

If another program is using port 3306:

1. **In XAMPP Control Panel:**
   - Click **"Config"** button next to MySQL
   - Select **"my.ini"**

2. **Find and change the port:**
   ```ini
   # Find this line:
   port=3306
   
   # Change to:
   port=3307
   ```

3. **Save and close the file**

4. **In XAMPP Control Panel:**
   - Click **"Config"** button again
   - Select **"phpMyAdmin (config.inc.php)"**

5. **Update phpMyAdmin port:**
   ```php
   # Find this line:
   $cfg['Servers'][$i]['port'] = '3306';
   
   # Change to:
   $cfg['Servers'][$i]['port'] = '3307';
   ```

6. **Save, then try starting MySQL again**

---

## 🔧 Solution 2: Reset MySQL Data (If corrupted)

⚠️ **WARNING: This will delete all existing databases!**

1. **Stop MySQL** in XAMPP Control Panel

2. **Backup important data:**
   - Go to `C:\xampp\mysql\data\`
   - Copy the entire `data` folder to a safe location

3. **Delete problematic files:**
   - In `C:\xampp\mysql\data\`, delete these files:
     - `ibdata1`
     - `ib_logfile0`
     - `ib_logfile1`
     - All files in `mysql` folder (keep the folder itself)

4. **Restore default MySQL data:**
   - Go to `C:\xampp\mysql\backup\`
   - Copy all contents to `C:\xampp\mysql\data\`

5. **Try starting MySQL again**

---

## 🔧 Solution 3: Check for Conflicting Services

### Check Windows Services:

1. Press `Win + R`, type `services.msc`, press Enter

2. Look for these services and **STOP** them if running:
   - **MySQL** (any version)
   - **MySQL80** 
   - **MariaDB**

3. Try starting MySQL in XAMPP again

### Kill MySQL Processes:

Run in PowerShell:
```powershell
Get-Process mysqld -ErrorAction SilentlyContinue | Stop-Process -Force
```

---

## 🔧 Solution 4: Install Visual C++ Redistributables

MySQL requires Microsoft Visual C++ Runtime:

1. Download and install:
   - [Visual C++ 2015-2022 Redistributable (x64)](https://aka.ms/vs/17/release/vc_redist.x64.exe)
   - [Visual C++ 2015-2022 Redistributable (x86)](https://aka.ms/vs/17/release/vc_redist.x86.exe)

2. Restart computer

3. Try starting MySQL again

---

## 🔧 Solution 5: Check MySQL Error Log

1. In XAMPP Control Panel, click **"Logs"** button next to MySQL

2. Select **"MySQL Error Log"**

3. Look for specific error messages at the bottom

4. Common errors and fixes:

   **"Can't create/write to file"**
   - Run XAMPP as Administrator
   - Check folder permissions on `C:\xampp\mysql\data\`

   **"Table './mysql/user' doesn't exist"**
   - MySQL data is corrupted, use Solution 2

   **"Port is already in use"**
   - Use Solution 1 to change port

---

## 🔧 Solution 6: Reinstall MySQL in XAMPP

1. Download fresh XAMPP from [apachefriends.org](https://www.apachefriends.org/)

2. During installation, select only:
   - Apache
   - MySQL
   - phpMyAdmin

3. Install to a different location (e.g., `C:\xampp-new\`)

4. Start MySQL from new installation

---

## 🎯 Quick Diagnostic Steps

Run these commands in PowerShell to diagnose:

### 1. Check port usage:
```powershell
netstat -ano | findstr :3306
```

### 2. Check MySQL processes:
```powershell
Get-Process | Where-Object {$_.ProcessName -like "*mysql*"}
```

### 3. Test MySQL directly:
```powershell
C:\xampp\mysql\bin\mysqld --console
```
(Press Ctrl+C to stop)

---

## ✅ Alternative: Use phpMyAdmin Import Manually

If MySQL still won't start, you can:

1. **Fix MySQL using one of the solutions above**

2. **Once MySQL starts**, import database via phpMyAdmin:
   - Go to http://localhost/phpmyadmin/
   - Click "Import"
   - Choose `vista_veranda.sql`
   - Click "Go"

---

## 📞 Still Having Issues?

1. **Check XAMPP Error Logs:**
   - `C:\xampp\mysql\data\mysql_error.log`

2. **Post on XAMPP Forum:**
   - Include the error log content
   - Mention your Windows version

3. **Try Alternative:**
   - Use WAMP Server instead
   - Use Docker MySQL container
   - Use online MySQL hosting

---

## 🔄 After Fixing MySQL

Once MySQL starts successfully, run:

```powershell
C:\xampp\mysql\bin\mysql.exe -u root -e "SOURCE 'D:\KDU\hotel project\vista veranda\database\vista_veranda.sql'"
```

Or import via phpMyAdmin as mentioned above.

---

**Created:** January 15, 2026  
**For:** Vista Veranda Hotel Project
