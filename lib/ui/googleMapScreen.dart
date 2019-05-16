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
  List<LatLng> _polyline = [];

  CameraPosition _kGooglePlex = 
  CameraPosition(
    target: LatLng(13.7167, 100.7833),
    zoom: 15.0,
  );

  void _onEnabled() {
    _polyline.clear();
  }

  void _getLocation() async {
    _onEnabled();

    final GoogleMapController controller = await _controller.future;
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      _onMotionChange(currentLocation.latitude, currentLocation.longitude);
      _addPolylines();
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 17.0,
        ),
      ));
    });
  }

  void _onMotionChange(double _latitude, double _longitude) async {
    LatLng latlong = new LatLng(_latitude, _longitude);
    _polyline.add(latlong);
  }

  Polyline _addPolylines() {
    return new Polyline(
      points: _polyline,
      color: Colors.red,
      width: 1000,
      polylineId: null
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Polyline'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getLocation,
        label: Text('Create Polyline!'),
        icon: Icon(Icons.location_on),
      ),
    );
  }
}