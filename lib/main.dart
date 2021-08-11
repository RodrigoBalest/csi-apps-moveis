import 'package:flutter/material.dart';
import 'package:pataka/screens/inicio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pataka',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Inicio(),
    );
  }
}

