import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmaapp2/Models/CommitteeApi.dart';
import 'package:hmaapp2/screen/home.dart';
import 'screen/home_gnav.dart';
import 'package:hmaapp2/screen/splash-screen.dart';
import 'package:hmaapp2/screen/committee.dart';
import 'package:hmaapp2/screen/contact.dart';
import 'package:hmaapp2/screen/circular.dart';
import 'package:hmaapp2/screen/event.dart';
import 'package:hmaapp2/screen/rollOfHonour.dart';
import 'package:hmaapp2/screen/importantContact.dart';
import 'package:hmaapp2/screen/about_us.dart';
import 'package:hmaapp2/screen/contact_us.dart';
import 'package:hmaapp2/screen/member_product_search.dart';
void main() {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD API',
      initialRoute: Home.id,

      routes: {
        Home.id: (context) =>  Home(),
        SplashScreen.id: (context) => SplashScreen(),
        Committee.id:(context) => Committee(),
        MemberProductSearch.id:(context) => MemberProductSearch(),
        Circular.id:(context) => Circular(),
        Contact.id:(context) => Contact(),
        Event.id:(context) => Event(),
        Rollofhonour.id:(context) => Rollofhonour(),
        ImportantContact.id:(context) => ImportantContact(),
        AboutUs.id:(context) => AboutUs(),
        ContactUs.id:(context) => ContactUs()
      },
    );
  }
}

