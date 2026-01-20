-- Vista Veranda Hotel Database Schema
-- Created: January 15, 2026

-- Create Database
CREATE DATABASE IF NOT EXISTS vista_veranda;
USE vista_veranda;

-- ============================================
-- Table: customers
-- Stores customer/guest information
-- ============================================
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    date_registered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: room_types
-- Different types of rooms available
-- ============================================
CREATE TABLE IF NOT EXISTS room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    max_occupancy INT NOT NULL,
    amenities TEXT,
    image_url VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: rooms
-- Individual room inventory
-- ============================================
CREATE TABLE IF NOT EXISTS rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    floor_number INT,
    status ENUM('available', 'occupied', 'maintenance', 'reserved') DEFAULT 'available',
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE CASCADE,
    INDEX idx_status (status),
    INDEX idx_room_type (room_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: reservations
-- Room booking reservations
-- ============================================
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL,
    number_of_adults INT NOT NULL,
    number_of_children INT DEFAULT 0,
    total_price DECIMAL(10, 2) NOT NULL,
    special_requests TEXT,
    reservation_status ENUM('pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled') DEFAULT 'pending',
    payment_status ENUM('unpaid', 'partial', 'paid', 'refunded') DEFAULT 'unpaid',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    INDEX idx_check_in (check_in_date),
    INDEX idx_check_out (check_out_date),
    INDEX idx_status (reservation_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: dining_restaurants
-- Different dining venues
-- ============================================
CREATE TABLE IF NOT EXISTS dining_restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50),
    description TEXT,
    opening_time TIME,
    closing_time TIME,
    capacity INT,
    image_url VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: dining_reservations
-- Restaurant table reservations
-- ============================================
CREATE TABLE IF NOT EXISTS dining_reservations (
    dining_reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    number_of_guests INT NOT NULL,
    special_requests TEXT,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES dining_restaurants(restaurant_id) ON DELETE CASCADE,
    INDEX idx_reservation_date (reservation_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: facilities
-- Hotel facilities (spa, pool, gym, etc.)
-- ============================================
CREATE TABLE IF NOT EXISTS facilities (
    facility_id INT AUTO_INCREMENT PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL,
    facility_type VARCHAR(50),
    description TEXT,
    opening_time TIME,
    closing_time TIME,
    price_per_hour DECIMAL(10, 2),
    capacity INT,
    image_url VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: facility_bookings
-- Bookings for facilities
-- ============================================
CREATE TABLE IF NOT EXISTS facility_bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    facility_id INT NOT NULL,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    number_of_people INT,
    total_price DECIMAL(10, 2),
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending',
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id) ON DELETE CASCADE,
    INDEX idx_booking_date (booking_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: special_offers
-- Promotional offers and packages
-- ============================================
CREATE TABLE IF NOT EXISTS special_offers (
    offer_id INT AUTO_INCREMENT PRIMARY KEY,
    offer_title VARCHAR(100) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5, 2),
    discount_amount DECIMAL(10, 2),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    offer_type ENUM('room', 'dining', 'facility', 'package') NOT NULL,
    terms_conditions TEXT,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_dates (start_date, end_date),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: contact_messages
-- Customer inquiries and contact form submissions
-- ============================================
CREATE TABLE IF NOT EXISTS contact_messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    subject VARCHAR(200),
    message TEXT NOT NULL,
    status ENUM('new', 'read', 'replied', 'archived') DEFAULT 'new',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: payments
-- Payment transaction records
-- ============================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT,
    customer_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer', 'cash') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    transaction_id VARCHAR(100),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE SET NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    INDEX idx_status (payment_status),
    INDEX idx_transaction (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: newsletter_subscribers
-- Email newsletter subscriptions
-- ============================================
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
    subscriber_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    subscribe_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: reviews
-- Customer reviews and ratings
-- ============================================
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    reservation_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_title VARCHAR(100),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_approved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE SET NULL,
    INDEX idx_rating (rating),
    INDEX idx_approved (is_approved)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- SAMPLE DATA INSERTION
-- ============================================

-- Insert Room Types
INSERT INTO room_types (type_name, description, base_price, max_occupancy, amenities) VALUES
('Deluxe Room', 'Spacious room with ocean view, king-size bed, and modern amenities', 150.00, 2, 'WiFi, TV, Mini-bar, Ocean View, Air Conditioning'),
('Suite', 'Luxurious suite with separate living area and premium facilities', 300.00, 4, 'WiFi, TV, Mini-bar, Ocean View, Jacuzzi, Living Room, Balcony'),
('Family Room', 'Large room perfect for families with children', 200.00, 4, 'WiFi, TV, Mini-bar, Extra Beds, Air Conditioning'),
('Standard Room', 'Comfortable room with all essential amenities', 100.00, 2, 'WiFi, TV, Air Conditioning'),
('Presidential Suite', 'Ultimate luxury with panoramic views and exclusive services', 500.00, 6, 'WiFi, TV, Mini-bar, Ocean View, Jacuzzi, Living Room, Dining Area, Butler Service');

-- Insert Rooms (Sample 20 rooms)
INSERT INTO rooms (room_number, room_type_id, floor_number, status) VALUES
('101', 4, 1, 'available'), ('102', 4, 1, 'available'), ('103', 1, 1, 'available'),
('201', 1, 2, 'available'), ('202', 1, 2, 'available'), ('203', 3, 2, 'available'),
('301', 2, 3, 'available'), ('302', 2, 3, 'available'), ('303', 1, 3, 'available'),
('401', 1, 4, 'available'), ('402', 3, 4, 'available'), ('403', 4, 4, 'available'),
('501', 2, 5, 'available'), ('502', 1, 5, 'available'), ('503', 1, 5, 'available'),
('601', 5, 6, 'available'), ('602', 2, 6, 'available'), ('603', 2, 6, 'available'),
('701', 1, 7, 'available'), ('702', 3, 7, 'available');

-- Insert Dining Restaurants
INSERT INTO dining_restaurants (restaurant_name, cuisine_type, description, opening_time, closing_time, capacity) VALUES
('The Ocean Grill', 'International', 'Fine dining with ocean views and international cuisine', '11:00:00', '23:00:00', 80),
('Sushi Bay', 'Japanese', 'Authentic Japanese cuisine and fresh sushi', '12:00:00', '22:00:00', 50),
('Spice Garden', 'Asian Fusion', 'Blend of Asian flavors in contemporary setting', '18:00:00', '23:00:00', 60),
('Poolside Cafe', 'Casual Dining', 'Light meals and refreshments by the pool', '07:00:00', '20:00:00', 40),
('Sky Lounge', 'Bar & Lounge', 'Rooftop bar with cocktails and small plates', '17:00:00', '01:00:00', 100),
('Orchid Lounge', 'Cafe', 'Elegant tea lounge with pastries and beverages', '08:00:00', '22:00:00', 30);

-- Insert Facilities
INSERT INTO facilities (facility_name, facility_type, description, opening_time, closing_time, price_per_hour, capacity) VALUES
('Infinity Pool', 'Pool', 'Stunning infinity pool overlooking the ocean', '06:00:00', '22:00:00', 0.00, 100),
('Ayu Spa', 'Spa', 'Luxury spa with traditional and modern treatments', '09:00:00', '21:00:00', 50.00, 20),
('Fitness Center', 'Gym', 'State-of-the-art fitness equipment and personal trainers', '05:00:00', '23:00:00', 0.00, 30),
('Game Arcade', 'Entertainment', 'Fun games and entertainment for all ages', '10:00:00', '22:00:00', 10.00, 50),
('Tennis Court', 'Sports', 'Professional tennis courts available for booking', '06:00:00', '20:00:00', 25.00, 8),
('Kids Club', 'Children', 'Supervised activities and play area for children', '08:00:00', '20:00:00', 15.00, 25);

-- Insert Sample Special Offers
INSERT INTO special_offers (offer_title, description, discount_percentage, start_date, end_date, offer_type, is_active) VALUES
('Early Bird Special', 'Book 30 days in advance and save 20%', 20.00, '2026-01-01', '2026-12-31', 'room', TRUE),
('Weekend Getaway', 'Special weekend rates for 2-night stays', 15.00, '2026-01-01', '2026-06-30', 'package', TRUE),
('Spa Package', 'Complimentary spa treatment with 3-night stay', NULL, '2026-01-15', '2026-03-31', 'package', TRUE),
('Honeymoon Package', 'Romantic package for newlyweds with special amenities', 25.00, '2026-01-01', '2026-12-31', 'package', TRUE),
('Family Fun Deal', 'Kids stay free with dining credits included', NULL, '2026-06-01', '2026-08-31', 'package', TRUE);

-- Insert Sample Customer
INSERT INTO customers (first_name, last_name, email, phone, address, city, country, postal_code) VALUES
('John', 'Doe', 'john.doe@email.com', '+1-555-0123', '123 Main Street', 'New York', 'USA', '10001'),
('Jane', 'Smith', 'jane.smith@email.com', '+44-20-1234-5678', '456 Park Lane', 'London', 'UK', 'SW1A 1AA'),
('Michael', 'Johnson', 'michael.j@email.com', '+61-2-9876-5432', '789 Beach Road', 'Sydney', 'Australia', '2000');

-- ============================================
-- Views for Common Queries
-- ============================================

-- Available Rooms View
CREATE OR REPLACE VIEW available_rooms AS
SELECT 
    r.room_id,
    r.room_number,
    rt.type_name,
    rt.description,
    rt.base_price,
    rt.max_occupancy,
    r.floor_number,
    r.status
FROM rooms r
JOIN room_types rt ON r.room_type_id = rt.room_type_id
WHERE r.status = 'available';

-- Current Reservations View
CREATE OR REPLACE VIEW current_reservations AS
SELECT 
    res.reservation_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.phone,
    r.room_number,
    rt.type_name AS room_type,
    res.check_in_date,
    res.check_out_date,
    res.number_of_guests,
    res.total_price,
    res.reservation_status,
    res.payment_status
FROM reservations res
JOIN customers c ON res.customer_id = c.customer_id
JOIN rooms r ON res.room_id = r.room_id
JOIN room_types rt ON r.room_type_id = rt.room_type_id
WHERE res.reservation_status IN ('pending', 'confirmed', 'checked_in');

-- Revenue Summary View
CREATE OR REPLACE VIEW revenue_summary AS
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_revenue,
    AVG(amount) AS average_transaction
FROM payments
WHERE payment_status = 'completed'
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month DESC;

-- ============================================
-- Stored Procedures
-- ============================================

DELIMITER //

-- Check room availability for specific dates
CREATE PROCEDURE check_room_availability(
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_room_type_id INT
)
BEGIN
    SELECT 
        r.room_id,
        r.room_number,
        rt.type_name,
        rt.base_price,
        rt.max_occupancy
    FROM rooms r
    JOIN room_types rt ON r.room_type_id = rt.room_type_id
    WHERE r.room_type_id = p_room_type_id
    AND r.status = 'available'
    AND r.room_id NOT IN (
        SELECT room_id
        FROM reservations
        WHERE reservation_status NOT IN ('cancelled', 'checked_out')
        AND (
            (check_in_date <= p_check_in AND check_out_date > p_check_in)
            OR (check_in_date < p_check_out AND check_out_date >= p_check_out)
            OR (check_in_date >= p_check_in AND check_out_date <= p_check_out)
        )
    );
END //

-- Calculate total price for reservation
CREATE PROCEDURE calculate_reservation_price(
    IN p_room_type_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE,
    OUT p_total_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_base_price DECIMAL(10,2);
    DECLARE v_nights INT;
    
    SELECT base_price INTO v_base_price
    FROM room_types
    WHERE room_type_id = p_room_type_id;
    
    SET v_nights = DATEDIFF(p_check_out, p_check_in);
    SET p_total_price = v_base_price * v_nights;
END //

DELIMITER ;

-- ============================================
-- Triggers
-- ============================================

DELIMITER //

-- Update room status when reservation is confirmed
CREATE TRIGGER update_room_status_on_reservation
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
    IF NEW.reservation_status = 'confirmed' THEN
        UPDATE rooms
        SET status = 'reserved'
        WHERE room_id = NEW.room_id;
    END IF;
END //

-- Update room status when guest checks out
CREATE TRIGGER update_room_status_on_checkout
AFTER UPDATE ON reservations
FOR EACH ROW
BEGIN
    IF NEW.reservation_status = 'checked_out' AND OLD.reservation_status != 'checked_out' THEN
        UPDATE rooms
        SET status = 'available'
        WHERE room_id = NEW.room_id;
    END IF;
END //

DELIMITER ;

-- ============================================
-- End of Schema
-- ============================================
