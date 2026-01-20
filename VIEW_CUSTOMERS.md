# View Customer Bookings

## Option 1: Using phpMyAdmin (Easiest)

1. **Open phpMyAdmin:**
   ```
   http://localhost/phpmyadmin/
   ```

2. **Login:**
   - Username: `root`
   - Password: (leave empty)

3. **Select Database:** Click on `vista_veranda` in left sidebar

4. **Run SQL Query:** Go to **SQL** tab and paste:

```sql
-- Get all customers with their bookings
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.phone,
    c.city,
    c.country,
    r.reservation_id,
    r.check_in_date,
    r.check_out_date,
    r.number_of_guests,
    r.total_price,
    r.reservation_status,
    r.payment_status,
    rm.room_number,
    rt.type_name AS room_type
FROM customers c
LEFT JOIN reservations r ON c.customer_id = r.customer_id
LEFT JOIN rooms rm ON r.room_id = rm.room_id
LEFT JOIN room_types rt ON rm.room_type_id = rt.room_type_id
ORDER BY c.customer_id, r.check_in_date DESC;
```

5. **Click "Go"** to see results

---

## Option 2: Using PHP Report Page

I've created a **customer_bookings.php** file in your project.

### To access it:

1. **Make sure Apache is running in XAMPP**
2. **Place the file in XAMPP htdocs or access via PHP server:**
   ```
   http://localhost/customer_bookings.php
   ```
   
   OR if using Python server at 8000:
   - You need Apache running for PHP files

---

## Option 3: Current Sample Data in Database

Your database currently has **3 sample customers**:

### Customer 1: John Doe
- Email: john.doe@email.com
- Phone: +1-555-0123
- Location: New York, USA
- Status: No bookings yet

### Customer 2: Jane Smith
- Email: jane.smith@email.com
- Phone: +44-20-1234-5678
- Location: London, UK
- Status: No bookings yet

### Customer 3: Michael Johnson
- Email: michael.j@email.com
- Phone: +61-2-9876-5432
- Location: Sydney, Australia
- Status: No bookings yet

---

## How to Add New Customers/Bookings

### Option A: Using phpMyAdmin UI
1. Go to phpMyAdmin
2. Click on `customers` table
3. Click "Insert" tab
4. Fill in customer details and click "Go"

### Option B: Using SQL Insert
```sql
-- Add a new customer
INSERT INTO customers (first_name, last_name, email, phone, address, city, country, postal_code)
VALUES ('Sarah', 'Williams', 'sarah.williams@email.com', '+1-555-9876', '789 Ocean Ave', 'Miami', 'USA', '33101');

-- Add a reservation for this customer
INSERT INTO reservations (customer_id, room_id, check_in_date, check_out_date, number_of_guests, number_of_adults, number_of_children, total_price, reservation_status, payment_status)
VALUES (4, 1, '2026-02-01', '2026-02-05', 2, 2, 0, 600.00, 'confirmed', 'paid');
```

---

## Database Tables for Customer Info

### customers table:
- customer_id
- first_name
- last_name
- email
- phone
- address
- city
- country
- postal_code
- date_registered

### reservations table:
- reservation_id
- customer_id (links to customers)
- room_id
- check_in_date
- check_out_date
- number_of_guests
- number_of_adults
- number_of_children
- total_price
- reservation_status
- payment_status
- booking_date

---

## Quick SQL Queries

### See all customers:
```sql
SELECT * FROM customers;
```

### See all reservations:
```sql
SELECT * FROM reservations;
```

### See confirmed bookings only:
```sql
SELECT * FROM reservations WHERE reservation_status = 'confirmed';
```

### See paid reservations:
```sql
SELECT * FROM reservations WHERE payment_status = 'paid';
```

### Total revenue by customer:
```sql
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(r.reservation_id) AS booking_count,
    SUM(r.total_price) AS total_spent
FROM customers c
LEFT JOIN reservations r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;
```

---

**Next Step:** Start taking bookings from your website forms and they'll automatically appear in these tables!

Created: January 15, 2026
