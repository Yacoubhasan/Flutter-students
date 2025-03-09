<?php
include("connect.php");

$id = $_POST["id"];
$name = $_POST["name"];
$age = $_POST["age"];

$data = array(
    "name" => $name,
    "age" => $age
);
updateData("user", $data, "id=$id");
?>
