import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Employee {
  String id;
  String fullName;
  String dateOfBirth;
  String salary;
  String designation;

  Employee({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.salary,
    required this.designation,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullName: json['Full_Name'],
      dateOfBirth: json['DOB'],
      salary: json['Salary'],
      designation: json['Designation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Full_Name': fullName,
      'DOB': dateOfBirth,
      'Salary': salary,
      'Designation': designation,
    };
  }
}

class EmployeeChangeDataPage extends StatefulWidget {
  @override
  _EmployeeChangeDataPageState createState() => _EmployeeChangeDataPageState();
}

class _EmployeeChangeDataPageState extends State<EmployeeChangeDataPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    final response = await http
        .get(Uri.parse('https://661d2863e7b95ad7fa6c54c2.mockapi.io/Emp_Mang'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        employees = data.map((item) => Employee.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('https://661d2863e7b95ad7fa6c54c2.mockapi.io/Emp_Mang'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(employee.toJson()),
    );
    if (response.statusCode == 201) {
      // Employee added successfully, fetch updated list
      await fetchEmployees();
    } else {
      throw Exception('Failed to add employee');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse(
          'https://661d2863e7b95ad7fa6c54c2.mockapi.io/Emp_Mang/${employee.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(employee.toJson()),
    );
    if (response.statusCode == 200) {
      // Employee updated successfully, fetch updated list
      await fetchEmployees();
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(
      Uri.parse('https://661d2863e7b95ad7fa6c54c2.mockapi.io/Emp_Mang/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // Employee deleted successfully, fetch updated list
      await fetchEmployees();
    } else {
      throw Exception('Failed to delete employee');
    }
  }

  void _showAddEmployeeDialog(BuildContext context) {
    nameController.clear();
    dobController.clear();
    salaryController.clear();
    designationController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
              ),
              TextField(
                controller: designationController,
                decoration: InputDecoration(labelText: 'Designation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEmployee(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEmployeeDialog(BuildContext context, Employee employee) {
    nameController.text = employee.fullName;
    dobController.text = employee.dateOfBirth;
    salaryController.text = employee.salary;
    designationController.text = employee.designation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
              ),
              TextField(
                controller: designationController,
                decoration: InputDecoration(labelText: 'Designation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateEmployee(employee);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Change Data'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAddEmployeeDialog(context);
                },
                child: Text('Add Employee'),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(employees[index].fullName),
                    subtitle: Text(employees[index].id),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditEmployeeDialog(context, employees[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteEmployee(employees[index].id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEmployee(BuildContext context) {
    String name = nameController.text.trim();
    String dob = dobController.text.trim();
    String salary = salaryController.text.trim();
    String designation = designationController.text.trim();

    if (name.isNotEmpty &&
        dob.isNotEmpty &&
        salary.isNotEmpty &&
        designation.isNotEmpty) {
      Employee newEmployee = Employee(
        id: '', // Leave ID empty, it will be generated by the server
        fullName: name,
        dateOfBirth: dob,
        salary: salary,
        designation: designation,
      );
      addEmployee(newEmployee);
      Navigator.of(context).pop();
    } else {
      _showErrorDialog(context, 'Please fill in all fields.');
    }
  }

  void _updateEmployee(Employee employee) {
    String name = nameController.text.trim();
    String dob = dobController.text.trim();
    String salary = salaryController.text.trim();
    String designation = designationController.text.trim();

    if (name.isNotEmpty &&
        dob.isNotEmpty &&
        salary.isNotEmpty &&
        designation.isNotEmpty) {
      employee.fullName = name;
      employee.dateOfBirth = dob;
      employee.salary = salary;
      employee.designation = designation;
      updateEmployee(employee);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmployeeChangeDataPage(),
  ));
}
