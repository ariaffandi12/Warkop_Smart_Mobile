<?php
include_once '../config/database.php';
header("Content-Type: application/json; charset=UTF-8");

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->name) && !empty($data->email) && !empty($data->password)) {
    $name = $data->name;
    $email = $data->email;
    $password = password_hash($data->password, PASSWORD_DEFAULT);
    $role = 'karyawan'; // Always register as karyawan

    // Check if email already exists
    $checkQuery = "SELECT id FROM users WHERE email = ?";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->execute([$email]);

    if ($checkStmt->rowCount() > 0) {
        http_response_code(400);
        echo json_encode(array(
            "status" => "error",
            "message" => "Email sudah terdaftar"
        ));
        exit();
    }

    // Insert new user
    $query = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($query);

    if ($stmt->execute([$name, $email, $password, $role])) {
        $newId = $conn->lastInsertId();
        http_response_code(201);
        echo json_encode(array(
            "status" => "success",
            "message" => "Karyawan berhasil didaftarkan",
            "user" => array(
                "id" => $newId,
                "name" => $name,
                "email" => $email,
                "role" => $role
            )
        ));
    } else {
        http_response_code(500);
        echo json_encode(array(
            "status" => "error",
            "message" => "Gagal mendaftarkan karyawan"
        ));
    }
} else {
    http_response_code(400);
    echo json_encode(array(
        "status" => "error",
        "message" => "Data tidak lengkap. Nama, email, dan password wajib diisi."
    ));
}
?>