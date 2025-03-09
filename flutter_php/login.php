<?php
include 'db.php';
$email = $_POST['email'];
$password = $_POST['password'];

$sql = "SELECT * FROM Users WHERE email = ?";
$params = array($email);
$stmt = sqlsrv_query($conn, $sql, $params);
$row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);

if ($row && password_verify($password, $row['password'])) {
    echo json_encode(["status" => "success", "user" => $row]);
} else {
    echo json_encode(["status" => "error"]);
}
?>
