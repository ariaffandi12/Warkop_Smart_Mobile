<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../config/database.php';

$type = isset($_GET['type']) ? $_GET['type'] : 'today'; // today, monthly

if($type == 'today'){
    $query = "SELECT s.id, s.total_price, s.created_at, u.name as karyawan_name 
              FROM sales s 
              JOIN users u ON s.user_id = u.id 
              WHERE DATE(s.created_at) = CURDATE() 
              ORDER BY s.created_at DESC";
} else {
    $query = "SELECT s.id, s.total_price, s.created_at, u.name as karyawan_name 
              FROM sales s 
              JOIN users u ON s.user_id = u.id 
              WHERE MONTH(s.created_at) = MONTH(CURDATE()) AND YEAR(s.created_at) = YEAR(CURDATE())
              ORDER BY s.created_at DESC";
}

$stmt = $conn->prepare($query);
$stmt->execute();
$sales = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Summary
if($type == 'today'){
    $summary_query = "SELECT SUM(total_price) as total_income, COUNT(id) as total_transactions FROM sales WHERE DATE(created_at) = CURDATE()";
} else {
    $summary_query = "SELECT SUM(total_price) as total_income, COUNT(id) as total_transactions FROM sales WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())";
}
$stmt_sum = $conn->prepare($summary_query);
$stmt_sum->execute();
$summary = $stmt_sum->fetch(PDO::FETCH_ASSOC);

echo json_encode(array(
    "status" => "success",
    "summary" => $summary,
    "data" => $sales
));
?>
