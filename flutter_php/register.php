<?php
include 'db.php';
$name = $_POST['name'];
$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_BCRYPT);

$sql = "INSERT INTO Users (name, email, password) VALUES (?, ?, ?)";
$params = array($name, $email, $password);
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>
