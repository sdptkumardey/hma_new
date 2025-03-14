import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../Models/ContactUsApi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUs extends StatefulWidget {
  static String id = 'contact_us';
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late Future<List<ContactUsApi>> fut_inst;
  List<ContactUsApi> postList = [];

  Future<List<ContactUsApi>> getPostApi() async {
    postList = [];
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/committee2.php'));

    // Debugging info
    print("Status Code: ${response.statusCode}");
    print("Headers: ${response.headers}");
    print("Response Body: ${response.body.substring(0, 100)}"); // Print first 100 chars

    // Check if the response is JSON
    if (response.headers['content-type']?.contains('application/json') ?? false) {
      try {
        var data = jsonDecode(response.body);
        if (data is List) {
          postList = data.map((json) => ContactUsApi.fromJson(json)).toList();
        }
      } catch (e) {
        print("JSON Parsing Error: $e");
      }
    } else {
      print("Error: API did not return JSON. Possible redirection or HTML response.");
    }

    return postList;
  }









  @override
  void initState() {
    super.initState();
    fut_inst = getPostApi();
  }


  makingPhoneCall(phone) async {
    var url = Uri.parse("tel:"+phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sendingMails(email) async {
    var url = Uri.parse("mailto:$email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendEmail(email){
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'CallOut user Profile',
        'body':  ''
      },
    );
    launchUrl(emailLaunchUri);
  }
  void sendWhatsapp(num){
    var url = Uri.parse("https://wa.me/$num");
    launchUrl(url);
  }

  textMe(String m) async {
    // Android
    var uri = "sms:+$m?body=hello%20there";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:$m?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFc6cedf),
      appBar: AppBar(
        title: Text('Contact Us', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0XFF155a99),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('HMA City Office',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0XFF0b7285))),
                  ),
                  Text('Smriti Dham, 1st Floor\nSevoke Road, Siliguri-734001',
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      makingPhoneCall('0353-2777307');
                    },
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green, size: 18.0),
                        SizedBox(width: 5.0),
                        Text('0353-2777307',
                            style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('HMA Centre',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0XFF0b7285))),
                  ),
                  Text('Uday Shankar Sarani\nSiliguri - 734001( West Bengal )',
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      makingPhoneCall('0353-2777707');
                    },
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green, size: 18.0),
                        SizedBox(width: 5.0),
                        Text('0353-2777707',
                            style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder<List<ContactUsApi>>(
              future: fut_inst,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SpinKitCircle(color: Colors.blue));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contact data available'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),  // Prevents nested scrolling conflicts
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var contact = snapshot.data![index];
                      return Container(

                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                clipBehavior: Clip.none, // Allows the CircleAvatar to overflow
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFffffff),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26, // Shadow color
                                          blurRadius: 10, // Spread of the shadow
                                          spreadRadius: 2, // Intensity of the shadow
                                          offset: Offset(4, 4), // X and Y position of the shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10), // Optional: Adds rounded corners
                                    ),
                                    padding: EdgeInsets.fromLTRB(0, 50.0, 0, 10.0),
                                    margin: EdgeInsets.fromLTRB(0, 55.0, 0, 0), // Creates space for CircleAvatar

                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          contact.postName ?? '',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0XFF0b7285),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(
                                          contact.name ?? '',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0XFF000000),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        if (contact.address!.isNotEmpty) Text(contact.address.toString(),  textAlign: TextAlign.center,),
                                        if (contact.phone!.isNotEmpty) Text(contact.phone.toString(),  textAlign: TextAlign.center,),
                                        if (contact.mobile!.isNotEmpty)
                                          GestureDetector(
                                            onTap:(){







                                              showModalBottomSheet<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return SizedBox(
                                                    height: 200,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: (){
                                                                  makingPhoneCall(contact.mobile.toString());
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Icon(FontAwesomeIcons.squarePhone, color: Colors.green, size: 50.0, ),
                                                                    Text('Call', style: TextStyle(fontSize: 14.0),)
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 15.0,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  sendWhatsapp(contact.mobile.toString());
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Icon(FontAwesomeIcons.squareWhatsapp, color: Colors.green, size: 50.0,),
                                                                    Text('WhatsApp', style: TextStyle(fontSize: 14.0),)
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 15.0,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  textMe(contact.mobile.toString());
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Icon(FontAwesomeIcons.commentDots, color: Colors.green, size: 50.0,),
                                                                    Text('SMS', style: TextStyle(fontSize: 14.0),)
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );















                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.phone, color: Colors.green, size: 15.0),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  contact.mobile.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF525e7e)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (contact.email!.isNotEmpty)
                                          GestureDetector(

                                            child: Text(
                                              contact.email.toString(),
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                            onTap: (){
                                              sendEmail(contact.email);
                                            },
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Centered CircleAvatar with a border
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(3), // Space for border effect
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 3.0,
                                        ),
                                      ),
                                      child: Container(
                                        width: 90, // Keep the size consistent with the previous CircleAvatar
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(contact.imgUrl.toString()),
                                            fit: BoxFit.cover, // Zoom effect on the image
                                            alignment: Alignment.center, // Keep the focus at the center
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),

    );
  }
}
