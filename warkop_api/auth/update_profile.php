<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
include_once '../config/database.php';

if ($_POST['user_id']) {
    $user_id = $_POST['user_id'];
    $name = $_POST['name'];

    // Default response
    $response = array("status" => "error", "message" => "Tidak ada perubahan");

    // Update Name if provided
    if (!empty($name)) {
        $query = "UPDATE users SET name = ? WHERE id = ?";
        $stmt = $conn->prepare($query);
        if ($stmt->execute([$name, $user_id])) {
            $response = array("status" => "success", "message" => "Nama berhasil diupdate");
        }
    }

    // Update Photo if provided
    if (!empty($_FILES['photo'])) {
        $photo = $_FILES['photo'];
        $upload_dir = "../uploads/profiles/";
        if (!file_exists($upload_dir))
            mkdir($upload_dir, 0777, true);

        $file_name = $user_id . "_" . time() . ".jpg";

        if (move_uploaded_file($photo['tmp_name'], $upload_dir . $file_name)) {
            // Check if 'photo' column exists, if not try to add it (simple migration attempt)
            // Note: In production this should be done properly via migration scripts
            try {
                $query = "UPDATE users SET photo = ? WHERE id = ?";
                $stmt = $conn->prepare($query);
                $stmt->execute([$file_name, $user_id]);
            } catch (PDOException $e) {
                // If column not found, try adding it
                $conn->exec("ALTER TABLE users ADD COLUMN photo VARCHAR(255) AFTER email");
                $query = "UPDATE users SET photo = ? WHERE id = ?";
                $stmt = $conn->prepare($query);
                $stmt->execute([$file_name, $user_id]);
            }

            $response = array("status" => "success", "message" => "Profil berhasil diupdate", "photo" => $file_name);
        } else {
            http_response_code(500);
            echo json_encode(array("status" => "error", "message" => "Gagal upload foto profil"));
            exit();
        }
    }

    // Return the updated user data
    $query = "SELECT id, name, email, role, photo FROM users WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->execute([$user_id]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        // Explicitly return 200 OK
        http_response_code(200);
        $response['user'] = $user;
        echo json_encode($response);
    } else {
        http_response_code(404);
        echo json_encode(array("status" => "error", "message" => "User tidak ditemukan"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap"));
}
?>