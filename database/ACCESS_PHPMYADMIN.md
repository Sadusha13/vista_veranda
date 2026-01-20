# How to Access phpMyAdmin for Vista Veranda

## Quick Steps to Get phpMyAdmin Running

### Step 1: Start Services in XAMPP Control Panel

1. **Open XAMPP Control Panel:**
   - Find it in Windows Start Menu or double-click `C:\xampp\xampp-control.exe`

2. **Click "Start" buttons for:**
   - ✅ **Apache** (must be running for phpMyAdmin)
   - ✅ **MySQL** (already started from previous setup)

3. **Wait for both to show "Running" status** (green indicator)

---

### Step 2: Open phpMyAdmin

Once both Apache and MySQL are running:

**Option A: Direct URL**
```
http://localhost/phpmyadmin/
```

**Option B: Through XAMPP Dashboard**
```
http://localhost/
```
Then click "phpMyAdmin" button

---

## If phpMyAdmin Still Won't Open

### Quick Fix Checklist:

1. **Is Apache Running?**
   - Check XAMPP Control Panel
   - Apache should show "Running" in green
   - If not, click "Start" button

2. **Is MySQL Running?**
   - Check XAMPP Control Panel
   - MySQL should show "Running" in green

3. **Try Alternative URLs:**
   - `http://127.0.0.1/phpmyadmin/`
   - `http://localhost:80/phpmyadmin/`
   - `http://localhost/dashboard/`

4. **Check Port 80 is Free:**
   ```powershell
   netstat -ano | findstr :80
   ```
   If something is using port 80:
   - Close other applications (Skype, other web servers)
   - Or change XAMPP Apache port

5. **Restart Services:**
   - In XAMPP: Click "Stop" for both Apache and MySQL
   - Wait 3 seconds
   - Click "Start" again

---

## Automatic Startup Batch File

I've created **START_SERVER.bat** in your project folder.

**To use it:**
1. Go to: `D:\KDU\hotel project\vista veranda\`
2. Double-click **START_SERVER.bat**
3. Both Apache and MySQL will start automatically
4. Wait for "Services Started Successfully!" message
5. Open http://localhost/phpmyadmin/

---

## Access phpMyAdmin Once It Opens

**Login Details:**
- **Server:** localhost
- **Username:** root
- **Password:** (leave empty)

---

## Your Database Info

- **Database Name:** vista_veranda
- **Tables:** 16 tables
- **Sample Data:** 20 rooms, 6 restaurants, 6 facilities

---

## If Apache Won't Start

### Check Error Logs:
1. In XAMPP Control Panel, click "Logs" next to Apache
2. Select "Apache Error Log"
3. Look at the bottom for error messages

### Common Issues:
- **Port 80 already in use:**
  - Change Apache port in `C:\xampp\apache\conf\httpd.conf`
  - Look for: `Listen 80` and change to `Listen 8080`

- **Missing files:**
  - Reinstall XAMPP
  - Choose "Apache" and "MySQL" during installation

---

## Project Structure Access

Once everything is running:
- **Website:** http://localhost:8000/ (your Vista Veranda site)
- **Database:** http://localhost/phpmyadmin/ (manage data)
- **Files:** D:\KDU\hotel project\vista veranda\

---

**Note:** Both Apache (for phpMyAdmin) and MySQL (for database) must be running for everything to work together.

Created: January 15, 2026
