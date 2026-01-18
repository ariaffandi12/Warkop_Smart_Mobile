<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once '../config/database.php';
$query = "SELECT a.id, a.check_in, a.check_out, a.photo_in, a.photo_out, a.status, u.name as karyawan_name, u.photo as karyawan_photo FROM attendance a JOIN users u ON a.user_id = u.id ORDER BY a.check_in DESC";
$stmt = $conn->prepare($query);
$stmt->execute();
$attendance = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode(array("status" => "success", "data" => $attendance));
?>