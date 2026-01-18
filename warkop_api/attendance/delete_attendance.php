<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
include_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id)) {
    try {
        // First get the photo filenames to delete files as well if needed
        $query = "SELECT photo_in, photo_out FROM attendance WHERE id = ?";
        $stmt = $conn->prepare($query);
        $stmt->execute([$data->id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            // Delete record
            $query = "DELETE FROM attendance WHERE id = ?";
            $stmt = $conn->prepare($query);
            if ($stmt->execute([$data->id])) {
                // Optionally delete physical files
                if (!empty($row['photo_in'])) {
                    @unlink("../uploads/attendance/masuk/" . $row['photo_in']);
                }
                if (!empty($row['photo_out'])) {
                    @unlink("../uploads/attendance/pulang/" . $row['photo_out']);
                }

                http_response_code(200);
                echo json_encode(array("status" => "success", "message" => "Record deleted"));
            } else {
                http_response_code(500);
                echo json_encode(array("status" => "error", "message" => "Failed to delete record"));
            }
        } else {
            http_response_code(404);
            echo json_encode(array("status" => "error", "message" => "Record not found"));
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => $e->getMessage()));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Missing ID"));
}
?>