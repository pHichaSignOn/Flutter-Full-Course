import 'dart:convert'; //เพิ่ม ใช้สำหรับการแปลงข้อมูล JSON.
import 'package:flutter/material.dart'; //ไลบรารีหลักของ Flutter สำหรับการสร้าง UI.
import 'package:flutter_map/flutter_map.dart'; //ไลบรารีสำหรับแสดงแผนที่.
import 'package:latlong2/latlong.dart'; //ใช้สำหรับจัดการกับพิกัดละติจูดและลองจิจูด.
import 'package:iconly/iconly.dart'; //ไลบรารีสำหรับไอคอน.
import 'package:flutter_speed_dial/flutter_speed_dial.dart'; //ใช้สำหรับสร้างปุ่มลอย (Floating Action Button) ที่มีเมนูย่อย.
import 'package:geolocator/geolocator.dart'; //ใช้สำหรับดึงตำแหน่งปัจจุบันของอุปกรณ์.
import 'package:http/http.dart'
    as http; //เพิ่ม ใช้สำหรับการเรียก API เพื่อค้นหาตำแหน่งจากชื่อสถานที่.
import 'package:url_launcher/url_launcher.dart'; // ที่ใช้เปิด URL หรือแอปพลิเคชันอื่น เช่น เว็บเบราว์เซอร์, Google Maps, โทรศัพท์, อีเมล และแอปโซเชียลต่าง ๆ
import 'package:shared_preferences/shared_preferences.dart';  //บันทึกค่าที่เลือกไว้ในเครื่อง

//คลาส Map_View
class Map_Fullscreen extends StatefulWidget {
  const Map_Fullscreen({super.key}); // รับ key จาก Parent

  @override
  State<Map_Fullscreen> createState() => _Map_FullscreenState();
}

//คลาส _Map_ViewState
class _Map_FullscreenState extends State<Map_Fullscreen> {
  int _refreshFlag = 0; // เพิ่มตัวแปรสำหรับบังคับรีเฟรช

  void _forceRefresh() {
    setState(() {
      _refreshFlag++; // เพิ่มค่าทุกครั้งที่ต้องการรีเฟรช
    });
  }

  final MapController _mapController = MapController(); // เพิ่ม MapController
  String _mapType = 'streets'; //เก็บประเภทของแผนที่ (streets หรือ satellite).
  LatLng _currentLocation_loading =
      LatLng(13.7563, 100.5018); // พิกัดเริ่มต้น (กรุงเทพ)

  String _currentLocation = ''; // ตัวแปรเก็บตำแหน่งปัจจุบัน
  double lat = 0.0; // ตัวแปรเก็บค่าละติจูด
  double long = 0.0; // ตัวแปรเก็บค่าลองจิจูด

  //เพิ่ม
  String inputText = ''; // เก็บต่ากรอกข้อมูล
  List<Marker> _markers = []; // เก็บต่า Marker
  String _locationMessage = ''; // เก็บต่าข้อความ
  bool _isLoading = false; // สถานะการโหลด

// WMS Layers
  List<String> selectedWmsLayers = [];
  final Map<String, String> _wmsLayerMap = {
    'เขตการปกครอง_กรมการปกครอง': '0',
    'เขตทหาร': '1',
    'แนวเขตป่าสงวนแห่งชาติ': '2',
  };

  // ฟังก์ชันคืนค่า URL ของฟังก์ชัน getTileLayerUrl
  String getTileLayerUrl() {
    return _mapType == 'streets'
        ? "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
        : "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";
  }

  @override
  //ฟังก์ชัน initState
  void initState() {
    super.initState();
    _getCurrentLocation(); // ฟังก์ชันดึงตำแหน่งปัจจุบัน
    _loadSelectedWmsLayers(); // โหลด WMS layers ที่เคยเลือก
  }

