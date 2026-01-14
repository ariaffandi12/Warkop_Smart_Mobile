<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include_once '../config/database.php';

if(!empty($_POST['user_id']) && !empty($_FILES['photo'])){
    $user_id = $_POST['user_id'];
    $photo = $_FILES['photo'];
    
    // Find active attendance record
    $query = "SELECT id FROM attendance WHERE user_id = ? AND status = 'bekerja' AND DATE(check_in) = CURDATE() ORDER BY check_in DESC LIMIT 1";
    $stmt = $conn->prepare($query);
    $stmt->execute([$user_id]);
    $attendance = $stmt->fetch(PDO::FETCH_ASSOC);

    if(!$attendance){
        http_response_code(400);
        echo json_encode(array("status" => "error", "message" => "Belum check-in atau sudah check-out."));
        exit;
    }

    $upload_dir = "../uploads/attendance/pulang/";
    if (!file_exists($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }

    $file_extension = pathinfo($photo['name'], PATHINFO_EXTENSION);
    $file_name = $user_id . "_" . time() . "." . $file_extension;
    $target_file = $upload_dir . $file_name;

    if(move_uploaded_file($photo['tmp_name'], $target_file)){
        $query = "UPDATE attendance SET check_out = NOW(), photo_out = ?, status = 'selesai' WHERE id = ?";
        $stmt = $conn->prepare($query);
        if($stmt->execute([$file_name, $attendance['id']])){
            http_response_code(200);
            echo json_encode(array("status" => "success", "message" => "Check-out berhasil."));
        } else {
            http_response_code(500);
            echo json_encode(array("status" => "error", "message" => "Gagal memperbarui data di database."));
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
