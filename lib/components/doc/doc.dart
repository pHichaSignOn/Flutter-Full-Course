import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:project_code/components/doc/doc_view.dart';

class Doc extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //กดปุ่ม onPressed แลัว Drawer ไม่ทำงาน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      body: Doc_View(),
      drawer: Drawer(
        elevation: 10.0, //เพิ่มเงาให้ Drawer
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text("Code Project"),
              accountEmail: const Text("เรียนรู้การเขัยนโค้ด"),
              decoration: const BoxDecoration(color: Colors.orange),
              currentAccountPicture: Container(
                child: const Image(
                  image: AssetImage('./android/assets/image/app.png'),
                ),
              ),
            ),
            ListTile(
              title: const Text("ตั้งค่า"),
              onTap: () {
                Navigator.pop(context); //ปิด Drawer ถอยหลัง 1 ค่า
              },
              leading: const Icon(IconlyBold.setting),
              trailing: const Icon(IconlyLight.arrow_right_circle),
            ),
            const Divider(
              height: 10,
            ),
            ListTile(
              title: const Text("เกี่ยวกับระบบ"),
              onTap: () {
                Navigator.pop(context); //ปิด Drawer ถอยหลัง 1 ค่า
              },
              leading: const Icon(IconlyBold.star),
              trailing: const Icon(IconlyLight.arrow_right_circle),
            ),
            const Divider(
              height: 10,
            ),
            ListTile(
              title: const Text("ออกจากระบบ"),
              onTap: () {
                _exitAlertDialog(context); //ปิดแอป
              },
              leading: const Icon(IconlyBold.logout),
              trailing: const Icon(IconlyLight.arrow_right_circle),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(IconlyBold.category),
        color: Colors.white,
        onPressed: () => _scaffoldKey.currentState?.openDrawer(), //เปิด Drawer 
      ),
      centerTitle: true,
      title: const Text("Doc",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero, //ด้านบนซ้าย
          topRight: Radius.zero, //ด้ายบนขวา
          bottomLeft: Radius.circular(30), //ล่างซ้าย
          bottomRight: Radius.circular(30), //ล่างขวา
        ),
      ),
      backgroundColor: Colors.orange.withOpacity(0.6),
      actions: [
        IconButton(
          icon: const Icon(IconlyBold.logout),
          color: Colors.white,
           onPressed: () => _exitAlertDialog(context), //ปิดแอป
        )
      ],
    );
    
  } 
  void _exitAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "อกกจากระบบ !!!",
            style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontFamily: "Alike",
                fontWeight: FontWeight.w500),
          ),
          content: const Text(
            "คุณต้องการที่จะออกจากระบบ หรือไม่",
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: "Alike",
                fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            Row(children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                ),
                child: const Text(
                  "ไม่",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context, true), //ถอยหลัง 1 ค่า
              ),
              const Spacer(), // เพื่อดันปุ่มไปชิดขวา
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                ),
                child: const Text(
                  "ใช้",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                onPressed: () => exit(0), //ถอยหลัง 1 ค่า
              ),
            ]),
          ],
        );
      },
    );
  }
}
