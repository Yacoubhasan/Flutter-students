<?php
include "connect.php";
$usersid = filterRequest("id");
deleteData("user", "id=$usersid");
?>
