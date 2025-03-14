import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class MemberProductSearch extends StatefulWidget {
  static String id = 'MemberProductSearch';

  @override
  State<MemberProductSearch> createState() => _MemberProductSearchState();
}

class _MemberProductSearchState extends State<MemberProductSearch> {
  List<dynamic> member = [];
  List<dynamic> filteredMembers = [];
  List<dynamic> category = [];
  bool dataLoad = false;

  TextEditingController searchController = TextEditingController();
  String selectedCategory = "All Categories";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://hmasiliguri.org/native_app/member_directory.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        member = data['member'];
        filteredMembers = List.from(member);
        category = data['category'];
        dataLoad = true;
      });
    }
  }

  void filterResults() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMembers = member.where((m) {
        bool matchesQuery = query.isEmpty ||
            m["company_name"].toLowerCase().contains(query) ||
            m["address"].toLowerCase().contains(query) ||
            m["contact"].toLowerCase().contains(query) ||
            m["phone"].toLowerCase().contains(query) ||
            m["description"].toLowerCase().contains(query);

        bool matchesCategory = selectedCategory == "All Categories" ||
            m["category_arr"].any((cat) => cat["name"] == selectedCategory);

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  // Extract phone numbers and make them clickable
  List<TextSpan> _buildContactText(String contact) {
    final List<TextSpan> spans = [];
    final RegExp regex = RegExp(r'\b\d{10}\b'); // Matches 10-digit numbers
    final Iterable<Match> matches = regex.allMatches(contact);

    int lastMatchEnd = 0;
    for (Match match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: contact.substring(lastMatchEnd, match.start)));
      }

      final String phoneNumber = match.group(0)!;
      spans.add(
        TextSpan(
          text: phoneNumber,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(Uri.parse("tel:$phoneNumber")),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < contact.length) {
      spans.add(TextSpan(text: contact.substring(lastMatchEnd)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Member Directory',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0XFF155a99),
      ),
      body: dataLoad
          ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => filterResults(),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  filterResults();
                });
              },
              items: [
                DropdownMenuItem(
                  value: "All Categories",
                  child: Text("All Categories"),
                ),
                ...category.map<DropdownMenuItem<String>>((cat) {
                  return DropdownMenuItem<String>(
                    value: cat["name"],
                    child: Text(cat["caption"]),
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  var member = filteredMembers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member["company_name"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color(0XFF0a5965),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.pin_drop, color: Colors.red, size: 20.0),
                              SizedBox(width: 5.0),
                              Expanded(
                                child: Text(
                                  member["address"],
                                  style: TextStyle(fontSize: 14.0),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Contact: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ..._buildContactText(member["contact"]),
                              ],
                            ),
                          ),
                          if (member["mobile"] != null && member["mobile"].toString().isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                launchUrl(Uri.parse("tel:${member["mobile"]}"));
                              },
                              child: Text(
                                "Mobile: ${member["mobile"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          SizedBox(height: 5),
                          Text(
                            member["description"],
                            softWrap: true,
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 4.0,
                            runSpacing: 4.0,
                            children: member["category_arr"].map<Widget>((cat) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  cat["name"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
