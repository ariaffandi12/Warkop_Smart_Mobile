<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once '../config/database.php';
$type = isset($_GET['type']) ? $_GET['type'] : 'today';
if ($type == 'today') {
    $query = "SELECT s.id, s.total_price, s.created_at, u.name as karyawan_name, 
              p.name as product_name, si.quantity 
              FROM sales s 
              JOIN users u ON s.user_id = u.id 
              LEFT JOIN sale_items si ON s.id = si.sale_id 
              LEFT JOIN products p ON si.product_id = p.id 
              WHERE DATE(s.created_at) = CURDATE() 
              ORDER BY s.created_at DESC";
    $summary_query = "SELECT SUM(total_price) as total_income, COUNT(id) as total_transactions FROM sales WHERE DATE(created_at) = CURDATE()";
} else if ($type == 'yesterday') {
    $query = "SELECT s.id, s.total_price, s.created_at, u.name as karyawan_name, 
              p.name as product_name, si.quantity 
              FROM sales s 
              JOIN users u ON s.user_id = u.id 
              LEFT JOIN sale_items si ON s.id = si.sale_id 
              LEFT JOIN products p ON si.product_id = p.id 
              WHERE DATE(s.created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY) 
              ORDER BY s.created_at DESC";
    $summary_query = "SELECT SUM(total_price) as total_income, COUNT(id) as total_transactions FROM sales WHERE DATE(created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)";
} else {
    $query = "SELECT s.id, s.total_price, s.created_at, u.name as karyawan_name, 
              p.name as product_name, si.quantity 
              FROM sales s 
              JOIN users u ON s.user_id = u.id 
              LEFT JOIN sale_items si ON s.id = si.sale_id 
              LEFT JOIN products p ON si.product_id = p.id 
              WHERE MONTH(s.created_at) = MONTH(CURDATE()) 
              ORDER BY s.created_at DESC";
    $summary_query = "SELECT SUM(total_price) as total_income, COUNT(id) as total_transactions FROM sales WHERE MONTH(created_at) = MONTH(CURDATE())";
}
$stmt = $conn->prepare($query);
$stmt->execute();
$sales = $stmt->fetchAll(PDO::FETCH_ASSOC);
$stmt_sum = $conn->prepare($summary_query);
$stmt_sum->execute();
$summary = $stmt_sum->fetch(PDO::FETCH_ASSOC);
echo json_encode(array("status" => "success", "summary" => $summary, "data" => $sales));
?>
