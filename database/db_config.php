<?php
/**
 * Vista Veranda Hotel - Database Configuration
 * 
 * This file contains database connection settings.
 * Make sure to update these values according to your server configuration.
 */

// Database configuration constants
define('DB_HOST', 'localhost');      // Database host (usually localhost)
define('DB_NAME', 'vista_veranda');  // Database name
define('DB_USER', 'root');           // Database username
define('DB_PASS', '');               // Database password (leave empty for XAMPP default)
define('DB_CHARSET', 'utf8mb4');     // Character set

// Create database connection
function getDBConnection() {
    try {
        $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        return $pdo;
        
    } catch (PDOException $e) {
        // Log error and display user-friendly message
        error_log("Database Connection Error: " . $e->getMessage());
        die("Database connection failed. Please contact administrator.");
    }
}

// Alternative MySQLi connection (if you prefer MySQLi over PDO)
function getMySQLiConnection() {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    if ($conn->connect_error) {
        error_log("MySQLi Connection Error: " . $conn->connect_error);
        die("Database connection failed. Please contact administrator.");
    }
    
    $conn->set_charset(DB_CHARSET);
    return $conn;
}

// Test database connection
function testConnection() {
    try {
        $pdo = getDBConnection();
        return true;
    } catch (Exception $e) {
        return false;
    }
}
?>
