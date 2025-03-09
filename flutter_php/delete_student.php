<?php
include 'db.php';
$id = $_POST['id'];

$sql = "DELETE FROM Students WHERE id=?";
$params = array($id);
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>
