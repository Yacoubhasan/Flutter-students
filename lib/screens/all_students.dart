import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class AllStudentsScreen extends StatefulWidget {
  @override
  _AllStudentsScreenState createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  Future<List<dynamic>>? _studentsFuture;

  Future<List<dynamic>> _fetchStudents() async {
    final url = Uri.parse(MyApp.baseUrl + 'all.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        return result['data'];
      } else {
        throw Exception('❌ فشل في جلب بيانات الطلاب');
      }
    } else {
      throw Exception('⚠️ خطأ: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _studentsFuture = _fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جميع الطلاب'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('❌ خطأ: ${snapshot.error}',
                    style: TextStyle(color: Colors.red, fontSize: 16)));
          } else if (snapshot.hasData) {
            final students = snapshot.data!;
            if (students.isEmpty) {
              return Center(
                  child:
                      Text('🚫 لا يوجد طلاب', style: TextStyle(fontSize: 18)));
            }
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(student['id'].toString(),
                          style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(student['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('العمر: ${student['age']}',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[700])),
                    trailing: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                );
              },
            );
          }
          return Center(
              child: Text('🚫 لا توجد بيانات', style: TextStyle(fontSize: 18)));
        },
      ),
    );
  }
}
