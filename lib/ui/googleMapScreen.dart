import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  var location = new Location();
  List<LatLng> _polyline = [];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  // มุมมองกล้องเริ่มต้น
  CameraPosition _kGooglePlex = 
    CameraPosition(
      target: LatLng(13.7167, 100.7833),
      zoom: 15.0,
  );

  // ลบค่าใน list polyline
  void _onEnabled() {
    _polyline.clear();
  }

  // จัดการ location และมุมมองกล้อง
  void _getLocation() async {
    _onEnabled();
    print("Cleared Location List");

    final GoogleMapController controller = await _controller.future;
    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      _addLocations(currentLocation.latitude, currentLocation.longitude);
      _addPolylines();
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 15.0,
        ),
      ));
    });
  }

  // เพิ่มจุดใน list polyline
  void _addLocations(double _latitude, double _longitude) async {
    LatLng latlong = new LatLng(_latitude, _longitude);
    _polyline.add(latlong);
    print('added latlong into list.');
  }

  // เพิ่มเส้น polylines
  void _addPolylines() async {
    final int polylineCount = polylines.length;
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: false,
      color: Colors.red,
      width: 15,
      points: _polyline,
    );
    setState(() {
      polylines[polylineId] = polyline;
    });
    print("added polyline.");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('MapApi'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        polylines: Set<Polyline>.of(polylines.values),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getLocation,
        label: Text('Create Polyline!'),
        icon: Icon(Icons.location_on),
      ),
    );
  }
}