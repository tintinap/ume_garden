import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'statDistances.dart';

class MapScreen extends StatefulWidget {
  final String user;

  MapScreen({Key key, this.user}): super(key: key);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Firestore _store = Firestore.instance;
  String date = new DateFormat.yMMMd().format(new DateTime.now());

  var location = new Location();
  // LocationData currentLocation;

  List<LatLng> _polyline = [];
  List position = [];

  double latitude = 0;
  double longitude = 0;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  // ลบค่าใน list polyline
  void _onEnabled() async {
    setState(() {
      _polyline.clear();
    });
    print("Cleared Location List");
  }

  // void _getCurrentLocation() async {
  //   try {
  //     currentLocation = await location.getLocation();
  //   } catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       print('Permission denied');
  //     } 
  //     currentLocation = null;
  //   }
  // }

  // จัดการ location และมุมมองกล้อง
  void _getLocation() async {
    // location.changeSettings(distanceFilter: 10);
    location.onLocationChanged().listen((Map<String,double> currentLocation) async {
      final GoogleMapController controller = await _controller.future;
      print(currentLocation['latitude']);
      print(currentLocation['longitude']);
      if (latitude == 0 && longitude == 0){
        _addLocations(currentLocation['latitude'], currentLocation['longitude']);
        _addPolylines();
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
            zoom: 15.0,
          ),
        ));
      } else {
        if (currentLocation['latitude'] != latitude || currentLocation['longitude'] != longitude) {
          _addLocations(currentLocation['latitude'], currentLocation['longitude']);
          _addPolylines();
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
              zoom: 15.0,
            ),
          ));
        }
      }
    });
  }

  // เพิ่มจุดใน list polyline
  void _addLocations(double _latitude, double _longitude) async {
    LatLng latlong = new LatLng(_latitude, _longitude);
    _polyline.add(latlong);
    position.add(_latitude);
    position.add(_longitude);
    setState(() {
      latitude = _latitude;
      longitude = _longitude;
    });
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

  // แสดง Dialog
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Want to save?"),
          content: const Text("This will save all of your line."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () async {
                await _store.collection('register2').document(widget.user).collection('date').document(date).setData({
                  'date': date,
                  'position': position,
                });
                print('added _polyline to position');
                _onEnabled();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('MapApi'),
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
      persistentFooterButtons: <Widget>[
        FloatingActionButton.extended(
          onPressed: _getLocation,
          label: Text('Create Polyline!'),
          icon: Icon(Icons.location_on),
        ),
        FloatingActionButton.extended(
          heroTag: 'SaveLines',
          onPressed: () {
            _showDialog();
          },
          label: Text('Save All Lines!'),
          icon: Icon(Icons.save),
        )
      ],
    );
  }
}