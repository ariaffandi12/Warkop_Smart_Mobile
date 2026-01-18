<?php
include_once '../config/database.php';
header("Content-Type: application/json; charset=UTF-8");
$data = json_decode(file_get_contents("php://input"));
if (!empty($data->email) && !empty($data->password)) {
    $email = $data->email;
    $password = $data->password;
    $query = "SELECT id, name, email, password, role, photo FROM users WHERE email = ? LIMIT 0,1";
    $stmt = $conn->prepare($query);
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($user && password_verify($password, $user['password'])) {
        http_response_code(200);
        echo json_encode(array(
            "status" => "success",
            "user" => array(
                "id" => $user['id'],
                "name" => $user['name'],
                "email" => $user['email'],
                "role" => $user['role'],
                "photo" => $user['photo']
            )
        ));
    } else {
        http_response_code(401);
        echo json_encode(array("status" => "error", "message" => "Login gagal."));
    }
}
?>