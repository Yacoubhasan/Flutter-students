<?php
include 'db.php';
$id = $_POST['id'];
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];

$sql = "UPDATE Students SET name=?, email=?, phone=?, address=? WHERE id=?";
$params = array($name, $email, $phone, $address, $id);
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>
