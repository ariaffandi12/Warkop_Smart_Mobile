<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include_once '../config/database.php';

if(!empty($_POST['name']) && !empty($_POST['price']) && isset($_POST['stock'])){
    $name = $_POST['name'];
    $price = $_POST['price'];
    $stock = $_POST['stock'];
    $image_url = "";

    if(!empty($_FILES['image'])){
        $image = $_FILES['image'];
        $upload_dir = "../uploads/products/";
        if (!file_exists($upload_dir)) {
            mkdir($upload_dir, 0777, true);
        }
        $file_extension = pathinfo($image['name'], PATHINFO_EXTENSION);
        $file_name = uniqid() . "_" . time() . "." . $file_extension;
        $target_file = $upload_dir . $file_name;
        if(move_uploaded_file($image['tmp_name'], $target_file)){
            $image_url = $file_name;
        }
    }

    $query = "INSERT INTO products (name, price, stock, image_url) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    if($stmt->execute([$name, $price, $stock, $image_url])){
        http_response_code(201);
        echo json_encode(array("status" => "success", "message" => "Produk berhasil ditambahkan."));
    } else {
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => "Gagal menambahkan produk."));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap."));
}
?>
