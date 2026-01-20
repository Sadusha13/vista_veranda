<?php
/**
 * Customer Bookings Report
 * Displays all customers with their reservations
 */

require_once 'database/db_config.php';

try {
    $pdo = getDBConnection();
    
    // Query to get customers with their bookings
    $query = "
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.phone,
        c.city,
        c.country,
        r.reservation_id,
        r.check_in_date,
        r.check_out_date,
        r.number_of_guests,
        r.number_of_adults,
        r.number_of_children,
        r.total_price,
        r.reservation_status,
        r.payment_status,
        rm.room_number,
        rt.type_name AS room_type,
        DATEDIFF(r.check_out_date, r.check_in_date) AS nights
    FROM customers c
    LEFT JOIN reservations r ON c.customer_id = r.customer_id
    LEFT JOIN rooms rm ON r.room_id = rm.room_id
    LEFT JOIN room_types rt ON rm.room_type_id = rt.room_type_id
    ORDER BY c.customer_id, r.check_in_date DESC
    ";
    
    $stmt = $pdo->prepare($query);
    $stmt->execute();
    $results = $stmt->fetchAll();
    
} catch (PDOException $e) {
    die("Database Error: " . $e->getMessage());
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Bookings - Vista Veranda</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 30px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .header-info {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .stat-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background: #333;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
        }
        
        tr:hover {
            background: #f5f5f5;
        }
        
        .customer-row {
            background: #f9f9f9;
            font-weight: 600;
        }
        
        .booking-row {
            background: white;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-confirmed {
            background: #4CAF50;
            color: white;
        }
        
        .status-pending {
            background: #FFC107;
            color: #333;
        }
        
        .status-checked-in {
            background: #2196F3;
            color: white;
        }
        
        .status-checked-out {
            background: #9E9E9E;
            color: white;
        }
        
        .status-cancelled {
            background: #F44336;
            color: white;
        }
        
        .payment-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .payment-paid {
            background: #4CAF50;
            color: white;
        }
        
        .payment-unpaid {
            background: #F44336;
            color: white;
        }
        
        .payment-partial {
            background: #FFC107;
            color: #333;
        }
        
        .no-bookings {
            color: #999;
            font-style: italic;
        }
        
        .price {
            color: #667eea;
            font-weight: 600;
        }
        
        .contact-info {
            font-size: 13px;
            color: #666;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏨 Customer Bookings Report</h1>
        <div class="header-info">
            <p>Vista Veranda Hotel - Customer Reservation Management System</p>
            <p>Last Updated: <?php echo date('Y-m-d H:i:s'); ?></p>
        </div>
        
        <?php
        // Calculate statistics
        $totalCustomers = count(array_unique(array_column($results, 'customer_id')));
        $totalBookings = count(array_filter($results, function($row) { return !is_null($row['reservation_id']); }));
        $totalRevenue = 0;
        foreach ($results as $row) {
            if (!is_null($row['total_price'])) {
                $totalRevenue += $row['total_price'];
            }
        }
        ?>
        
        <div class="stats">
            <div class="stat-box">
                <div class="stat-number"><?php echo $totalCustomers; ?></div>
                <div class="stat-label">Total Customers</div>
            </div>
            <div class="stat-box">
                <div class="stat-number"><?php echo $totalBookings; ?></div>
                <div class="stat-label">Total Bookings</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">$<?php echo number_format($totalRevenue, 2); ?></div>
                <div class="stat-label">Total Revenue</div>
            </div>
        </div>
        
        <?php if (count($results) > 0): ?>
            <table>
                <thead>
                    <tr>
                        <th>Customer ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Location</th>
                        <th>Check-In</th>
                        <th>Check-Out</th>
                        <th>Room</th>
                        <th>Guests</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Payment</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $lastCustomerId = null;
                    foreach ($results as $row):
                        $isCustomerRow = ($lastCustomerId !== $row['customer_id']);
                        $lastCustomerId = $row['customer_id'];
                    ?>
                        <tr class="<?php echo is_null($row['reservation_id']) ? 'customer-row' : 'booking-row'; ?>">
                            <td><?php echo $row['customer_id']; ?></td>
                            <td>
                                <strong><?php echo htmlspecialchars($row['first_name'] . ' ' . $row['last_name']); ?></strong>
                            </td>
                            <td class="contact-info"><?php echo htmlspecialchars($row['email']); ?></td>
                            <td class="contact-info"><?php echo htmlspecialchars($row['phone'] ?? 'N/A'); ?></td>
                            <td class="contact-info">
                                <?php echo htmlspecialchars($row['city'] ?? 'N/A'); ?>, 
                                <?php echo htmlspecialchars($row['country'] ?? 'N/A'); ?>
                            </td>
                            <td>
                                <?php echo is_null($row['check_in_date']) ? '<span class="no-bookings">No booking</span>' : date('Y-m-d', strtotime($row['check_in_date'])); ?>
                            </td>
                            <td>
                                <?php echo is_null($row['check_out_date']) ? '-' : date('Y-m-d', strtotime($row['check_out_date'])); ?>
                            </td>
                            <td>
                                <?php if (!is_null($row['room_number'])): ?>
                                    <strong><?php echo htmlspecialchars($row['room_number']); ?></strong><br>
                                    <small><?php echo htmlspecialchars($row['room_type']); ?></small>
                                <?php else: ?>
                                    <span class="no-bookings">-</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if (!is_null($row['number_of_guests'])): ?>
                                    <?php echo $row['number_of_guests']; ?> 
                                    (<?php echo $row['number_of_adults']; ?> adults, <?php echo $row['number_of_children']; ?> children)
                                <?php else: ?>
                                    -
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if (!is_null($row['total_price'])): ?>
                                    <span class="price">$<?php echo number_format($row['total_price'], 2); ?></span>
                                <?php else: ?>
                                    -
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if (!is_null($row['reservation_status'])): ?>
                                    <span class="status-badge status-<?php echo str_replace('_', '-', $row['reservation_status']); ?>">
                                        <?php echo ucfirst(str_replace('_', ' ', $row['reservation_status'])); ?>
                                    </span>
                                <?php else: ?>
                                    -
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if (!is_null($row['payment_status'])): ?>
                                    <span class="payment-badge payment-<?php echo str_replace('_', '-', $row['payment_status']); ?>">
                                        <?php echo ucfirst(str_replace('_', ' ', $row['payment_status'])); ?>
                                    </span>
                                <?php else: ?>
                                    -
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <div class="no-data">
                <p>No customer data available yet.</p>
            </div>
        <?php endif; ?>
    </div>
</body>
</html>
