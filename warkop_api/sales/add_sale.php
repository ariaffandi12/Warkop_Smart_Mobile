<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
include_once '../config/database.php';
$data = json_decode(file_get_contents("php://input"));
if(!empty($data->user_id) && !empty($data->items) && !empty($data->total_price)){
    try {
        $conn->beginTransaction();
        $query = "INSERT INTO sales (user_id, total_price) VALUES (?, ?)";
        $stmt = $conn->prepare($query);
        $stmt->execute([$data->user_id, $data->total_price]);
        $sale_id = $conn->lastInsertId();
        foreach($data->items as $item){
            $query_item = "INSERT INTO sale_items (sale_id, product_id, quantity, price_at_sale) VALUES (?, ?, ?, ?)";
            $stmt_item = $conn->prepare($query_item);
            $stmt_item->execute([$sale_id, $item->product_id, $item->quantity, $item->price]);
            $query_update = "UPDATE products SET stock = stock - ? WHERE id = ?";
            $stmt_update = $conn->prepare($query_update);
            $stmt_update->execute([$item->quantity, $item->product_id]);
        }
        $conn->commit();
        echo json_encode(array("status" => "success"));
    } catch(Exception $e) {
        $conn->rollBack();
        echo json_encode(array("status" => "error", "message" => $e->getMessage()));
    }
}
?>
