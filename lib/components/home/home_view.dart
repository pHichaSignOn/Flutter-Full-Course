import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:project_code/components/constants/string_web.dart';
import 'package:project_code/components/home/view_h.dart';
import 'package:project_code/components/home/view_v.dart';
import 'package:project_code/components/web_api/cat_api.dart';
import 'package:project_code/components/web_api/geo_location.dart';
import 'package:project_code/components/web_api/weather_api.dart';
import 'package:project_code/components/web_view/web_view.dart';

class Home_View extends StatefulWidget {
  const Home_View({super.key});

  @override
  State<Home_View> createState() => _Home_ViewState();
}

class _Home_ViewState extends State<Home_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          //แนวนอน
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 10.0), //ระยะห่าง padding
            child: Row(
              children: [
                const Text(
                  'เว็บแนะนำ',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const Spacer(), //ดันให้ไปอยู่ชิดขวา
                IconButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => View_H(),
                      ),
                    ),
                  },
                  icon: const Icon(IconlyBroken.more_square),
                ),
              ],
            ),
          ),
          //เนื้อหาเลื่อนแนวนอน
          Container(
            height: 200, //ความสูง
            //เลื่อนดูเนื้อหาได้
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, //แนวนอน
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, //ด้านบนแนว
                mainAxisAlignment: MainAxisAlignment.start, //ด้านบน
                children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Web_View(web: Strings.web_flutter))),
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            './android/assets/image/flutter.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'WebSite Flutter',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Web_View(web: Strings.web_site))),
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            './android/assets/image/app.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'WebSite',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Web_View(web: Strings.facebook))),
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            './android/assets/image/facebook.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'facebook',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Web_View(web: Strings.yuotube))),
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            './android/assets/image/youtube.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'youtube',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Web_View(web: Strings.line))),
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            './android/assets/image/line.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'line',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Web_View(web: Strings.tiktok))),
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            './android/assets/image/tiktok.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'tiktok',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //แนวตั้ง
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 10.0), //ระยะห่าง padding
            child: Row(
              children: [
                const Text(
                  'แนวตั้ง',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const Spacer(), //ดันให้ไปอยู่ชิดขวา
                IconButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => View_V(),
                      ),
                    ),
                  },
                  icon: const Icon(IconlyBroken.more_square),
                ),
              ],
            ),
          ),
          //เนื้อหาเลื่อนแนวตั้ง
          Expanded(
            //เลื่อนดูเนื้อหาได้
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, //แนวนอน
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //ด้านบนแนว
                mainAxisAlignment: MainAxisAlignment.start, //ด้านบน
                children: [
                  //Cat & Dog
                  GestureDetector(
                    //เป็น Widget ที่ตรวจจับการกระทำ จะเป็น onTap
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cat_Api()),
                      );
                    },
                    child: Container(
                      width: double
                          .infinity, //กำหนดให้กว้างเท่ากับหน้าจอ Container
                      height: 200,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(1),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              'https://cdn2.thedogapi.com/images/K1Jv9xVsf.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Cat & Dog',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Geo_Locatiom
                  GestureDetector(
                    //เป็น Widget ที่ตรวจจับการกระทำ จะเป็น onTap
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Geo_Location()),
                      );
                    },
                    child: Container(
                      width: double
                          .infinity, //กำหนดให้กว้างเท่ากับหน้าจอ Container
                      height: 200,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(1),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              'https://cdn2.thedogapi.com/images/q7oVAqMPq.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Geo_Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Weather สถาพอากาศ
                  GestureDetector(
                    //เป็น Widget ที่ตรวจจับการกระทำ จะเป็น onTap
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeatherApi()),
                      );
                    },
                    child: Container(
                      width: double
                          .infinity, //กำหนดให้กว้างเท่ากับหน้าจอ Container
                      height: 200,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(1),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              'https://cdn2.thedogapi.com/images/5szUvAf52.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Weather',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
