import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;

class WeatherApi extends StatefulWidget {
  const WeatherApi({super.key});

  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  List<dynamic> _hourlyTemperature = []; // ตรวจสอบสถานะการตอบกลับ
  bool _isLoading = true;
  String _ErorMessage = ""; // สร้างตัวแปรเก็บข้อความ Error

  String _currentLocation = ''; // ตัวแปรเก็บตำแหน่งปัจจุบัน
  double lat = 0.0; // ตัวแปรเก็บค่าละติจูด
  double long = 0.0; // ตัวแปรเก็บค่าลองจิจูด

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // ฟังก์ชันดึงตำแหน่งปัจจุบัน
  }

  // ฟังก์ชันดึงตำแหน่งปัจจุบัน
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled; // ตัวแปรเก็บค่าการเปิด Location Services
    LocationPermission permission; // ตัวแปรเก็บค่าสิทธิ์การเข้าถึงตำแหน่ง

    // ตรวจสอบว่า Location Services เปิดอยู่หรือไม่
    serviceEnabled = await Geolocator
        .isLocationServiceEnabled(); // ตรวจสอบว่า Location Services เปิดอยู่หรือไม่
    if (!serviceEnabled) {
      // ถ้า Location Services ปิดอยู่
      setState(() {
        _currentLocation =
            "Location service ปิดอยู่ กรุณาเปิดใช้งาน"; // กำหนดข้อความแจ้งเตือน
        _showAlertDialog(
            context, "ข้อผิดพลาด", _currentLocation); // แสดง Dialog แจ้งเตือน
      });
      return;
    }

    // ตรวจสอบและขอสิทธิ์การเข้าถึงตำแหน่ง
    permission =
        await Geolocator.checkPermission(); // ตรวจสอบสิทธิ์การเข้าถึงตำแหน่ง
    if (permission == LocationPermission.denied) {
      // ถ้าสิทธิ์การเข้าถึงตำแหน่งถูกปฏิเสธ
      permission =
          await Geolocator.requestPermission(); // ขอสิทธิ์การเข้าถึงตำแหน่ง
      if (permission == LocationPermission.denied) {
        // ถ้าสิทธิ์การเข้าถึงตำแหน่งถูกปฏิเสธ
        setState(() {
          _currentLocation =
              "สิทธิ์การเข้าถึงตำแหน่งถูกปฏิเสธ"; // กำหนดข้อความแจ้งเตือน
          _showAlertDialog(
              context, "ข้อผิดพลาด", _currentLocation); // แสดง Dialog แจ้งเตือน
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ถ้าสิทธิ์การเข้าถึงตำแหน่งถูกปฏิเสธถาวร
      setState(() {
        _currentLocation =
            "สิทธิ์การเข้าถึงตำแหน่งถูกปฏิเสธถาวร"; // กำหนดข้อความแจ้งเตือน
        _showAlertDialog(
            context, "ข้อผิดพลาด", _currentLocation); // แสดง Dialog แจ้งเตือน
      });
      return;
    }

    //ดึงตำแหน่งปัจจุบัน
    Position position = await Geolocator.getCurrentPosition(
      // ดึงตำแหน่งปัจจุบัน
      desiredAccuracy: LocationAccuracy.high, // กำหนดความแม่นยำของตำแหน่ง
    );
    setState(() {
      //lat = "ละติจูด: ${position.latitude}"; // กำหนดค่าละติจูด
      //long = "ลองติจูด: ${position.longitude}"; // กำหนดค่าลองจิจูด
      lat = position.latitude; // กำหนดค่าละติจูด
      long = position.longitude; // กำหนดค่าลองจิจูด
    });
    _fetcWeatherData(lat, long);
  }

  // ตรวจสอบอุณหภูมิ
  Future<void> _fetcWeatherData(double lat, double long) async {
    var client = http.Client(); // สร้าง Client เพื่อเชื่อมต่อ API

    try {
      // ใช้ try catch เพื่อจัดการข้อผิดพลาด
      final response = await client.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&hourly=temperature_2m')); // ส่งคำขอ GET ไปยัง API
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // แปลงข้อมูล JSON ให้เป็น List
        // ตรวจสอบสถานะการตอบกลับ

        setState(() {
          _hourlyTemperature = data['hourly']['temperature_2m'];
          _isLoading = false;
          //print(_hourlyTemperature);
        });
      } else {
        // ถ้าไม่สำเร็จ
        setState(() {
          _ErorMessage = "Error: ${response.statusCode}"; // กำหนดข้อความ Error
          _showAlertDialog(
              context, "ข้อผิดพลาด", _ErorMessage); // แสดง Dialog แจ้งเตือน
        });
      }
    } catch (e) {
      // จัดการข้อผิดพลาด
      setState(() {
        _showAlertDialog(context, "ข้อผิดพลาด",
            "ไม่สามารถเชื่อมต่อได้"); // แสดง Dialog แจ้งเตือน
      });
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
        //Conditional Expression (? :): bool
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              )
            : _hourlyTemperature.isNotEmpty
                ? Column(
                    children: [
                      Card(
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 200, // กำหนดความสูงของ Card
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white, // สีพื้นหลังของ Card
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.orange
                                      .withOpacity(0.1), // เงาสีส้ม
                                  offset: Offset(
                                      0, 4), // การเคลื่อนที่ของเงาในแนวดิ่ง
                                  blurRadius: 12, // ความเบลอของเงา
                                  spreadRadius: 2), // ขยายหรือย่อขนาดเงา
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_hourlyTemperature[0]}°C',
                                  style: TextStyle(
                                      fontSize: 70,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'อุณหภูมิในข่วงเวลา 1 ชั่วโมง',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      'No data',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ));
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
