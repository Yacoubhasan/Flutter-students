<?php
include 'db.php';
$sql = "SELECT * FROM Students";
$stmt = sqlsrv_query($conn, $sql);
$students = [];

while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $students[] = $row;
}

echo json_encode($students);
?>
