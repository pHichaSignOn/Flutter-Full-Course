import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_code/%20main_menu.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();

    //_timer();
    checkInternetConnection();
  }

    Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      _showToast("Mobile network available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      _showToast("Wi-fi is available.");
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      _showToast("Ethernet connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      _showToast("Vpn connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      _showToast("Bluetooth connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      _showToast("other connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        _showAlertDialog(context, "Error", "No available network types.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.white],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(0.6, 0.5),
          tileMode: TileMode.mirror,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            './android/assets/image/app.png',
            height: 250,
          ),
          const SizedBox(
            height: 50,
          ),
          const SpinKitSpinningLines(
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 12.0);
    _timer();
  }
  void _timer() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Main_Menu(),
              ),
            ));
  }
  void _showAlertDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontFamily: "Alike",
                fontWeight: FontWeight.w500),
          ),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.orange,
                  ),
                ),
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  "Ok",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w500),
                ))
          ],
        );
      },
    );
  }
}