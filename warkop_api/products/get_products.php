<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../config/database.php';

$query = "SELECT id, name, price, stock, image_url FROM products WHERE is_deleted = 0 ORDER BY name ASC";
$stmt = $conn->prepare($query);
$stmt->execute();
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode(array("status" => "success", "data" => $products));
?>
