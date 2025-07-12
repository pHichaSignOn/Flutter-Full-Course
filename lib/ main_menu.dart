import 'dart:io';

import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:project_code/components/doc/doc.dart';
import 'package:project_code/components/home/home.dart';
import 'package:project_code/components/video/video.dart';
import 'package:project_code/components/map/map.dart';

class Main_Menu extends StatefulWidget {
  const Main_Menu({super.key});

  @override
  State<Main_Menu> createState() => _Main_MenuState();
}

class _Main_MenuState extends State<Main_Menu> {
  var _selecttedIndex = 0; //หน้าเริ่มต้น

  final List<Widget> _pages = [
    Home(), //index = 0
    Doc(), //index = 1
    Video(), //index = 2
    Map(), //index = 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selecttedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final _Exit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "ออกจากระบบ !!!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontFamily: "Alike",
                fontWeight: FontWeight.w500,
              ),
            ),
            content: const Text(
              "คุณค้องการออกจากระบบหรือไม่",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: "Alike",
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.red),
                    ),
                    child: const Text(
                      "ไม่",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "Alike",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, false), //ออกจาก AlertDialog
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text(
                      "ใช้",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "Alike",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => exit(0), //ออกจาก AlertDialog
                  ),
                ],
              )
            ],
          ),
        );
        return _Exit ?? false; //หากไม่มีเลือกอะำรเลย return false
      },
      child: Scaffold(
        body: _pages[_selecttedIndex], // แสดงผลหน้าแรก
        bottomNavigationBar: CrystalNavigationBar(
          backgroundColor: Colors.orange.withOpacity(0.6),
          items: <CrystalNavigationBarItem>[
            //index = 0;
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              selectedColor: Colors.white,
              unselectedIcon: IconlyLight.home,
              unselectedColor: Colors.black38,
            ),
            //index = 1;
            CrystalNavigationBarItem(
              icon: IconlyBold.document,
              selectedColor: Colors.white,
              unselectedIcon: IconlyLight.document,
              unselectedColor: Colors.black38,
            ),
            //index = 2;
            CrystalNavigationBarItem(
              icon: IconlyBold.video,
              selectedColor: Colors.white,
              unselectedIcon: IconlyLight.video,
              unselectedColor: Colors.black38,
            ),
            //index = 3;
            CrystalNavigationBarItem(
              icon: IconlyBold.location,
              selectedColor: Colors.white,
              unselectedIcon: IconlyLight.location,
              unselectedColor: Colors.black38,
            ),
          ],
          onTap: _onItemTapped,
          currentIndex: _selecttedIndex,
        ),
      ),
    );
  }
}