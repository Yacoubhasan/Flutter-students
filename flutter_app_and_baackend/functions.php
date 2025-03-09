<?php

// ==========================================================
//  Copyright Reserved Wael Wael Abo Hamza (Course Ecommerce)
// ==========================================================

define("MB", 1048576);
function filterRequest($requestname)
{
  return  htmlspecialchars(strip_tags($_POST[$requestname]));
}

function getAllData($table, $where = null, $values = null,$Json=true)
{
    global $con;
    $data = array();
    $stmt = $con->prepare("SELECT  * FROM $table WHERE   $where ");
    if($where==null)
    {
        $stmt = $con->prepare("SELECT  * FROM $table ");
    }
    $stmt->execute($values);
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $count  = $stmt->rowCount();
   if($Json==true)
   {
    if ($count > 0){
        echo json_encode(array("status" => "success", "data" => $data));
    } else {
        echo json_encode(array("status" => "failure"));
    }
    return $count;
   }
   else
   {
    if ($count > 0){
        return $data;}
    else
    {
        return json_encode(array("status" => "failure"));
    }
   }
}

// function insertData($table, $data, $json = true)
// {
//     $fields = implode(',', array_keys($data));
//     $placeholders = implode(',', array_fill(0, count($data), '?'));

//     $values = array_values($data);

//     $count = DB::table($table)->insert($data);

//     if ($json) {
//         if ($count > 0) {
//             return response()->json(["status" => "success"]);
//         } else {
//             return response()->json(["status" => "failure"]);
//         }
//     }

//     return $count;
// }

function insertData($table, $data, $json = true)
{
    global $con;
    foreach ($data as $field => $v)
        $ins[] = ':' . $field;
    $ins = implode(',', $ins);
    $fields = implode(',', array_keys($data));
    $sql = "INSERT INTO $table ($fields) VALUES ($ins)";

    $stmt = $con->prepare($sql);
    foreach ($data as $f => $v) {
        $stmt->bindValue(':' . $f, $v);
    }
    $stmt->execute();
    $count = $stmt->rowCount();
    if ($json == true) {
    if ($count > 0) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "failure"));
    }
  }
    return $count;
}


function updateData($table, $data, $where, $json = true)
{
    global $con;
    $cols = array();
    $vals = array();

    foreach ($data as $key => $val) {
        $vals[] = "$val";
        $cols[] = "`$key` =  ? ";
    }
    $sql = "UPDATE $table SET " . implode(', ', $cols) . " WHERE $where";

    $stmt = $con->prepare($sql);
    $stmt->execute($vals);
    $count = $stmt->rowCount();
    if ($json == true) {
    if ($count > 0) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "failure"));
    }
    }
    return $count;
}

function deleteData($table, $where, $json = true)
{
    global $con;
    $stmt = $con->prepare("DELETE FROM $table WHERE $where");
    $stmt->execute();
    $count = $stmt->rowCount();
    if ($json == true) {
        if ($count > 0) {
            echo json_encode(array("status" => "success"));
        } else {
            echo json_encode(array("status" => "failure"));
        }
    }
    return $count;
}




function deleteFile($dir, $imagename)
{
    if (file_exists($dir . "/" . $imagename)) {
        unlink($dir . "/" . $imagename);
    }
}

function checkAuthenticate()
{
    if (isset($_SERVER['PHP_AUTH_USER'])  && isset($_SERVER['PHP_AUTH_PW'])) {
        if ($_SERVER['PHP_AUTH_USER'] != "wael" ||  $_SERVER['PHP_AUTH_PW'] != "wael12345") {
            header('WWW-Authenticate: Basic realm="My Realm"');
            header('HTTP/1.0 401 Unauthorized');
            echo 'Page Not Found';
            exit;
        }
    } else {
        exit;
    }

    // End 
}
// ✅ دالة تسجيل مستخدم جديد
function registerUser($email, $password, $name) {
    global $con;

    // التحقق مما إذا كان البريد الإلكتروني موجودًا بالفعل
    $checkUser = getAllData("users", "email = ?", [$email], false);
    if (is_array($checkUser) && count($checkUser) > 0) {
        echo json_encode(["status" => "error", "message" => "البريد الإلكتروني مستخدم بالفعل"]);
        return;
    }

    // إدخال المستخدم الجديد
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    $data = [
        "name" => $name,
        "email" => $email,
        "password" => $hashedPassword,
    ];
    
    $result = insertData("users", $data, false);
    if ($result > 0) {
        echo json_encode(["status" => "success", "message" => "تم إنشاء الحساب بنجاح"]);
    } else {
        echo json_encode(["status" => "error", "message" => "فشل إنشاء الحساب"]);
    }
}

// ✅ دالة تسجيل الدخول
function loginUser($email, $password) {
    global $con;

    // جلب بيانات المستخدم
    $user = getAllData("users", "email = ?", [$email], false);
    if (!is_array($user) || count($user) == 0) {
        echo json_encode(["status" => "error", "message" => "البريد الإلكتروني غير مسجل"]);
        return;
    }

    // التحقق من كلمة المرور
    $user = $user[0]; // أول سجل
    if (password_verify($password, $user["password"])) {
        echo json_encode(["status" => "success", "message" => "تم تسجيل الدخول بنجاح", "user" => $user]);
    } else {
        echo json_encode(["status" => "error", "message" => "كلمة المرور غير صحيحة"]);
    }
}