  // โหลด WMS layers ที่เคยบันทึกไว้
  Future<void> _loadSelectedWmsLayers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLayers = prefs.getStringList('selectedWmsLayers');
      if (savedLayers != null) {
        setState(() {
          selectedWmsLayers = savedLayers;
        });
      }
    } catch (e) {
      debugPrint('ไม่สามารถโหลด WMS layers ได้: $e');
    }
  }

  // บันทึก WMS layers ที่เลือก
  Future<void> _saveSelectedWmsLayers(List<String> layers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('selectedWmsLayers', layers);
    } catch (e) {
      debugPrint('ไม่สามารถบันทึก WMS layers ได้: $e');
    }
  }

  // ฟังก์ชัน getCurrentLocation ดึงตำแหน่งปัจจุบัน
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
      permission = await Geolocator.requestPermission();
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

    try {
      //ดึงตำแหน่งปัจจุบัน
      Position position = await Geolocator.getCurrentPosition(
        // ดึงตำแหน่งปัจจุบัน
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        lat = position.latitude; // กำหนดค่าละติจูด
        long = position.longitude; // กำหนดค่าลองจิจูด
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error getting location: $e";
        _showAlertDialog(context, "Error", _locationMessage);
      });
    }
  }

  //เมธอด build
  @override
  Widget build(BuildContext context) {
    //Scaffold: เป็นโครงสร้างหลักของหน้า UI.
    return Scaffold(
        extendBodyBehindAppBar: true, // ทำให้ UI อยู่ด้านหลังแถบ AppBar
      appBar: AppBar(
        toolbarHeight: 55.0, // ปรับความสูงของ AppBar ที่นี่
        leading: Container(
          margin: const EdgeInsets.only(left: 10), // ระยะห่างจากขอบซ้าย
          child: Padding(
            padding:
                const EdgeInsets.all(8.0), // เพิ่ม padding ให้ไอคอนอยู่ตรงกลาง
            child: IconButton(
              color: Colors.orange,
              icon: const Icon(
                  IconlyLight.arrow_left_square), // ใช้ Iconly ในการสร้าง Icon
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
        ),
        backgroundColor: Colors.transparent, ////พื้นหลักโปร่งใส
      ),
      //SpeedDial: ปุ่มลอยที่มีเมนูย่อยสำหรับการดำเนินการต่าง ๆ เช่น การย้ายไปยังตำแหน่งปัจจุบัน, การย้ายไปยัง
      floatingActionButton: SpeedDial(
        icon: IconlyBroken.category,
        activeIcon: Icons.close,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(Icons.my_location, color: Colors.white, size: 25),
            label: 'ตำแหน่งปัจจุบัน',
            labelBackgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.orange, fontSize: 16),
            // เพิ่ม
            onTap: () async {
              try {
                // ใช้เพื่อดึงตำแหน่งปัจจุบันของอุปกรณ์
                Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy:
                      LocationAccuracy.high, //กำหนดความแม่นยำสูงสุด
                );

                // อัปเดตตำแหน่งปัจจุบัน
                setState(() {
                  lat = position.latitude;
                  long = position.longitude;
                  _currentLocation_loading = LatLng(lat, long);

                  // เพิ่ม Marker ที่ตำแหน่งปัจจุบัน
                  _markers.add(
                    Marker(
                      point: _currentLocation_loading,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red, // เปลี่ยนสี Marker เป็นสีแดง
                        size: 40,
                      ),
                    ),
                  );

                  // ย้ายแผนที่ไปที่ตำแหน่งปัจจุบัน
                  _mapController.move(_currentLocation_loading, 10.0);
                });
              } catch (e) {
                _showAlertDialog(
                    context, "Error", "Failed to get current location: $e");
              }
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: const Icon(Icons.location_searching,
                color: Colors.white, size: 25),
            label: 'กรุงเทพมหานคร',
            labelBackgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.orange, fontSize: 16),
            onTap: () {
              setState(() {
                _currentLocation_loading = LatLng(13.7563, 100.5018);
                _mapController.move(_currentLocation_loading,
                    16.0); // ไปยังตำแหน่งกรุงเทพมหานคร
              });
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: const Icon(Icons.layers, color: Colors.white, size: 25),
            label: 'ชั้นข้อมูลเขต (WMS)',
            labelBackgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.orange, fontSize: 16),
            onTap: () {
              _showBaseWMS(context);
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(Icons.map, color: Colors.white, size: 25),
            label: 'สลับแผนที่',
            labelBackgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.orange, fontSize: 16),
            onTap: () {
              setState(() {
                _mapType = _mapType == 'streets' ? 'satellite' : 'streets';
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          //Widget สำหรับแสดงแผนที่.
          FlutterMap(
            key: Key('map_$_refreshFlag'), // ใช้ refreshFlag เป็นส่วนหนึ่งของ key
            mapController: _mapController, // ใช้ MapController
            options: MapOptions(
              initialCenter: _currentLocation_loading,
              initialZoom: 6.0, // ใช้ initialZoom แทน zoom ค่าเรื่มต้น
            ),
            children: [
              // ชั้นของแผนที่ที่ใช้ URL จาก getTileLayerUrl.
              TileLayer(
                urlTemplate:
                    getTileLayerUrl(), // ฟังก์ชันที่คืนค่า URL ของ tiles
                subdomains: [
                  'a',
                  'b',
                  'c'
                ], // กำหนดโดเมนย่อยที่ใช้ในการโหลดแผนที่
              ),

              // ใช้สำหรับแสดง Marker บนแผนที่
              MarkerLayer(
                markers: _markers, // รับลิสต์ของ Marker ที่ต้องการแสดง
              ),

              // เพิ่ม WMS Layer ที่เลือก
              if (selectedWmsLayers.isNotEmpty)
                TileLayer(
                  wmsOptions: WMSTileLayerOptions(
                    baseUrl:
                        'https://gistdaportal.gistda.or.th/data/services/EEC_Public/แผนที่เขตการปกครองและแนวเขตต่างๆ/MapServer/WMSServer?',
                    layers: selectedWmsLayers,
                    format: 'image/png',
                    transparent: true,
                    version: '1.1.0',
                    styles: List.filled(selectedWmsLayers.length, ''),
                  ),
                ),
            ],
          ),
          // เพิ่ม
          // โหลดตำแหน่ง Marker บนแผนที่ CircularProgressIndicator
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.orange, // กำหนดสีส้ม
              ),
            ),
          // rotation หมุนแผนที่
          Positioned(
            top: 15.0,
            right: 10.0,
            child: ElevatedButton(
              onPressed: () {
                _mapController.rotate(0.0); // หมุนแผนที่
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // เปลี่ยนสีพื้นหลังของปุ่ม
                shape: const CircleBorder(), // ทำให้ปุ่มเป็นวงกลม
                padding: const EdgeInsets.all(14), // ขนาดของปุ่มวงกลม
              ),
              child:
                  const Icon(Icons.navigation, color: Colors.white, size: 25),
            ),
          ),
          // ปุ่มค้นหา
          Positioned(
            top: 75.0,
            right: 10.0,
            //ปุ่มสำหรับหมุนแผนที่และค้นหาสถานที่.
            child: ElevatedButton(
              onPressed: () {
                _showSearchDialog(context); // การค้นหา
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 25),
            ),
          ),
        ],
      ),
    );
  }

  //ฟังก์ชัน _showAlertDialog
  //ฟังก์ชันนี้ใช้สำหรับแสดง Dialog แจ้งเตือนเมื่อเกิดข้อผิดพลาดหรือต้องการแจ้งข้อมูลให้ผู้ใช้ทราบ.
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
              Spacer(),
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

  // เพิ่ม
  //ฟังก์ชัน _showSearchDialog

  void _showSearchDialog(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "ค้นหา",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontFamily: "Alike",
              fontWeight: FontWeight.w500,
            ),
          ),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              hintText: "กรอกชื่อสถานที่",
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Row(children: [
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                ),
                child: const Text(
                  "ค้นหา",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "Alike",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    inputText = textFieldController.text; // กรอกช้อความ
                    _setsearchpoint(inputText); // รับค่าที่กรอก แล้วค้นหา
                  });
                },
              ),
            ]),
          ],
        );
      },
    );
  }

  // เพิ่ม
  //ฟังก์ชัน _setsearchpoint
  //ฟังก์ชันนี้ใช้สำหรับเรียกฟังก์ชัน _fecthSearchPoint เพื่อค้นหาสถานที่จาก API และปิด Dialog หลังจากนั้น.
  void _setsearchpoint(String inputText) {
    setState(() {
      _fecthSearchPoint(inputText); // ฟังชั้นค้นหา
      Navigator.pop(context, true); // ถอยหนึ่งค่า
    });
  }

  // เพิ่ม
  // ฟังก์ชัน _fecthSearchPoint ฟังชั้นค้นหาผ่าน API
  // ฟังก์ชันนี้ใช้สำหรับเรียก API เพื่อค้นหาสถานที่จากชื่อที่ผู้ใช้กรอก และแสดง Marker บนแผนที่.
  Future<void> _fecthSearchPoint([String? inputText]) async {
    //เช็ตสถานะการโหลด
    setState(() {
      _isLoading = true;
    });

    var client = http.Client(); // สร้าง Client เพื่อเชื่อมต่อ API

    try {
      // ใช้ try catch เพื่อจัดการข้อผิดพลาด //มหาวิทยาลัยขอนแก่น วัดพระแก้ว ส่วนสัตว์เปิดเขาเขียว
      final response = await client.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q="$inputText"'));

      if (response.statusCode == 200) {
        List<dynamic> data =
            json.decode(response.body); // แปลงข้อมูล JSON ให้เป็น List
        // ตรวจสอบสถานะการตอบกลับ

        List<Marker> fetchedSearchMarkers = data.map((point) {
          double latitude = double.parse(point['lat']);
          double longitude = double.parse(point['lon']);

          // ปักหมุด
          return Marker(
            point: LatLng(latitude, longitude),
            width: 80.0,
            height: 80.0,
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                // กดปุ่ม icon แสดงรายละเอียด
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LocationDetailsDialog(
                        point: point); // แสดงแสดงรายละเอียด
                  },
                );
              },
              child: Column(
                children: [
                  Text(
                    point['name'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ],
              ),
            ),
          );
        }).toList();

        setState(() {
          _markers = fetchedSearchMarkers; //แสดงบน MarkerLayer
          _isLoading = false;
        });
      } else {
        // แสดงค่าผิดพลาด
        setState(() {
          _locationMessage = "Error: ${response.statusCode}";
          _showAlertDialog(context, "Error", _locationMessage);
          _isLoading = false;
        });
      }
    } catch (e) {
      // แสดงค่าผิดพลาด try catch
      setState(() {
        _locationMessage = "Error: $e";
        _showAlertDialog(context, "Error", _locationMessage);
        _isLoading = false;
      });
    }
  }

