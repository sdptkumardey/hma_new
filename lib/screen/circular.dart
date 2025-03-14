import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pdf_Viewer_Page.dart';

class Circular extends StatefulWidget {
  static String id = 'circular';
  @override
  State<Circular> createState() => _CircularState();
}

class _CircularState extends State<Circular> {
  late Future<List<CircularApi>> futCirculars;

  Future<List<CircularApi>> getPostApi() async {
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/circular.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body.toString());
      return data.map((json) => CircularApi.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    futCirculars = getPostApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0XFF155a99),
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<CircularApi>>(
                future: futCirculars,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitRotatingCircle(color: Colors.blueAccent, size: 50.0),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    List<CircularApi> circulars = snapshot.data!;

                    return ListView.builder(
                      itemCount: circulars.length,
                      itemBuilder: (context, index) {
                        final circular = circulars[index];

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 15.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Circular No : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    SizedBox(width: 3.0),
                                    Text(circular.circularNo,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(circular.circularDate, style: TextStyle(fontSize: 14, color: Colors.grey)),
                                SizedBox(height: 10),
                                Text(circular.description,
                                    style: TextStyle(fontSize: 14, color: Colors.black87),
                                    softWrap: true),
                                SizedBox(height: 10),
                                if (circular.imgUrl.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewerPage(pdfUrl: circular.imgUrl),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0XFFff2500),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.picture_as_pdf, color: Colors.white, size: 15.0),
                                          SizedBox(width: 8.0),
                                          Text("View PDF", style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ✅ Separate PDF Viewer Screen


// ✅ CircularApi Model Class
class CircularApi {
  final String circularNo;
  final String circularDate;
  final String description;
  final String imgUrl;

  CircularApi({
    required this.circularNo,
    required this.circularDate,
    required this.description,
    required this.imgUrl,
  });

  factory CircularApi.fromJson(Map<String, dynamic> json) {
    return CircularApi(
      circularNo: json['circular_no'] ?? '',
      circularDate: json['circular_date'] ?? '',
      description: json['description'] ?? '',
      imgUrl: json['img_url'] ?? '',
    );
  }
}
