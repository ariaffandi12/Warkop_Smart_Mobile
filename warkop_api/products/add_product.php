<?php
include_once '../config/database.php';
header("Content-Type: application/json; charset=UTF-8");
if (!empty($_POST['name']) && !empty($_POST['price'])) {
    $name = $_POST['name'];
    $price = $_POST['price'];
    $stock = $_POST['stock'] ?? 0;
    $image_url = "";
    if (!empty($_FILES['image'])) {
        $image = $_FILES['image'];
        $upload_dir = "../uploads/products/";
        if (!file_exists($upload_dir))
            mkdir($upload_dir, 0777, true);
        $file_name = uniqid() . ".jpg";
        if (move_uploaded_file($image['tmp_name'], $upload_dir . $file_name)) {
            $image_url = $file_name;
        } else {
            http_response_code(500);
            echo json_encode(array("status" => "error", "message" => "Gagal upload gambar produk"));
            exit();
        }
    }
    $query = "INSERT INTO products (name, price, stock, image_url) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->execute([$name, $price, $stock, $image_url]);
    http_response_code(201);
    echo json_encode(array("status" => "success"));
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Incomplete data"));
}
?>