import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../requests/google_maps_requests.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPostion => _initialPosition;
  LatLng get lastPostion => _lastPosition;
  GoogleMapsServices get GoogleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polyLines;

  AppState() {
    _getUserLocation();
  }

  // * TO GET THE USERS LOCATION
  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print("initial position is : ${_initialPosition.toString()}");
    locationController.text = placemark[0].name;
    notifyListeners();
  }

  // * TO CREATE ROUTE
  void createRoute(String encodedPoly) {
    _polyLines.add(
      Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encodedPoly)),
        color: Colors.black,
      ),
    );
    notifyListeners();
  }

  // * ADD A MARKER ON THE MAP
  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Good place"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  // * CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];

    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }

    return result;
  }

  // * DECODE POLY

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    // * repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // * for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      // * if value is negtive then bitwise not the value
      if (result & 1 == 1) {
        result = ~result;
      }
      var results1 = (result >> 1) * 0.00001;
      lList.add(results1);
    } while (index < len);

    // * adding to previous value as done in encoding
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }
    print(lList.toString());

    return lList;
  }

  // * SEND REQUEST
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longtitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longtitude);

    _addMarker(destination, intendedLocation);

    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  // * ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // * ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }
}
