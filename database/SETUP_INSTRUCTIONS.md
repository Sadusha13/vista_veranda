## Vista Veranda Database - Quick Setup Instructions

### ⚠️ MySQL Server Not Running

The database files have been created, but MySQL needs to be started first.

---

## 🚀 Quick Start (3 Steps)

### Step 1: Start MySQL Server

#### Option A: Using XAMPP Control Panel
1. Open **XAMPP Control Panel** (search for it in Windows Start menu)
2. Click **Start** next to **MySQL**
3. Wait for the status to turn green

#### Option B: Using Command
```powershell
C:\xampp\mysql_start.bat
```

---

### Step 2: Import Database

#### Option A: Using phpMyAdmin (Easiest - Recommended)
1. Open your browser and go to: **http://localhost/phpmyadmin/**
2. Click **"Import"** tab at the top
3. Click **"Choose File"** button
4. Navigate to: `D:\KDU\hotel project\vista veranda\database\vista_veranda.sql`
5. Click **"Go"** button at the bottom
6. ✅ You should see: "Import has been successfully finished"

#### Option B: Using Command Line
```powershell
C:\xampp\mysql\bin\mysql.exe -u root -e "SOURCE 'D:\KDU\hotel project\vista veranda\database\vista_veranda.sql'"
```

---

### Step 3: Verify Installation

1. In phpMyAdmin, you should see **"vista_veranda"** database in the left sidebar
2. Click on it to see 13 tables:
   - ✅ customers
   - ✅ room_types
   - ✅ rooms
   - ✅ reservations
   - ✅ dining_restaurants
   - ✅ dining_reservations
   - ✅ facilities
   - ✅ facility_bookings
   - ✅ special_offers
   - ✅ contact_messages
   - ✅ payments
   - ✅ newsletter_subscribers
   - ✅ reviews

---

## 📁 Database Files Created

### 1. `vista_veranda.sql` (Main database file)
   - Complete database schema with 13 tables
   - Sample data (20 rooms, 6 restaurants, 6 facilities)
   - Views, stored procedures, and triggers

### 2. `db_config.php` (PHP connection file)
   - Use this in your PHP files to connect to database
   - Already configured for localhost with default XAMPP settings

### 3. `README.md` (Complete documentation)
   - Detailed setup instructions
   - Usage examples
   - Security recommendations

---

## 🔧 Troubleshooting

### MySQL Won't Start
- **Error: Port 3306 already in use**
  - Another MySQL instance is running
  - Stop it or change port in XAMPP config

- **Error: mysql.exe not found**
  - XAMPP not installed or installed in different location
  - Check installation path

### Can't Access phpMyAdmin
- Make sure Apache is also started in XAMPP
- Try: http://127.0.0.1/phpmyadmin/

### Import Fails
- File size too large: Increase `upload_max_filesize` in php.ini
- Timeout: Increase `max_execution_time` in php.ini

---

## 💡 Next Steps After Import

1. **Test Connection**
   - Create a test PHP file to verify database connection
   
2. **Update Credentials** (if needed)
   - Edit `database/db_config.php` with your MySQL password

3. **Integrate with Forms**
   - Connect your reservation forms to the database
   - Link contact form to `contact_messages` table
   - Implement booking system using `reservations` table

---

## 📝 Sample Data Included

The database comes with ready-to-use sample data:
- **5 Room Types**: Standard ($100), Deluxe ($150), Suite ($300), Family ($200), Presidential ($500)
- **20 Rooms**: Across 7 floors (101-702)
- **6 Restaurants**: Ocean Grill, Sushi Bay, Spice Garden, Poolside Cafe, Sky Lounge, Orchid Lounge
- **6 Facilities**: Infinity Pool, Ayu Spa, Fitness Center, Game Arcade, Tennis Court, Kids Club
- **5 Special Offers**: Early Bird, Weekend Getaway, Spa Package, Honeymoon, Family Fun
- **3 Sample Customers**: For testing bookings

---

## 🎯 Quick Test Query

After import, try this in phpMyAdmin SQL tab:
```sql
USE vista_veranda;
SELECT * FROM available_rooms;
```

You should see all 20 available rooms!

---

**Need Help?** Check the full [README.md](README.md) for detailed documentation.
