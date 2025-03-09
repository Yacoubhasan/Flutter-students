import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class UpdateStudentScreen extends StatefulWidget {
  @override
  _UpdateStudentScreenState createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _updateStudent() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final url = Uri.parse(MyApp.baseUrl + 'update.php');
    final response = await http.post(url, body: {
      'id': _idController.text,
      'name': _nameController.text,
      'age': _ageController.text,
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _message = (result['status'] == 'success')
            ? '✅ تم تحديث بيانات الطالب بنجاح'
            : '❌ فشل تحديث بيانات الطالب';
      });
    } else {
      setState(() {
        _message = '⚠️ خطأ: ${response.statusCode}';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration _inputDecoration(String label) {
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
        title: Text('تعديل بيانات الطالب'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idController,
              decoration: _inputDecoration('رقم الطالب'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: _inputDecoration('الاسم'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _ageController,
              decoration: _inputDecoration('العمر'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _updateStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('تحديث البيانات',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
            if (_message.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(_message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _message.contains('✅') ? Colors.green : Colors.red,
                      fontSize: 16)),
            ]
          ],
        ),
      ),
    );
  }
}
