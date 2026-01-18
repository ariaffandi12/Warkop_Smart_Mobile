<?php
include_once '../config/database.php';
header("Content-Type: application/json; charset=UTF-8");

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->user_id) && !empty($data->new_password)) {
    $userId = $data->user_id;
    $newPassword = password_hash($data->new_password, PASSWORD_DEFAULT);

    // Check if user exists
    $checkQuery = "SELECT id FROM users WHERE id = ?";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->execute([$userId]);

    if ($checkStmt->rowCount() == 0) {
        http_response_code(404);
        echo json_encode(array(
            "status" => "error",
            "message" => "User tidak ditemukan"
        ));
        exit();
    }

    // Update password
    $query = "UPDATE users SET password = ? WHERE id = ?";
    $stmt = $conn->prepare($query);

    if ($stmt->execute([$newPassword, $userId])) {
        http_response_code(200);
        echo json_encode(array(
            "status" => "success",
            "message" => "Password berhasil diubah"
        ));
    } else {
        http_response_code(500);
        echo json_encode(array(
            "status" => "error",
            "message" => "Gagal mengubah password"
        ));
    }
} else {
    http_response_code(400);
    echo json_encode(array(
        "status" => "error",
        "message" => "Data tidak lengkap. user_id dan new_password wajib diisi."
    ));
}
?>