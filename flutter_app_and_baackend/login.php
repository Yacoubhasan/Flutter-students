<?php
include "connect.php";

$email = filterRequest("email");
$password = filterRequest("password");

loginUser($email, $password);
?>
