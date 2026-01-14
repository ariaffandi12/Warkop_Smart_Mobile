<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include_once '../config/database.php';

if(!empty($_POST['user_id']) && !empty($_FILES['photo'])){
    $user_id = $_POST['user_id'];
    $photo = $_FILES['photo'];
    
    // Check if already checked in today
    $query = "SELECT id FROM attendance WHERE user_id = ? AND DATE(check_in) = CURDATE()";
    $stmt = $conn->prepare($query);
    $stmt->execute([$user_id]);
    if($stmt->rowCount() > 0){
        http_response_code(400);
        echo json_encode(array("status" => "error", "message" => "Sudah check-in hari ini."));
        exit;
    }

    $upload_dir = "../uploads/attendance/masuk/";
    if (!file_exists($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }

    $file_extension = pathinfo($photo['name'], PATHINFO_EXTENSION);
    $file_name = $user_id . "_" . time() . "." . $file_extension;
    $target_file = $upload_dir . $file_name;

    if(move_uploaded_file($photo['tmp_name'], $target_file)){
        $query = "INSERT INTO attendance (user_id, check_in, photo_in, status) VALUES (?, NOW(), ?, 'bekerja')";
        $stmt = $conn->prepare($query);
        if($stmt->execute([$user_id, $file_name])){
            http_response_code(201);
            echo json_encode(array("status" => "success", "message" => "Check-in berhasil."));
        } else {
            http_response_code(500);
            echo json_encode(array("status" => "error", "message" => "Gagal menyimpan data ke database."));
        }
    } else {
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => "Gagal upload foto."));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap."));
}
?>
