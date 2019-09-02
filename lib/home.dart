import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'utils/main.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage(this.title);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;
  static const _initialPostion = LatLng(12.92, 77.02);
  LatLng _lastPostion = _initialPostion;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return _initialPostion == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _lastPostion,
                  zoom: 10.0,
                ),
                onMapCreated: onCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
              Positioned(
                top: 50.0,
                right: 15.0,
                child: FloatingActionButton(
                  onPressed: _onAddMarkerPressed,
                  tooltip: "add marker",
                  backgroundColor: black,
                  child: Icon(
                    Icons.add_location,
                    color: white,
                  ),
                ),
              )
            ],
          );
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {});
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onAddMarkerPressed() {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId(
              _lastPostion.toString(),
            ),
            position: _lastPostion,
            infoWindow:
                InfoWindow(title: "Remeber here", snippet: "Good place"),
            icon: BitmapDescriptor.defaultMarker),
      );
    });
  }
}
