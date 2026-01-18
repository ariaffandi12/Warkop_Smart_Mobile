<?php
include_once '../config/database.php';
header("Content-Type: application/json; charset=UTF-8");

// Get all employees (users with role 'karyawan')
$query = "SELECT id, name, email, photo FROM users WHERE role = 'karyawan' ORDER BY name ASC";
$stmt = $conn->prepare($query);
$stmt->execute();

$employees = $stmt->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode(array(
    "status" => "success",
    "data" => $employees
));
?>