import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage(this.title);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(12.92, 77.02), zoom: 12.0),
            )
          ],
        ));
  }
}
