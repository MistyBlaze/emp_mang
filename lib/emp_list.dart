import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Map<String, dynamic>> employeeData = [];

  Future<void> fetchEmployeeData() async {
    final response = await http
        .get(Uri.parse('https://661d2863e7b95ad7fa6c54c2.mockapi.io/Emp_Mang'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        employeeData = data.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load employee data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Greyish-white background color
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: employeeData.length,
                  itemBuilder: (context, index) {
                    return EmployeeCard(employeeData[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeCard extends StatefulWidget {
  final Map<String, dynamic> employee;

  EmployeeCard(this.employee);

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // No shadow for the card
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[300], // Greyish-white background for the card
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.blue,
              size: 36,
            ),
            title: Text(
              'Employee ID: ${widget.employee['Emp_ID']}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green), // Changed to green
            ),
            subtitle: Text(
              'Name: ${widget.employee['Full_Name']}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.blue,
                size: 36,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Date of Birth:', widget.employee['DOB']),
                  _buildDetailRow('Salary:', '₹${widget.employee['Salary']}'),
                  _buildDetailRow(
                      'Designation:', widget.employee['Designation']),
                  // Add more details here as needed
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green), // Changed to green
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmployeeListPage(),
  ));
}
