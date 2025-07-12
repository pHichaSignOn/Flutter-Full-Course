import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';

class Geo_Location extends StatefulWidget {
  const Geo_Location({super.key});

  @override
  State<Geo_Location> createState() => _Geo_LocationState();
}

class _Geo_LocationState extends State<Geo_Location> {
  String _currentLocation = ''; // ตัวแปรเก็บตำแหน่งปัจจุบัน
  String lat = ''; // ตัวแปรเก็บค่าละติจูด
  String long = ''; // ตัวแปรเก็บค่าลองจิจูด

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
      lat = "ละติจูด: ${position.latitude}"; // กำหนดค่าละติจูด
      long = "ลองติจูด: ${position.longitude}"; // กำหนดค่าลองจิจูด
    });
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
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Center(
                child: Text(
                  lat,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: Text(
                  long,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
        ],
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
