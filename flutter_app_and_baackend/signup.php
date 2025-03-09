<?php
include "connect.php";

$email = filterRequest("email");
$password = filterRequest("password");
$name = filterRequest("name");

registerUser($email, $password, $name);
?>
