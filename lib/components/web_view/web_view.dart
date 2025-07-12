import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Web_View extends StatefulWidget {
  final String web;
  const Web_View({super.key, required this.web});

  @override
  State<Web_View> createState() => _Web_ViewState();
}

class _Web_ViewState extends State<Web_View> {
  late final WebViewController _controller;
  bool isLoading = true; //สถานะการโหลอ
  bool IsError = false; //สถานะเกิดผิดพลาด

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          //เริ่มโหลดหน้าเว็บ
          onPageStarted: (String url) {
            setState(() {
              isLoading = true; //เรื่มโหลดเว็บ
              IsError = false; //ข้อผิดพลาด
            });
          },
          //โหลดหน้าเว็บเสร็จแล้ว
          onPageFinished: (String url) {
            setState(() {
              isLoading = false; //โหลดเสร็จแล้ว
            });
          },
          //เกิดข้อผิดพลาด
          onHttpError: (HttpResponseError error) {
            setState(() {
              IsError = true;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              IsError = true; //เกิดข้อผิดพลาด
            });
          },

          // คือ callback ที่ใช้ใน NavigationDelegate
          onNavigationRequest: (NavigationRequest request) {
            if (_checkAppExternal(request.url)) {
              //ตรวจสอบ URL ควรเปิดแอปภายนอกไหม == true
              _launchSocialApp(request.url); //เปิด app
              return NavigationDecision.prevent; //บล็อห webview
            }
            return NavigationDecision.navigate; //ใช้ webview == false
          },
        ),
      )
      ..setUserAgent(
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36')
      ..loadRequest(Uri.parse(widget.web));
  }

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
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            )),
        ],
      ),
    );
  }

  //ตรวจสอบ URL ควรเปิดแอปภายนอกไหม
  bool _checkAppExternal(String url) {
    return url.startsWith('line.me') || //ตรวจสอบ url มีคำว่า line.me
        url.contains('facebook.com') || //ตรวจสอบ url มีคำว่า facebook.com
        url.contains('tiktok.com') || //ตรวจสอบ url มีคำว่า tiktok.com
        url.contains('youtube.com'); //ตรวจสอบ url มีคำว่า youtube.com
  }

  // ฟังก์ชันเปิด URL ภายนอก
  Future<void> _launchSocialApp(String url) async {
    final Uri uri = Uri.parse(url); //เปลี่ยน String ให้ วัตถุประเถท Uri

    //เปืด URL ด้วย launchUrl
    if (!await launchUrl(uri)) {
      debugPrint('ไม่สามารถเปิด URL: $url'); //แสดงขอความเมือเปิด URL ไม่สำเร็จ
    }
  }
}
