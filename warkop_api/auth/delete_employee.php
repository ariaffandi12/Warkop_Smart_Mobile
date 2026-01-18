<?php
include_once '../config/database.php';
header("Content-Type: application/json; charset=UTF-8");

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->user_id)) {
    $userId = $data->user_id;

    try {
        // Start transaction
        $conn->beginTransaction();

        // Check if user exists and is an employee
        $checkQuery = "SELECT id, role FROM users WHERE id = ?";
        $checkStmt = $conn->prepare($checkQuery);
        $checkStmt->execute([$userId]);

        if ($checkStmt->rowCount() == 0) {
            $conn->rollBack();
            http_response_code(404);
            echo json_encode(array(
                "status" => "error",
                "message" => "User tidak ditemukan"
            ));
            exit();
        }

        $user = $checkStmt->fetch(PDO::FETCH_ASSOC);

        // Prevent deleting owner accounts
        if ($user['role'] === 'owner') {
            $conn->rollBack();
            http_response_code(403);
            echo json_encode(array(
                "status" => "error",
                "message" => "Tidak dapat menghapus akun owner"
            ));
            exit();
        }

        // Get all sale IDs for this user first
        $getSales = "SELECT id FROM sales WHERE user_id = ?";
        $getSalesStmt = $conn->prepare($getSales);
        $getSalesStmt->execute([$userId]);
        $saleIds = $getSalesStmt->fetchAll(PDO::FETCH_COLUMN);

        // Delete sale_items for each sale (foreign key constraint)
        if (!empty($saleIds)) {
            $placeholders = implode(',', array_fill(0, count($saleIds), '?'));
            $deleteSaleItems = "DELETE FROM sale_items WHERE sale_id IN ($placeholders)";
            $saleItemsStmt = $conn->prepare($deleteSaleItems);
            $saleItemsStmt->execute($saleIds);
        }

        // Delete sales records
        $deleteSales = "DELETE FROM sales WHERE user_id = ?";
        $salesStmt = $conn->prepare($deleteSales);
        $salesStmt->execute([$userId]);

        // Delete attendance records
        $deleteAttendance = "DELETE FROM attendance WHERE user_id = ?";
        $attStmt = $conn->prepare($deleteAttendance);
        $attStmt->execute([$userId]);

        // Delete user
        $query = "DELETE FROM users WHERE id = ?";
        $stmt = $conn->prepare($query);
        $stmt->execute([$userId]);

        // Commit transaction
        $conn->commit();

        http_response_code(200);
        echo json_encode(array(
            "status" => "success",
            "message" => "Karyawan berhasil dihapus"
        ));

    } catch (PDOException $e) {
        // Rollback on error
        $conn->rollBack();
        http_response_code(500);
        echo json_encode(array(
            "status" => "error",
            "message" => "Gagal menghapus karyawan: " . $e->getMessage()
        ));
    }
} else {
    http_response_code(400);
    echo json_encode(array(
        "status" => "error",
        "message" => "Data tidak lengkap. user_id wajib diisi."
    ));
}
?>