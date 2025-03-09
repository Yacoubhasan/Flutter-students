import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _addUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });
    final url = Uri.parse(MyApp.baseUrl + 'add.php');
    final response = await http.post(url, body: {
      'name': _nameController.text,
      'age': _ageController.text,
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        setState(() {
          _message = 'تم إضافة المستخدم بنجاح!';
        });
      } else {
        setState(() {
          _message = 'فشل إضافة المستخدم.';
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
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مستخدم',
            style: TextStyle(color: Colors.white)),
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
            SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: inputDecoration('العمر'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('إضافة',
                        style: TextStyle(
                            fontSize: 18, color: Colors.white)),
                  ),
            if (_message.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(_message,
                  style:
                      TextStyle(color: Colors.green, fontSize: 16),
                  textAlign: TextAlign.center),
            ]
          ],
        ),
      ),
    );
  }
}
