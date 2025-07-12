
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:project_code/components/constants/string_web.dart';
import 'package:project_code/components/web_view/web_view.dart';

class View_H extends StatefulWidget {
  const View_H({super.key});

  @override
  State<View_H> createState() => _View_HState();
}

class _View_HState extends State<View_H> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(IconlyLight.arrow_left_square),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2, //กำหนดคอลัมน์ 2
          crossAxisSpacing: 18, //ระยะห่างคอลัมน์
          mainAxisSpacing: 18, //ระยะห่างระหว่างแถม
                      children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Web_View(web: Strings.web_flutter))),
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
                              builder: (context) => Web_View(web: Strings.web_site))),
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
                              builder: (context) => Web_View(web: Strings.facebook))),
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
                              builder: (context) => Web_View(web: Strings.yuotube))),
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
                              builder: (context) => Web_View(web: Strings.line))),
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
                              builder: (context) => Web_View(web: Strings.tiktok))),
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
    );
  }
}
