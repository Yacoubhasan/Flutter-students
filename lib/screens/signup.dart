import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _message = '';

  bool _nameError = false;
  bool _emailError = false;
  bool _passwordError = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
      _message = '';
      _nameError = false;
      _emailError = false;
      _passwordError = false;
    });

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        if (_nameController.text.isEmpty) {
          _nameError = true;
        }
        if (_emailController.text.isEmpty) {
          _emailError = true;
        }
        if (_passwordController.text.isEmpty) {
          _passwordError = true;
        }
        _isLoading = false;
      });
      return; 
    }

    final url = Uri.parse(MyApp.baseUrl + 'signup.php');
    final response = await http.post(url, body: {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _message = result['message'] ?? 'فشل التسجيل';
        });
      }
    } else {
      setState(() {
        _message = 'خطأ: ${response.statusCode}';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل حساب جديد', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: inputDecoration('الاسم'),
            ),
            if (_nameError)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'الاسم مطلوب',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.start,
                ),
              ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: inputDecoration('البريد الإلكتروني'),
            ),
            if (_emailError)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'البريد الإلكتروني مطلوب',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.start,
                ),
              ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: inputDecoration('كلمة المرور'),
              obscureText: true,
            ),
            if (_passwordError)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'كلمة المرور مطلوبة',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.start,
                ),
              ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 150),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('تسجيل',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('هل لديك حساب؟ سجل الآن',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
            ),
            if (_message.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(_message,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center),
            ]
          ],
        ),
      ),
    );
  }
}
