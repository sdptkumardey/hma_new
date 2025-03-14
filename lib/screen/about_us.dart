import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/aboutUsApi.dart';

class AboutUs extends StatefulWidget {
  static String id = 'about_us';
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  AssociationData? associationData;
  bool isLoading = true;


  bool isExpandedProfile = false;
  bool isExpandedFoundation = false;
  bool isExpandedHistory = false;



  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://hmasiliguri.org/native_app/about_hma.php'); // Replace with actual API endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          associationData = AssociationData.fromJson(jsonData);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0XFF155a99),
      ),
      body: isLoading
          ? Center(
        child: SpinKitFadingCircle(color: Color(0XFF155a99), size: 50.0),
      )
          : associationData == null
          ? Center(child: Text('Failed to load data'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(associationData!.profileTitle,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Color(0XFF0b7285))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Html(data: isExpandedProfile ? associationData!.profileContent : associationData!.profileContent.substring(0, 220) + '...',
                  style: {
                    "p": Style(
                      textAlign: TextAlign.justify,
                    ),
                  },),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpandedProfile = !isExpandedProfile;
                    });
                  },
                  child: Text(isExpandedProfile ? 'Read Less' : 'Read More'),
                ),
              ],
            ),

            SizedBox(height: 20),
            Text(associationData!.foundationTitle,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Color(0XFF0b7285))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Html(data:  isExpandedFoundation ? associationData!.foundationContent : associationData!.foundationContent.substring(0,220)+'...',
                  style: {
                    "p": Style(
                      textAlign: TextAlign.justify,
                    ),
                  },),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpandedFoundation = !isExpandedFoundation;
                    });
                  },
                  child: Text(isExpandedFoundation ? 'Read Less' : 'Read More'),
                ),

              ],
            ),

            if (associationData!.historyTitle.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(associationData!.historyTitle,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Color(0XFF0b7285),)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Html(data: isExpandedHistory ? associationData!.historyContent : associationData!.historyContent.substring(0,220)+'...',
                    style: {
                      "p": Style(
                        textAlign: TextAlign.justify,
                      ),
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpandedHistory = !isExpandedHistory;
                      });
                    },
                    child: isExpandedHistory ?
                      Text('Read Less'):
                        Text('Read More')


                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
