<?php
include_once '../config/database.php';
header("Content-Type: application/json; charset=UTF-8");
$query = "SELECT id, name, price, stock, image_url FROM products WHERE is_deleted = 0 ORDER BY name ASC";
$stmt = $conn->prepare($query);
$stmt->execute();
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode(array("status" => "success", "data" => $products));
?>
