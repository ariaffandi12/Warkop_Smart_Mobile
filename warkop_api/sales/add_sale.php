<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->user_id) && !empty($data->items) && !empty($data->total_price)){
    try {
        $conn->beginTransaction();

        // 1. Insert into sales
        $query = "INSERT INTO sales (user_id, total_price) VALUES (?, ?)";
        $stmt = $conn->prepare($query);
        $stmt->execute([$data->user_id, $data->total_price]);
        $sale_id = $conn->lastInsertId();

        // 2. Insert into sale_items and update stock
        foreach($data->items as $item){
            // Check stock
            $check_stock = "SELECT stock FROM products WHERE id = ? FOR UPDATE";
            $stmt_stock = $conn->prepare($check_stock);
            $stmt_stock->execute([$item->product_id]);
            $product = $stmt_stock->fetch(PDO::FETCH_ASSOC);

            if($product['stock'] < $item->quantity){
                throw new Exception("Stok tidak mencukupi untuk produk ID: " . $item->product_id);
            }

            // Insert item
            $query_item = "INSERT INTO sale_items (sale_id, product_id, quantity, price_at_sale) VALUES (?, ?, ?, ?)";
            $stmt_item = $conn->prepare($query_item);
            $stmt_item->execute([$sale_id, $item->product_id, $item->quantity, $item->price]);

            // Reduction
            $query_update = "UPDATE products SET stock = stock - ? WHERE id = ?";
            $stmt_update = $conn->prepare($query_update);
            $stmt_update->execute([$item->quantity, $item->product_id]);
        }

        $conn->commit();
        http_response_code(201);
        echo json_encode(array("status" => "success", "message" => "Transaksi berhasil."));
    } catch(Exception $e) {
        $conn->rollBack();
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => $e->getMessage()));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap."));
}
?>
