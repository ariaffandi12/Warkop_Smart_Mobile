<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
include_once '../config/database.php';
$data = json_decode(file_get_contents("php://input"));
if(!empty($data->id) && isset($data->stock)){
    $id = $data->id;
    $stock = $data->stock;
    $query = "UPDATE products SET stock = ? WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->execute([$stock, $id]);
    echo json_encode(array("status" => "success"));
}
?>
