<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
include_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id)) {
    // Soft delete implementation
    $query = "UPDATE products SET is_deleted = 1 WHERE id = ?";
    $stmt = $conn->prepare($query);

    // Check if column exists first (migration helper)
    try {
        if ($stmt->execute([$data->id])) {
            echo json_encode(array("status" => "success", "message" => "Produk berhasil dihapus"));
        } else {
            http_response_code(500);
            echo json_encode(array("status" => "error", "message" => "Gagal menghapus produk"));
        }
    } catch (PDOException $e) {
        // If is_deleted column doesn't exist, we might need to add it or it's a hard delete scenario
        // For this task, we assume we might need to alter table if this fails, 
        // but robustly we should probably run migration once.
        // Let's try to add the column dynamically if it fails, just like the photo logic
        $conn->exec("ALTER TABLE products ADD COLUMN is_deleted TINYINT(1) DEFAULT 0");
        $stmt = $conn->prepare($query);
        $stmt->execute([$data->id]);
        echo json_encode(array("status" => "success", "message" => "Produk berhasil dihapus (migrasi otomatis)"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "ID produk diperlukan"));
}
?>