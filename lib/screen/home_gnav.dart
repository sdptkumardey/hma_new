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
import 'package:hmaapp2/screen/home.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart'; // ✅ Updated from open_filex to open_file
class HomeGnav extends StatefulWidget {
  static String id='HomeGnav';

  @override
  State<HomeGnav> createState() => _HomeGnavState();
}

class _HomeGnavState extends State<HomeGnav> {
  int _selectedIndex = 0;

  // List of pages (Each page is a StatefulWidget)
  final List<Widget> _pages = [
    HomePage(), // Replace with your actual Home Page
    Circular(), // Replace with your actual Circular Page
    Event(), // Replace with your actual Event Page
    ContactUs(), // Replace with your actual Contact Page
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Keeps state of all pages
        children: _pages,
      ),
      bottomNavigationBar: GNav(
        padding: EdgeInsets.all(10.0),
        backgroundColor: Colors.black.withOpacity(0.5),
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade800.withOpacity(0.8),
        gap: 8.0,
        tabMargin: EdgeInsets.all(1.0),
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        tabs: [
          GButton(icon: FontAwesomeIcons.house, text: 'Home'),
          GButton(icon: FontAwesomeIcons.bullhorn, text: 'Circular'),
          GButton(icon: FontAwesomeIcons.bullhorn, text: 'Circular 2'),
          GButton(icon: FontAwesomeIcons.cakeCandles, text: 'Event'),
          GButton(icon: FontAwesomeIcons.mapPin, text: 'Contact'),
        ],
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _CircularPageState createState() => _CircularPageState();
}

class _CircularPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Circulars Page', style: TextStyle(fontSize: 24)),
    );
  }
}
