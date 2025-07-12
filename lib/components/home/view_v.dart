import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:project_code/components/web_api/cat_api.dart';
import 'package:project_code/components/web_api/geo_location.dart';
import 'package:project_code/components/web_api/weather_api.dart';

class View_V extends StatefulWidget {
  const View_V({super.key});

  @override
  State<View_V> createState() => _View_VState();
}

class _View_VState extends State<View_V> {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
