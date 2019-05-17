import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StatScreen extends StatefulWidget {
  @override
  _StatState createState() => _StatState();
}

class _StatState extends State<StatScreen> {
  Completer<GoogleMapController> _controller = Completer();
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
        onPressed: _addPolylines,
        label: Text('Create Polyline!'),
        icon: Icon(Icons.location_on),
      ),
    );
  }
}