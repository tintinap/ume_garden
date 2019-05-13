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
  double _latitude;
  double _longitude;

  CameraPosition _kGooglePlex = 
  CameraPosition(
    target: LatLng(13.7167, 100.7833),
    zoom: 15.0,
  );

  void _getLocation() async {
    final GoogleMapController controller = await _controller.future;
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      setState(() {
        _latitude = currentLocation.latitude;
        _longitude = currentLocation.longitude;
      });
      print(_latitude);
      print(_longitude);
    });

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(_latitude, _longitude),
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          Polyline(
            polylineId: null,
            width: 10,
            points: <LatLng>[
                LatLng(_latitude, _longitude),
            ],
            endCap: Cap.roundCap,
            startCap: Cap.buttCap,
            color: Colors.orange,
            visible: true
          );
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getLocation,
        label: Text('To my location!'),
        icon: Icon(Icons.location_on),
      ),
    );
  }
}