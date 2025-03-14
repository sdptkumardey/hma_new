import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart'; // ✅ Replaced open_filex with open_file

class Contact extends StatefulWidget {
  static String id = 'contact';

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  bool isDownloading = false;

  Future<void> downloadPDF(String url, String fileName) async {
    try {
      setState(() {
        isDownloading = true;
      });

      // ✅ Request Storage Permission for Android
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (status.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Storage permission is required")),
          );
          setState(() => isDownloading = false);
          return;
        }
      }

      // ✅ Get the Download Directory
      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() // Android
          : await getApplicationDocumentsDirectory(); // iOS/macOS

      if (directory == null) throw Exception("Failed to get directory");

      String filePath = "${directory.path}/$fileName";
      Dio dio = Dio();

      await dio.download(url, filePath);

      // ✅ Open the file after download
      OpenFile.open(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download completed: $filePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Important Contact', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0XFF155a99),
      ),
      body: Center(
        child: isDownloading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Downloading PDF...", style: TextStyle(fontSize: 16)),
          ],
        )
            : ElevatedButton(
          onPressed: () => downloadPDF(
            "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
            "sample.pdf",
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0XFFff2500),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.file_download, color: Colors.white),
              SizedBox(width: 8.0),
              Text("Download PDF", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
