import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatScreen extends StatefulWidget {
  final String date;
  StatScreen({Key key, @required this.date}) : super(key: key);

  @override
  _StatState createState() => _StatState();
}

class _StatState extends State<StatScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Firestore _store = Firestore.instance;

  List<LatLng> _polyline = [];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  LatLng latlong;

  double _latitude;
  double _longitude;
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  // อ่านค่าจาก firestore แล้วทำให้เป็น latlng
  void _getPosition() {
    String date = widget.date;
    print(date);
    _store.collection('location').document('non.naive@gmail.com').collection('date').document('$date').get().then((snapshot) {
      List list = snapshot.data['position'];
      for (var i=0; i<list.length; i++) {
        if (i%2 == 0) {
          _latitude = list[i];
        } else if (i%2 != 0) {
          _longitude = list[i];
        }
        if (_longitude != null) {
          print(_latitude.toString() + ' ' + _longitude.toString());
          latlong = new LatLng(_latitude, _longitude);
          _polyline.add(latlong);
        }
      }
    });
    for (var i in _polyline){
      print(i);
    }
  }

  // เพิ่ม polyline
  void _addPolylines() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _polyline[0],
        zoom: 15.0,
      ),
    ));
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
    _getPosition();
    return new Scaffold(
      appBar: AppBar(
        title: Text('Create Polyline Stat'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(13.73, 100.78), zoom: 14),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        polylines: Set<Polyline>.of(polylines.values),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addPolylines();
        },
        label: Text('Create Polyline!'),
        icon: Icon(Icons.location_on),
      ),
    );
  }
}