//แผนที่ BaseMap_WMS
  void _showBaseWMS(BuildContext context) {
    final wmsLayers = _wmsLayerMap.keys.toList();

    // สร้าง List ของค่า selected ตามค่าที่มีอยู่ใน selectedWmsLayers
    List<bool> selectedLayers = wmsLayers.map((layer) {
      final layerId = _wmsLayerMap[layer];
      return selectedWmsLayers.contains(layerId);
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'ชั้นข้อมูลเขต (WMS)',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "Alike",
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: wmsLayers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      title: Text(
                        wmsLayers[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Alike",
                        ),
                      ),
                      value: selectedLayers[index],
                      activeColor: Colors.orange, // สีของ checkbox เมื่อติ๊ก
                      checkColor: Colors.white, // สีของเครื่องหมาย ✔ ข้างใน
                      onChanged: (bool? value) {
                        setState(() {
                          selectedLayers[index] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                Row(children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      // เมื่อกดยกเลิก ให้ไม่ทำอะไร
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "ยกเลิก",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "Alike",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text(
                      "ตกลง",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "Alike",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      final selected = <String>[];
                      // ทำงานเมื่อกดตกลง เช่น พิมพ์รายการที่เลือก
                      for (int i = 0; i < wmsLayers.length; i++) {
                        if (selectedLayers[i]) {
                          final id = _wmsLayerMap[wmsLayers[i]];
                          if (id != null) selected.add(id);
                        }
                      }
                      // บันทึกค่าที่เลือก
                      await _saveSelectedWmsLayers(selected);

                      // ส่วนที่แก้ไข - ใช้วิธีนี้เพื่อรีเฟรช
                      if (mounted) {
                         _forceRefresh(); // เรียกเมธอดรีเฟรช
                        setState(() {
                          selectedWmsLayers = selected;
                        });
                        // บังคับรีเฟรช TileLayer
                        _mapController.move(
                          _mapController.camera.center,
                          _mapController.camera.zoom + 0.001,
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                ]),
              ],
            );
          },
        );
      },
    );
  }
}

