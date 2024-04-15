import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: SearchEmployeeScreen(),
  ));
}

class SearchEmployeeScreen extends StatefulWidget {
  @override
  _SearchEmployeeScreenState createState() => _SearchEmployeeScreenState();
}

class _SearchEmployeeScreenState extends State<SearchEmployeeScreen> {
  List<Employee> employees = [];
  List<Employee> searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    final response = await http
        .get(Uri.parse('https://661d2863e7b95ad7fa6c54c2.mockapi.io/Emp_Mang'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        employees = data.map((item) => Employee.fromJson(item)).toList();
        searchResults.addAll(employees);
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
        searchResults.addAll(employees);
      });
      return;
    }

    setState(() {
      searchResults.clear();
      searchResults.addAll(employees.where((employee) =>
          employee.id.toLowerCase().contains(query.toLowerCase())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Employee',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform search operation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search by ID',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: _performSearch,
              ),
            ),
            SizedBox(height: 20),
            _buildEmployeeInfoList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: searchResults.map((employee) {
        return _buildEmployeeInfoCard(employee);
      }).toList(),
    );
  }

  Widget _buildEmployeeInfoCard(Employee employee) {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${employee.id}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text('Full Name: ${employee.fullName}'),
            Text('Date of Birth: ${employee.dob}'),
            Text('Salary: ₹${employee.salary}'),
            Text('Designation: ${employee.designation}'),
          ],
        ),
      ),
    );
  }
}

class Employee {
  final String id;
  final String fullName;
  final String dob;
  final String salary;
  final String designation;

  Employee(this.id, this.fullName, this.dob, this.salary, this.designation);

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      json['Emp_ID'],
      json['Full_Name'],
      json['DOB'],
      json['Salary'],
      json['Designation'],
    );
  }
}
