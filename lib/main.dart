import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Poppers',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pill Poppers'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}