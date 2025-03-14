import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hmaapp2/screen/circular.dart';
import 'style.dart';
import 'package:hmaapp2/services/global_var.dart';
import 'package:hmaapp2/screen/splash-screen.dart';
import 'package:hmaapp2/screen/committee.dart';
import 'package:hmaapp2/screen/event.dart';
import 'package:hmaapp2/screen/contact.dart';
import 'package:hmaapp2/screen/circular.dart';
import 'package:hmaapp2/screen/rollOfHonour.dart';
import 'package:hmaapp2/screen/importantContact.dart';
import 'package:hmaapp2/screen/about_us.dart';
import 'package:hmaapp2/screen/contact_us.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hmaapp2/screen/event_det.dart';
import 'package:hmaapp2/screen/member_product_search.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'pdf_Viewer_Page.dart';
class Home extends StatefulWidget {
  static String id='home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List announcements = [];
  List events = [];
  List circulars = [];
  bool dataLoad = false;


  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/front_home.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        announcements = data['announce'];
        events = data['gallery'];
        circulars = data['circular'];
        dataLoad = true;
        print('After initialize : ');
        print( dataLoad);
        //print(events);
      });
    }
  }






  //List<bool> isDownloadingList = [];















  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(dataLoad);
    if(loadScreen=='No')
    {
      setState(() {
        loadScreen='Loaded';
        print('Splash Screen Load');
      });


      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, SplashScreen.id);
      });


    }
    else
      {
        fetchData();
        print(dataLoad);
      }

  }


  @override
  Widget build(BuildContext context) {
    final title = 'HMA Siliguri';

    void _launchPrivilegeCard(String urlString) async {
      Uri url = Uri.parse(urlString); // Convert String to Uri
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlString';
      }
    }


    return SafeArea(
        child: Scaffold(
          extendBody: true,

          bottomNavigationBar: GNav(
             padding: EdgeInsets.all(10.0),
                backgroundColor: Colors.black.withOpacity(0.5),
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800.withOpacity(0.8),
                gap: 8.0,
                tabMargin: EdgeInsets.all(1.0),

               onTabChange: (index) {
                 switch (index) {
                   case 0:
                     Navigator.pushNamed(context, '/');
                     break;
                   case 1:
                     Navigator.pushNamed(context, Circular.id);
                     break;
                   case 2:
                     Navigator.pushNamed(context, Event.id);
                     break;
                   case 3:
                     Navigator.pushNamed(context, ContactUs.id);
                     break;
                 }
               },

                tabs: [
              GButton(icon: FontAwesomeIcons.house, text: 'Home',),
              GButton(icon: FontAwesomeIcons.bullhorn, text: 'Circular',),
              GButton(icon: FontAwesomeIcons.cakeCandles, text: 'Event',),
              GButton(icon: FontAwesomeIcons.mapPin, text: 'Contact',),
            ]),

          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
pinned: true,
                stretch: false,
                floating: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                        "$title",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ) //TextStyle
                    ), //Text
                    background: Image.asset(
                      "images/building-background.png",
                      fit: BoxFit.cover,
                    ) //Images.network
                ), //FlexibleSpaceBar
                backgroundColor: Color(0XFF292c31).withOpacity(0.5),
                leading: IconButton(
                  icon: Icon(Icons.menu,
                  color: Colors.white,
                  ),
                  tooltip: 'Menu',
                  onPressed: () {},
                ), //IconButton
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.account_circle,
                    size: 30.0,
                    color: Colors.white,
                    ),
                    tooltip: 'Setting Icon',
                    onPressed: () {},
                  ), //IconButton
                ], //<Widget>[]
              ), //SliverAppBar
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFecedff)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                              color: Color(0XFFecedff),
                              child: Column(
                                children: [
                                  dataLoad?buildAnnouncements():buildLoadingWidget(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTap:(){
                                                  print('ON Committee Page');
                                                  Navigator.pushNamed(context, Committee.id);
                                                },
                                                child: HomeMainTopic(name: 'Executive\nMembers', icon: FontAwesomeIcons.solidHandshake, iconColor: Color(0XFF5d5d01),)),
                                            GestureDetector(
                                              onTap: (){
                                                print('ON Event Page');
                                                Navigator.pushNamed(context, Event.id);
                                              },
                                                child: HomeMainTopic(name: 'Event &\nActivities', icon: FontAwesomeIcons.cakeCandles, iconColor: Color(0XFFd9480f),)
                                            ),
                                            GestureDetector(
                                                onTap: (){
                                                  Navigator.pushNamed(context, Circular.id);
                                                },
                                                child: HomeMainTopic(name: 'Circular', icon: FontAwesomeIcons.bullhorn, iconColor: Color(0XFF11518a),)),
                                            GestureDetector(
                                                onTap: (){
                                                  print('Roll Of Honour');
                                                  Navigator.pushNamed(context, Rollofhonour.id);
                                                },
                                                child: HomeMainTopic(name: 'Roll Of\nHonour', icon: FontAwesomeIcons.award, iconColor: Color(0XFF343148),)),


                                          ],
                                        ),
                                        SizedBox(height: 15.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTap: (){
                                                  Navigator.pushNamed(context, AboutUs.id);
                                                },
                                                child: HomeMainTopic(name: 'About Us', icon: FontAwesomeIcons.peopleGroup, iconColor: Color(0XFFe67700),)),
                                           GestureDetector(
                                               onTap: (){
                                                 print('Member Directory');
                                                 Navigator.pushNamed(context, MemberProductSearch.id);
                                               },
                                               child: HomeMainTopic(name: 'Member\nDirectory', icon: FontAwesomeIcons.addressBook, iconColor: Color(0XFF5e8a1a),)),
                                            GestureDetector(
                                                onTap: (){
                                                  Navigator.pushNamed(context, ContactUs.id);
                                                },
                                                child: HomeMainTopic(name: 'Contact Us', icon: FontAwesomeIcons.locationDot,  iconColor: Color(0XFFff2500),)),
                                            GestureDetector
                                              (
                                              onTap: (){
                                                Navigator.pushNamed(context, ImportantContact.id);
                                              },
                                                child: HomeMainTopic(name: 'Important\nContact', icon: FontAwesomeIcons.squarePhone,  iconColor: Color(0XFF1864ab),)
                                            ),
                                          ],
                                        ),
                                      ],

                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      _launchPrivilegeCard('https://hmasiliguri.org/privilege-card/');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Color(0XFFfffece),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: EdgeInsets.only(bottom: 15.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/privilage.gif",
                                            width: 200.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text('Privilege Card',
                                                  style:
                                                  TextStyle(
                                                    fontFamily: 'Great Vibes',
                                                    fontWeight: FontWeight.bold, fontSize: 27.0, height: 1.0, color: Color(0XFFb07e16), ),  textAlign: TextAlign.center,   ),
                                                Text('HMA Siliguri offers privilege cards  to its members.', textAlign: TextAlign.center,)
                                              ],
                                            ),
                                          )



                                        ],
                                      ),
                                    ),
                                  ),
                                  dataLoad?buildEvents():buildLoadingWidget(),


                                 /*
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0
                                            ),
                                            borderRadius: BorderRadius.circular(15),
                                            color: Color(0XFFf5f5fc)
                                          ),
                                         margin: EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "images/store-icon.png",
                                                width: 130.0,
                                               ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Merchant', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16.0),),
                                                  Text(' Login', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF434c5e), fontSize: 16.0),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                                width: 2.0
                                            ),
                                            color: Color(0XFFf5f5fc),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          margin: EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "images/customer-icon.png",
                                                width: 130.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Customer', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16.0),),
                                                  Text(' Login', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF434c5e), fontSize: 16.0),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),



                                      ],
                                    ),
                                  ),
                                 */



                                  dataLoad?buildCirculars():buildLoadingWidget(),
                                ],
                              ),
                            ),


                          ],



                        ),


                      ),

                  childCount: 1,
                ), //SliverChildBuildDelegate
              ) //SliverList
            ], //<Widget>[]
          )
        )
    );
  }

  Widget buildEvents() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 35.0),
      decoration: BoxDecoration(
        color: Color(0XFFffffff),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          Text('Events & Activities',
              style: TextStyle(
                fontFamily: 'Great Vibes',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Color(0XFFb07e16),
              )),
          Container(
            height: 250.0,
            child: ListView.builder(
              itemCount: events.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                   print(events[index]['album_name']);
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => EventDet(event_id: events[index]['album'],)),
                   );
                  },
                  child: Container(
                    width: 200.0,
                    margin: EdgeInsets.all(5.0),
                    color: Color(0XFF434c5e).withOpacity(0.2),
                    child: Column(
                      children: [
                        Image.network(
                          events[index]['album_image'],
                          height: 160.0,
                          width: 200.0,
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: Text(
                            events[index]['album_name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF434c5e)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCirculars() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text('Latest Circulars',
              style: TextStyle(
                fontFamily: 'Great Vibes',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Color(0XFFb07e16),
              )),
          Container(
            height: 400.0,
            child: ListView.builder(
              itemCount: circulars.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(10.0),
                  color: Color(0XFFf4f5f6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(FontAwesomeIcons.solidFilePdf, color: Colors.red, size: 40.0),
                        title: Text(
                          'Circular No. ${circulars[index]['circular_no']} | Date : ${circulars[index]['circular_date']}',
                          style: TextStyle(color: Color(0XFF303038), fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(circulars[index]['description']),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.download),
                          label: Text("Download"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFViewerPage(pdfUrl: circulars[index]['img_url']),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Change background color to red
                            foregroundColor: Colors.white, // Change text color to white
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnnouncements() {
    return Column(
      children: announcements.map((announcement) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(bottom: 15.0),
          child: Column(
            children: [
              if (announcement['img_url'] != null && announcement['img_url'].isNotEmpty)
                Image.network(
                  announcement['img_url'],
                  height: 400.0,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ListTile(
                leading: Icon(Icons.notifications_active),
                title: Text(
                  announcement['name'],
                  style: TextStyle(color: Color(0XFF303038), fontWeight: FontWeight.bold),
                ),
                subtitle: Text(announcement['description']),
                onTap: () {},
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10.0),
          Text("Loading...", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

}
class GalleryCard extends StatelessWidget {
  const GalleryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      width: 50,
      color: Colors.red,

    );
  }
}
class HomeMainTopic extends StatelessWidget {

  const HomeMainTopic({
  required this.name,
    required this.icon,
    required this.iconColor,
    super.key,
  });
  final String name;
  final IconData icon;
  final iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(  child:
    Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0XFFecefff),
            radius: 20, 
            child: Center(child: Icon(icon, size: 22.0, color: iconColor,))
        ),
        Text(name.toString(), textAlign: TextAlign.center, ),
      ],
    ),

    width: frtContHeight,
    );
  }
}