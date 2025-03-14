import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/CommitteeApi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Committee extends StatefulWidget {
  static String id = 'committee';

  @override
  State<Committee> createState() => _CommitteeState();
}

class _CommitteeState extends State<Committee> {
  late Future<CommitteeApi> fut_inst;
  bool showExecutiveCommittee = true; // Flag to switch between committees

  Future<CommitteeApi> getPostApi() async {
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/committee.php'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return CommitteeApi.fromJson(data);
    } else {
      throw Exception('Failed to load data');
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
  void initState() {
    super.initState();
    fut_inst = getPostApi();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFc6cedf),
        appBar: AppBar(
          title: Text(
            'Committee Members',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF155a99),
        ),
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Buttons to switch between Executive and Sub-Committee
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: GestureDetector(
                      onTap: (){
                        setState(() {
                          showExecutiveCommittee = true;
                        });
                      },
                      child: Container(
                       height: 35.0,
                        color:  showExecutiveCommittee? Color(0XFF0b7285):Color(0XFF15aabf),
                        child: Center(child: Text('Committee', style: TextStyle(color: Colors.white, fontWeight:  showExecutiveCommittee? FontWeight.bold : FontWeight.normal),)),
                      ),
                    )),
                    Expanded(child: GestureDetector(
                      onTap: (){
                        setState(() {
                          showExecutiveCommittee = false;
                        });
                      },
                      child: Container(
                        height: 35.0,
                        color: showExecutiveCommittee? Color(0XFF15aabf):Color(0XFF0b7285),
                        child: Center(child: Text('Sub Committee', style: TextStyle(color: Colors.white, fontWeight:  showExecutiveCommittee? FontWeight.normal : FontWeight.bold),)),
                      ),
                    )),


                  ],
                ),
              ),
              SizedBox(height: 20.0,),

              // FutureBuilder to display either committee based on button pressed
              Expanded(
                child: FutureBuilder<CommitteeApi>(
                  future: fut_inst,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SpinKitRotatingCircle(
                        color: Colors.blueAccent,
                        size: 50.0,
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('No data available'));
                    } else {
                      final committee = snapshot.data!;
                      final members = showExecutiveCommittee
                          ? committee.executiveCommittee
                          : committee.executiveSubCommittee;

                      return ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
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
                                              member.postName,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0XFF0b7285),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 5.0),
                                            Text(
                                              member.name,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0XFF000000),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            if (member.address.isNotEmpty) Text(member.address,  textAlign: TextAlign.center,),
                                            if (member.phone.isNotEmpty) Text(member.phone,  textAlign: TextAlign.center,),
                                            if (member.mobile.isNotEmpty)
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
                                                                      makingPhoneCall(member.mobile.toString());
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
                                                                      sendWhatsapp(member.mobile.toString());
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
                                                                      textMe(member.mobile.toString());
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
                                                      member.mobile,
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF525e7e)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (member.email.isNotEmpty)
                                              GestureDetector(

                                                child: Text(
                                                  member.email,
                                                  style: TextStyle(color: Colors.blue),
                                                ),
                                                onTap: (){
                                                  sendEmail(member.email);
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
                                                image: NetworkImage(member.imgUrl),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
