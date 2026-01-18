<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
include_once '../config/database.php';

if (!empty($_POST['user_id']) && !empty($_FILES['photo'])) {
    $user_id = $_POST['user_id'];
    $photo = $_FILES['photo'];

    // Cek apakah sudah ada record hari ini
    $checkQuery = "SELECT id, status FROM attendance WHERE user_id = ? AND DATE(check_in) = CURDATE() ORDER BY id DESC LIMIT 1";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->execute([$user_id]);
    $attendance = $checkStmt->fetch(PDO::FETCH_ASSOC);

    if (!$attendance) {
        // Belum check-in sama sekali hari ini
        http_response_code(400);
        echo json_encode(array(
            "status" => "error",
            "message" => "Anda belum check-in hari ini. Silakan check-in terlebih dahulu.",
            "error_code" => "NOT_CHECKED_IN"
        ));
        exit;
    }

    if ($attendance['status'] === 'selesai') {
        // Sudah check-out hari ini
        http_response_code(400);
        echo json_encode(array(
            "status" => "error",
            "message" => "Anda sudah check-out hari ini. Tidak dapat check-out lagi.",
            "error_code" => "ALREADY_CHECKED_OUT"
        ));
        exit;
    }

    // Proses check-out (status masih 'bekerja')
    $upload_dir = "../uploads/attendance/pulang/";
    if (!file_exists($upload_dir))
        mkdir($upload_dir, 0777, true);
    $file_name = $user_id . "_" . time() . ".jpg";

    if (move_uploaded_file($photo['tmp_name'], $upload_dir . $file_name)) {
        $query = "UPDATE attendance SET check_out = NOW(), photo_out = ?, status = 'selesai' WHERE id = ?";
        $stmt = $conn->prepare($query);
        $stmt->execute([$file_name, $attendance['id']]);
        echo json_encode(array("status" => "success", "message" => "Check-out berhasil!"));
    } else {
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => "Gagal upload foto"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap"));
}
?>