import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/importantContactApi.dart';
import 'package:url_launcher/url_launcher.dart';
class ImportantContact extends StatefulWidget {
  static String id = 'important_contact';

  @override
  State<ImportantContact> createState() => _ImportantContactState();
}


class _ImportantContactState extends State<ImportantContact> {
  late Future<List<PhoneBook>> phoneBookData;
  Future<List<PhoneBook>> fetchPhoneBook() async {
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/important_contact.php'));
    if (response.statusCode == 200) {
      return PhoneBook.fromJsonList(response.body);
    } else {
      throw Exception('Failed to load phone book data');
    }
  }
  makingPhoneCall(phone) async {
    var url = Uri.parse("tel:"+phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void initState() {
    super.initState();
    phoneBookData = fetchPhoneBook();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Important Contact',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0XFF155a99),
      ),
      body: FutureBuilder<List<PhoneBook>>(
        future: phoneBookData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return ExpansionTile(
                  title: Text(
                    category.category,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: category.phoneBookDetails.map((detail) {
                    return ListTile(
                      title: Text(detail.subject, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF0b7285))),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detail.phoneNumbers
                            .map((phone) => GestureDetector(
                          onTap: (){
                            makingPhoneCall(phone.phone);
                          },
                          child: Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.green, size: 15.0,),
                                  SizedBox(width: 5.0,),
                                  Text(phone.phone, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ))
                            .toList(),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
