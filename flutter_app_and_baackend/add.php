<?php
include("connect.php");

$name = $_POST["name"];
$age = $_POST["age"];
$data = array(
    "name" => $name,
    "age" => $age
);
insertData("user", $data);
