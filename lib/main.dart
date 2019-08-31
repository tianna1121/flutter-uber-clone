import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Uber Clone",
      theme: new ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      home: MyHomePage("Uber Clone"),
    );
  }
}
