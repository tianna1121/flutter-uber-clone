import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/states/app_state.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppState(),
        ),
      ],
      child: MyApp(),
    ));

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
