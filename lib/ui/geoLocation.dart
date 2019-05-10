import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  @override
  LocationState createState() => LocationState();
}

class LocationState extends State<LocationScreen> {

  void getCurrentLocation() {
    var currentLocation = LocationData;

    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      } 
      currentLocation = null;
    }
  }
  
  void showLocation() {
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: ListView(
        padding: EdgeInsets.all(50.0),
        children: <Widget>[
          RaisedButton(
            child: Text('Get CurrentLocation'),
            onPressed: () {
              showLocation();
            },
          )
        ],
      )
    );
  }
}