// เพิ่ม
// คลาส LocationDetailsDialog
// คลาสนี้ใช้สำหรับแสดง Dialog ที่มีรายละเอียดของสถานที่ที่ผู้ใช้เลือก.
class LocationDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> point;

  const LocationDetailsDialog({Key? key, required this.point})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'รายละเอียด',
        style: TextStyle(
          fontSize: 20,
          color: Colors.green,
          fontFamily: "Alike",
          fontWeight: FontWeight.w500,
        ),
      ),
      icon: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
      content: Container(
        constraints: const BoxConstraints(
          maxHeight: 400,
        ),
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                point['name'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontFamily: "Alike",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                point['display_name'],
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 1),
              Text(
                point['type'],
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
              const SizedBox(height: 1),
              // เพิ่ม
              GestureDetector(
                onTap: () {
                  double latitude =
                      double.tryParse(point['lat'].toString()) ?? 0.0;
                  double longitude =
                      double.tryParse(point['lon'].toString()) ?? 0.0;
                  //point['lat'].toString() → แปลงเป็น String ก่อนเพื่อป้องกันข้อผิดพลาด
                  //double.tryParse(...) ?? 0.0 → ลองแปลงเป็น double ถ้าไม่ได้ให้ใช้ค่าเริ่มต้น 0.0
                  //ถ้าข้อมูล lat หรือ lon มาจาก API ให้ตรวจสอบก่อนว่าเป็น String หรือ double
                  _openGoogleMaps(latitude, longitude);
                },
                child: const Text(
                  'Google Map' ':' 'Click',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontFamily: "Alike",
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
              ),
              child: const Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: "Alike",
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ],
    );
  }

  // เพิ่ม
  // google_MAP
  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'ไม่สามารถเปิดแผนที่ได้.';
    }
  }
}
