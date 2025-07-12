
import 'package:flutter/material.dart';
import 'package:project_code/components/video/video_fullscreen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video_View extends StatefulWidget {
  // รับ URL ของวิดีโอ YouTube จากภายนอก
  final String web = "https://youtu.be/arGxq2La7Ks?si=HDUH_TEPH5ppQdP0";

  const Video_View({super.key});

  @override
  State<Video_View> createState() => _Video_ViewState();
}

class _Video_ViewState extends State<Video_View> {
  late YoutubePlayerController _controller; // ตัวควบคุมวิดีโอ YouTube
  String? errorMessage; // ข้อความแสดงข้อผิดพลาด
  bool isLoadding = true; // ตัวแปรตรวจสอบสถานะการโหลด

  // ฟังก์ชันตรวจสอบว่า URL เป็นของ YouTube หรือไม่
  bool isValidYoutubeUrl(String url) {
    final RegExp regex = RegExp(
      r'^(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.?be/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    return regex.hasMatch(url);
  }

  @override
  void initState() {
    super.initState();

    // ตรวจสอบว่า URL ที่ได้รับเป็นของ YouTube หรือไม่
    if (isValidYoutubeUrl(widget.web)) {
      // แปลง URL เป็น video ID ของ YouTube
      final String? videoID = YoutubePlayer.convertUrlToId(widget.web);

      // ถ้าได้ video ID ที่ถูกต้อง (ต้องมีความยาว 11 ตัวอักษร)
      if (videoID != null && videoID.length == 11) {
        // สร้างตัวควบคุม YouTube Player
        _controller = YoutubePlayerController(
          initialVideoId: videoID, // ใช้ video ID ที่แปลงจาก URL
          flags: const YoutubePlayerFlags(
            autoPlay: true, // เล่นอัตโนมัติ
            mute: false, // ปิดเสียง
          ),
        );
        // ตั้งค่าฟังก์ชันเพื่อจัดการสถานะการโหลด
        _controller.addListener(() {
          if (mounted) {
            setState(() {
              isLoadding = true; // ถ้าวิดีโอกำลังโหลด
            });
          } else {
            setState(() {
              isLoadding = false; // ถ้าวิดีโอโหลดเสร็จแล้ว
            });
          }
        });
      } else {
        // แสดงข้อความ error ถ้า video ID ไม่ถูกต้อง
        setState(() {
          errorMessage = 'ID หรือ URL วิดีโอ YouTube ไม่ถูกค้อง';
        });
      }
    } else {
      // แสดงข้อความ error ถ้า URL ไม่ถูกต้อง
      setState(() {
        errorMessage = 'URL วิดีโอ YouTube ไม่ถูกค้อง';
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: errorMessage == null // ตรวจสอบว่ามีข้อผิดพลาดหรือไม่
          ? Column(
              children: [
                Expanded(
                    child: YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.green,
                        ),
                        builder: (context, player) {
                          return Column(
                            children: [
                              // Player สำหรับวิดีโอ YouTube
                              player,
                              SizedBox(height: 20),
                              // 'กำลังเล่นวีดีโอ',
                              Text(
                                "กำลังเล่นวีดีโอ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontFamily: "Alike",
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 20),
                              // ปิดหน้าเมื่อกดปุ่ม "ดูแบบ fullscreen"
                              ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Video_Full(web: widget.web),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                child: Text("ดูแบบ fullscreen",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Alike",
                                        color: Colors.white)),
                              ),
                            ],
                          );
                        }))
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'แจ้งเตือน !!!',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontFamily: "Alike",
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'URL Youtube ไม่ถูกต้อง',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontFamily: "Alike",
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
