import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/add_user.dart';
import 'screens/remove_user.dart';
import 'screens/update_student.dart';
import 'screens/all_students.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String baseUrl = 'http://10.0.2.2/flutter_app_and_baackend/';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق PHP API مع Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/addUser': (context) => AddUserScreen(),
        '/removeUser': (context) => RemoveUserScreen(),
        '/updateStudent': (context) => UpdateStudentScreen(),
        '/allStudents': (context) => AllStudentsScreen(),
      },
    );
  }
}
