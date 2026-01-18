<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
include_once '../config/database.php';

if (!empty($_POST['id']) && !empty($_POST['name']) && !empty($_POST['price']) && isset($_POST['stock'])) {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $price = $_POST['price'];
    $stock = $_POST['stock'];

    // Construct base query
    $query = "UPDATE products SET name = ?, price = ?, stock = ?";
    $params = [$name, $price, $stock];

    // Handle Image Update if provided
    if (!empty($_FILES['image'])) {
        $image = $_FILES['image'];
        $upload_dir = "../uploads/products/";
        if (!file_exists($upload_dir))
            mkdir($upload_dir, 0777, true);

        $file_name = uniqid() . ".jpg";
        if (move_uploaded_file($image['tmp_name'], $upload_dir . $file_name)) {
            $query .= ", image_url = ?";
            $params[] = $file_name;
        } else {
            http_response_code(500);
            echo json_encode(array("status" => "error", "message" => "Gagal upload gambar produk"));
            exit();
        }
    }

    $query .= " WHERE id = ?";
    $params[] = $id;

    $stmt = $conn->prepare($query);
    if ($stmt->execute($params)) {
        echo json_encode(array("status" => "success", "message" => "Produk berhasil diupdate"));
    } else {
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => "Gagal update produk"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap"));
}
?>