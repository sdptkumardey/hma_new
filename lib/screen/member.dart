import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
class Member extends StatefulWidget {
  static String id = 'member';

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  List<dynamic> member = [];
  List<dynamic> filteredMembers = [];
  List<dynamic> category = [];
  bool dataLoad = false;

  TextEditingController searchController = TextEditingController();
  String selectedCategory = "All Categories";


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
            m["description"].toLowerCase().contains(query);

        bool matchesCategory = selectedCategory == "All Categories" ||
            m["category_arr"].any((cat) => cat["name"] == selectedCategory);

        return matchesQuery && matchesCategory;
      }).toList();
    });
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
                    child: ListTile(
                      title: Text(member["company_name"], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member["address"]),
                          Text("Contact: ${member["contact"]}"),
                          Text(member["description"]),
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
