import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_code/components/constants/string_web.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';

class Cat_Api extends StatefulWidget {
  const Cat_Api({super.key});

  @override
  State<Cat_Api> createState() => _Cat_ApiState();
}

class _Cat_ApiState extends State<Cat_Api> {
  List<dynamic> _cat = []; // สร้าง List ของข้อมูล Cat
  String _ErorMessage = ""; // สร้างตัวแปรเก็บข้อความ Error

  @override
  void initState() {
    super.initState();
    _fectheCat(); // เรียกใช้ฟังก์ชัน _fectheCat
  }

  Future<void> _fectheCat() async {
    var client = http.Client(); // สร้าง Client เพื่อเชื่อมต่อ API

    try {
      // ใช้ try catch เพื่อจัดการข้อผิดพลาด
      final response =
          await client.get(Uri.parse(Strings.cat)); // ส่งคำขอ GET ไปยัง API

      if (response.statusCode == 200) {
        // ตรวจสอบสถานะการตอบกลับ
        setState(() {
          _cat = json.decode(response.body); // แปลงข้อมูล JSON ให้เป็น List
        });
      } else {
        // ไม่เป็นจริง
        _ErorMessage = "Error: ${response.statusCode}"; //เอา code มาใช้
        _showAlertDialog(context, "ข้อผิดพลาด", _ErorMessage);
      }
    } catch (e) {
      // จัดการข้อผิดพลาด
      _showAlertDialog(context, "ข้อผิดพลาด", "ไม่สามารถเชื่อมต่อได้");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40, // กำหนดความสูงของ AppBar
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(IconlyLight.arrow_left_square),
        ),
      ),
      body: ListView.builder(
        // ใช้ ListView.builder เพื่อสร้าง List ของข้อมูล
        itemCount: _cat.length, // กำหนดจำนวนข้อมูล
        itemBuilder: (context, index) {
          // สร้าง Item ของ List
          final cat = _cat[index]; // กำหนดตัวแปร cat เพื่อเก็บข้อมูลแต่ละ Item
          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.10),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
              color: Colors.white, //พื้นหลัก
              child: InkWell(
                onTap: () {
                  _fectheCat();
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Image.network(cat['url'],
                          loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          ));
                        }
                      }, width: double.infinity, height: 250),
                    ),
                    SizedBox(height: 30),
                    Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Cat & Dog',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontFamily: "Alike",
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(message),
          actions: <Widget>[
            Row(children: [
              Spacer(), // ใช้ Spacer เพื่อดันปุ่มไปชิดขวา)
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Alike",
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]),
          ],
        );
      },
    );
  }
}
