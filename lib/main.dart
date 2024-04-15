import 'package:flutter/material.dart';

import 'home.dart'; // Assuming you have a separate file for HomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(), // Set HomeScreen as the home page
      debugShowCheckedModeBanner: false,
    );
  }
}
