import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/RollOfHonourApi.dart';

class Rollofhonour extends StatefulWidget {
  static String id = 'roll_of_honour';

  @override
  State<Rollofhonour> createState() => _RollofhonourState();
}

class _RollofhonourState extends State<Rollofhonour> {
  late Future<List<RollOfHonourApi>> fut_inst;

  // Fetch data from API and return a list
  Future<List<RollOfHonourApi>> getPostApi() async {
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/roll_of_honour.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body.toString());
      return data.map((json) => RollOfHonourApi.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fut_inst = getPostApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Roll Of Honour',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0XFF155a99),
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<RollOfHonourApi>>(
                future: fut_inst,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitRotatingCircle(
                        color: Colors.blueAccent,
                        size: 50.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    List<RollOfHonourApi> circulars = snapshot.data!;

                    return ListView.builder(
                      itemCount: circulars.length,
                      itemBuilder: (context, index) {
                        final circular = circulars[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                          padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
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
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildInfoRow("President : ", circular.pPresident),
                                    buildInfoRow("Secretary : ", circular.pSec),
                                    buildInfoRow("Treasurer : ", circular.pTrea),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -25, // Adjust to position correctly
                                left: 0, // Adjust as needed
                                child: Container(


                                  child: Text(circular.pYear.toString(),
                                style: TextStyle(color: Colors.white,
                                 fontSize: 18.0
                                ),
                                                        ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF616d87),
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(5),

                                  ),
                                  padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
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
            )
          ],
        ),
      ),
    );
  }

  // Helper function to build text rows
  Widget buildInfoRow(String title, String? value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0XFF303541),
          ),
        ),
        const SizedBox(width: 3.0),
        Text(
          value ?? 'N/A',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0XFF303541)
          ),
        ),
      ],
    );
  }
}
