# Vista Veranda Hotel - Database Setup Guide

## Database Overview

This database is designed to manage all aspects of the Vista Veranda Hotel operations including:
- Room reservations and bookings
- Customer information management
- Dining restaurant reservations
- Facility bookings (spa, pool, gym, etc.)
- Special offers and promotions
- Contact form messages
- Payment transactions
- Newsletter subscriptions
- Customer reviews and ratings

## Database Structure

### Main Tables

1. **customers** - Guest and customer information
2. **room_types** - Different room categories (Deluxe, Suite, Family, etc.)
3. **rooms** - Individual room inventory
4. **reservations** - Room booking records
5. **dining_restaurants** - Restaurant information
6. **dining_reservations** - Restaurant table bookings
7. **facilities** - Hotel facilities (pool, spa, gym, etc.)
8. **facility_bookings** - Facility reservation records
9. **special_offers** - Promotional offers and packages
10. **contact_messages** - Customer inquiries
11. **payments** - Payment transaction records
12. **newsletter_subscribers** - Email subscription list
13. **reviews** - Customer reviews and ratings

## Installation Instructions

### Option 1: Using phpMyAdmin

1. **Open phpMyAdmin**
   - Navigate to `http://localhost/phpmyadmin/` in your browser
   - Login with your MySQL credentials (default XAMPP: username: `root`, password: empty)

2. **Import the Database**
   - Click on "New" in the left sidebar to create the database (or the SQL file will create it)
   - Click on "Import" tab at the top
   - Click "Choose File" and select `vista_veranda.sql`
   - Click "Go" at the bottom to execute

3. **Verify Installation**
   - You should see "vista_veranda" database in the left sidebar
   - Click on it to see all 13 tables created

### Option 2: Using MySQL Command Line

1. **Open Command Prompt/Terminal**
   ```bash
   mysql -u root -p
   ```

2. **Execute the SQL file**
   ```sql
   source D:\KDU\hotel project\vista veranda\database\vista_veranda.sql
   ```
   
   Or run directly:
   ```bash
   mysql -u root -p < "D:\KDU\hotel project\vista veranda\database\vista_veranda.sql"
   ```

3. **Verify Installation**
   ```sql
   USE vista_veranda;
   SHOW TABLES;
   ```

### Option 3: Using XAMPP/WAMP Control Panel

1. Start MySQL service from XAMPP/WAMP control panel
2. Open phpMyAdmin as described in Option 1
3. Follow the import steps

## Database Configuration

Update the database connection settings in `db_config.php`:

```php
define('DB_HOST', 'localhost');      // Your database host
define('DB_NAME', 'vista_veranda');  // Database name
define('DB_USER', 'root');           // Your MySQL username
define('DB_PASS', '');               // Your MySQL password
```

## Sample Data

The database comes pre-populated with:
- 5 room types (Standard, Deluxe, Suite, Family, Presidential)
- 20 sample rooms across 7 floors
- 6 dining restaurants
- 6 facility types
- 5 special offers
- 3 sample customers

## Database Features

### Views
- **available_rooms** - Shows all currently available rooms
- **current_reservations** - Active and upcoming reservations
- **revenue_summary** - Monthly revenue statistics

### Stored Procedures
- **check_room_availability** - Check room availability for specific dates
- **calculate_reservation_price** - Calculate total price for a booking

### Triggers
- Automatic room status updates when reservations are confirmed
- Automatic room status reset when guests check out

## Usage Examples

### Check Room Availability
```sql
CALL check_room_availability('2026-02-01', '2026-02-05', 1);
```

### Get Available Rooms
```sql
SELECT * FROM available_rooms;
```

### Get Current Reservations
```sql
SELECT * FROM current_reservations;
```

### Get Revenue Summary
```sql
SELECT * FROM revenue_summary;
```

## PHP Connection Examples

### Using PDO (Recommended)
```php
require_once 'database/db_config.php';

$pdo = getDBConnection();
$stmt = $pdo->prepare("SELECT * FROM customers WHERE email = ?");
$stmt->execute([$email]);
$customer = $stmt->fetch();
```

### Using MySQLi
```php
require_once 'database/db_config.php';

$conn = getMySQLiConnection();
$email = $conn->real_escape_string($email);
$result = $conn->query("SELECT * FROM customers WHERE email = '$email'");
$customer = $result->fetch_assoc();
```

## Security Recommendations

1. **Change Default Password** - Set a strong password for your MySQL root user
2. **Create Dedicated User** - Create a specific database user for this application:
   ```sql
   CREATE USER 'vista_user'@'localhost' IDENTIFIED BY 'strong_password_here';
   GRANT ALL PRIVILEGES ON vista_veranda.* TO 'vista_user'@'localhost';
   FLUSH PRIVILEGES;
   ```
3. **Update db_config.php** - Use the new credentials in your config file
4. **Protect Config File** - Ensure db_config.php is not publicly accessible
5. **Use Prepared Statements** - Always use parameterized queries to prevent SQL injection

## Backup Instructions

### Manual Backup
```bash
mysqldump -u root -p vista_veranda > backup_vista_veranda_YYYY-MM-DD.sql
```

### Restore from Backup
```bash
mysql -u root -p vista_veranda < backup_vista_veranda_YYYY-MM-DD.sql
```

## Troubleshooting

### Connection Failed
- Verify MySQL service is running
- Check credentials in db_config.php
- Ensure database exists: `SHOW DATABASES;`

### Import Errors
- Check MySQL version compatibility
- Ensure sufficient privileges
- Verify file path is correct

### Table Not Found
- Confirm database is selected: `USE vista_veranda;`
- Check if tables were created: `SHOW TABLES;`

## Support

For issues or questions:
- Check error logs in phpMyAdmin
- Review MySQL error log files
- Verify PHP version supports PDO/MySQLi

## Database Maintenance

### Regular Tasks
- Backup database weekly
- Archive old reservations monthly
- Clean up cancelled bookings
- Monitor database size
- Optimize tables quarterly:
  ```sql
  OPTIMIZE TABLE reservations, customers, payments;
  ```

---

**Created:** January 15, 2026  
**Version:** 1.0  
**Database:** MySQL 5.7+ / MariaDB 10.2+  
**PHP:** 7.4+
