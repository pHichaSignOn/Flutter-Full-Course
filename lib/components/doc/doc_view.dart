import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;

class Doc_View extends StatefulWidget {
  const Doc_View({super.key});

  @override
  State<Doc_View> createState() => _Doc_ViewState();
}

class _Doc_ViewState extends State<Doc_View> {
  final String pdfUrl =
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf';

  Future<void> downloadPDF() async {
    try {
      // ดึงข้อมูลไฟล์ PDF จาก URL
      final Response = await http.get(Uri.parse(pdfUrl));

      if (Response.statusCode == 200) {
        // ดึง directory มาเก็บไฟล์
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/flutter-pdfFile.pdf';

        // บันทึกลง PDF ลงเครื่อง
        File file = File(filePath);
        await file.writeAsBytes(Response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ดาวน์โหลดสำเร็จ: $filePath'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("เกิดข้อผิดพลาดในการดาวน์โหลด PDF!!!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("เกิดข้อผิดพลาด: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: IconlyBroken.document,
        activeIcon: Icons.close,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.green,
            child: Icon(IconlyBroken.download, color: Colors.white, size: 25),
            label: 'Download PDF',
            labelBackgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.green, fontSize: 16),
            onTap: downloadPDF,
          )
        ],
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
