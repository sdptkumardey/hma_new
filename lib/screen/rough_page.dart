import 'package:flutter/material.dart';

...

ListView.builder(
itemCount: filteredMembers.length,
itemBuilder: (context, index) {
var member = filteredMembers[index];
return Card(
margin: EdgeInsets.symmetric(vertical: 5),
child: Padding(
padding: EdgeInsets.all(10.0), // Added padding for better spacing
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
TextSpan(
text: member["contact"],
style: TextStyle(fontWeight: FontWeight.normal),
),
],
),
),
if (member["mobile"] != null && member["mobile"].toString().isNotEmpty)
Text.rich(
TextSpan(
children: [
TextSpan(
text: "Mobile: ",
style: TextStyle(fontWeight: FontWeight.bold),
),
TextSpan(
text: member["mobile"].toString(),
style: TextStyle(fontWeight: FontWeight.normal),
),
],
),
),
SizedBox(height: 5),
Text(
member["description"],
softWrap: true,
),
SizedBox(height: 10),

// Category buttons
Wrap(
spacing: 8.0, // Space between buttons
children: member["category_arr"].map<Widget>((cat) {
return ElevatedButton(
onPressed: () {
// Add functionality if needed
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.orange, // Bright color
foregroundColor: Colors.white, // Text color
padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20), // Rounded buttons
),
),
child: Text(cat["name"]),
);
}).toList(),
),
],
),
),
);
},
),
