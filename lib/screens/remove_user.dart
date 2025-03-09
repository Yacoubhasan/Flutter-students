import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class RemoveUserScreen extends StatefulWidget {
  @override
  _RemoveUserScreenState createState() => _RemoveUserScreenState();
}

class _RemoveUserScreenState extends State<RemoveUserScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _removeUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });
    final url = Uri.parse(MyApp.baseUrl + 'remove.php');
    final response = await http.post(url, body: {
      'id': _idController.text,
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        setState(() {
          _message = 'تم حذف المستخدم بنجاح!';
        });
      } else {
        setState(() {
          _message = 'فشل حذف المستخدم.';
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
        title: Text('حذف مستخدم',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: inputDecoration('رقم المستخدم'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _removeUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('حذف',
                        style: TextStyle(
                            fontSize: 18, color: Colors.white)),
                  ),
            if (_message.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(_message,
                  style:
                      TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center),
            ]
          ],
        ),
      ),
    );
  }
}
