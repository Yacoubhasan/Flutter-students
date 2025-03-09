<?php
include 'db.php';
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];

$sql = "INSERT INTO Students (name, email, phone, address) VALUES (?, ?, ?, ?)";
$params = array($name, $email, $phone, $address);
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>
