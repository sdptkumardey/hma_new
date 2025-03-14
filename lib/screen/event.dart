import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hmaapp2/Models/EventApi.dart';
import 'package:hmaapp2/screen/event_det.dart';

class Event extends StatefulWidget {
  static String id = 'event';

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  late Future<List<EventApi>> futEvent;
  Future<List<EventApi>> getPostApi() async {
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/event.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body.toString());
      return data.map((json) => EventApi.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futEvent = getPostApi();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event & Activities',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0XFF155a99),
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<EventApi>>(
                future: futEvent,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitRotatingCircle(
                        color: Colors.blueAccent,
                        size: 50.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    List<EventApi> event = snapshot.data!;


                    return ListView.builder(
                      itemCount: event.length,
                      itemBuilder: (context, index) {
                        final circular = event[index];

                        return GestureDetector(
                          onTap: (){
                            print(circular.album);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EventDet(event_id: circular.album,)),
                            );
                          },
                          child: Container(
                            height: 270,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                              image: DecorationImage(
                                image: NetworkImage(circular.albumImage as String),
                                fit: BoxFit.cover, // Zoom effect on the image
                                alignment: Alignment.center, // Keep the focus at the center
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.7), // Adjust opacity here
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      circular.albumName as String,
                                      style: TextStyle(
                                        fontSize: 18  ,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                         circular.numImage as String,
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                                      Text(
                                        ' Images',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  ),



                                ],
                              ),
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
