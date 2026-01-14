<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->email) && !empty($data->password)){
    $email = $data->email;
    $password = $data->password;

    $query = "SELECT id, name, email, password, role FROM users WHERE email = ? LIMIT 0,1";
    $stmt = $conn->prepare($query);
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if($user && password_verify($password, $user['password'])){
        http_response_code(200);
        echo json_encode(array(
            "status" => "success",
            "message" => "Login successful",
            "user" => array(
                "id" => $user['id'],
                "name" => $user['name'],
                "email" => $user['email'],
                "role" => $user['role']
            )
        ));
    } else {
        http_response_code(401);
        echo json_encode(array("status" => "error", "message" => "Invalid email or password."));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Email and password are required."));
}
?>
