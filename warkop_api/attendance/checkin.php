<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once '../config/database.php';

if (!empty($_POST['user_id']) && !empty($_FILES['photo'])) {
    $user_id = $_POST['user_id'];
    $photo = $_FILES['photo'];

    // Cek apakah sudah check-in hari ini
    $checkQuery = "SELECT id, status FROM attendance WHERE user_id = ? AND DATE(check_in) = CURDATE() ORDER BY id DESC LIMIT 1";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->execute([$user_id]);
    $existingAttendance = $checkStmt->fetch(PDO::FETCH_ASSOC);

    if ($existingAttendance) {
        // Sudah ada record hari ini
        if ($existingAttendance['status'] === 'bekerja') {
            // Sudah check-in tapi belum check-out
            http_response_code(400);
            echo json_encode(array(
                "status" => "error",
                "message" => "Anda sudah check-in hari ini. Silakan check-out terlebih dahulu.",
                "error_code" => "ALREADY_CHECKED_IN"
            ));
            exit;
        } else if ($existingAttendance['status'] === 'selesai') {
            // Sudah check-in dan check-out hari ini
            http_response_code(400);
            echo json_encode(array(
                "status" => "error",
                "message" => "Anda sudah menyelesaikan absensi hari ini (check-in & check-out). Tidak dapat check-in lagi.",
                "error_code" => "ATTENDANCE_COMPLETED"
            ));
            exit;
        }
    }

    // Proses check-in baru
    $upload_dir = "../uploads/attendance/masuk/";
    if (!file_exists($upload_dir))
        mkdir($upload_dir, 0777, true);
    $file_name = $user_id . "_" . time() . ".jpg";

    if (move_uploaded_file($photo['tmp_name'], $upload_dir . $file_name)) {
        $query = "INSERT INTO attendance (user_id, check_in, photo_in, status) VALUES (?, NOW(), ?, 'bekerja')";
        $stmt = $conn->prepare($query);
        $stmt->execute([$user_id, $file_name]);
        http_response_code(201);
        echo json_encode(array("status" => "success", "message" => "Check-in berhasil!"));
    } else {
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => "Gagal upload foto"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap"));
}
?>