import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  bool _emailError = false;
  bool _passwordError = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _message = '';
      _emailError = false;
      _passwordError = false;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        if (_emailController.text.isEmpty) {
          _emailError = true;
        }
        if (_passwordController.text.isEmpty) {
          _passwordError = true;
        }
        _message = 'يرجى ملء جميع الحقول';
        _isLoading = false;
      });
      return; 
    }

    final url = Uri.parse(MyApp.baseUrl + 'login.php');
    final response = await http.post(url, body: {
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _message = result['message'] ?? 'فشل تسجيل الدخول';
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
        title: Text('تسجيل الدخول',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('تسجيل الدخول',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('ليس لديك حساب؟ سجل الآن',
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
