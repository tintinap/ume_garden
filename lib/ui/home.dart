import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_demo/models/guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

import '../models/guest.dart';
import 'first.dart';
import '../globals.dart' as globals;

import 'package:pedometer/pedometer.dart';
import 'dart:async';

import 'googleMapScreen.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  Home(
    {
      Key key, this.auth, this.userId, this.onSignedOut,this.user, this.guestd,
    }
  )
    : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String user;
  final List<Map> guestd;
  // static List<Map> guest;
  
  @override
  HomeState createState() {
    /*if firebase {
      guest = guestfirebase
    } else guest = guestd
    */
    globals.guest = guestd;
    print("hhi ${globals.guest} ${globals.guest[0]['km']}");
    return HomeState();
  }

}


class HomeState extends State<Home> {

  Firestore _store = Firestore.instance;
  String date = new DateFormat.yMMMd().format(new DateTime.now());
  int _fullPerLvl = 1000;
  String _plantImage = "assets/maintree/LV0.png";
  Guest updateRecord = Guest();

//=================================StreamLocation==================================
  var location = new Location();
  double latitude = 0;
  double longitude = 0;
  String error;
  
//=================================pedometer part==================================
  String _km = globals.guest[0]['km']; //"0.0" distance 
  String _totalKm = globals.guest[0]['totalKm']; //"0.0" Total distance
  int _stepCountValue = globals.guest[0]['step']; //0 all Foot step record
  int _totalStep = globals.guest[0]['totalStep']; //0 Total footstep
  int _remainStepCount = globals.guest[0]['remainStep']; //0 step that will be showed on screen
  int _plants = globals.guest[0]['tree']; //0 all lvl 5 plants of user
  StreamSubscription<int> _subscription; // for pedometer package
  int _lvl = globals.guest[0]['lvl'];
  String name = globals.guest[0]['name'];

  @override
  void initState() {
    super.initState();
    //initPlatformState();
    _plantImage = "assets/maintree/LV$_lvl.png";
    setUpPedometer();
    if (widget.user!=null) {
      setState(() {
        _getLocation();
      });
    }
  }

  void setUpPedometer() async {
    Pedometer pedometer = new Pedometer();
    this._subscription = pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }
//=================================pedometer part==================================

  _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignedOut();
        Guest signOutRecord = Guest.fromUpdate(
          1,
          "Guest",
          _km,
          _totalKm, 
          _stepCountValue, 
          _totalStep, 
          _remainStepCount, 
          _plants, 
          _lvl
        );
        globals.gp.update(signOutRecord);
        List<Map> newRecord = await globals.gp.db.rawQuery("select * from Guest");
        print("cccccccccccccccccccccccccccccccccccccccc");
        print(newRecord[0]);
        print("cccccccccccccccccccccccccccccccccccccccc");
        
      } catch (e) {
        print(e);
      }
    }
  
  Future _sendData() async {
    await _store.collection('register2').document(widget.user).setData({
      'km': _km,
      'totalKm': _totalKm,
      'lvl': _lvl,
      'tree': _plants,
      'step': _stepCountValue,
      'totalStep' : _totalStep,
      'remainStep': _remainStepCount,
      'name': widget.user,
    });
  }


  @override
  Widget build(BuildContext context) {
    if (widget.user!=null) {
      // _sendData();
      setState(() {
        _getLocation();
      });
    } else {
      name = 'Guest';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Yume Garden"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children:<Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("$name"),
            ),
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.person_outline),
              onTap: () async{
                var url='';
                if(name == 'Guest'){
                  url = await 'https://firebasestorage.googleapis.com/v0/b/flutter-assignment-02.appspot.com/o/guest.png?alt=media&token=655c467e-10ee-4914-9f29-c05269138195';
                }
                else {
                  print('asdasdasdsadsadasdas');
                  try{
                    final ref = FirebaseStorage.instance.ref().child('$name');
                  url = await ref.getDownloadURL();
                  }
                  catch(IOException){
                     url = await 'https://firebasestorage.googleapis.com/v0/b/flutter-assignment-02.appspot.com/o/guest.png?alt=media&token=655c467e-10ee-4914-9f29-c05269138195';
                  }
                  
                }
                
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: name, picture: url, tree: _plants, totalKm: _totalKm, level: _lvl)));
              },
              
            ),
     
            ListTile(
              title: Text("About"),
              trailing: Icon(Icons.error_outline),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            // child :name == 'Guest'
            name!='Guest' ? ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.power_settings_new),
                onTap: _signOut,
              )
              : ListTile(
                title: Text('Exit'),
                trailing: Icon(Icons.power_settings_new),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                } 
              ),

          ],
        ),
      ),
      body: Container(
        child: visible == false?
        ListView( //this one when has not lvl5 yet
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          children: <Widget>[
            _tree(_plantImage),
            _barnum(_remainStepCount, _fullPerLvl),
            _bar(_remainStepCount, _fullPerLvl),
            _bartxt('การเจริญเติบโต'),
            _distanceandstep(_km, _stepCountValue),
            _newtree(_lvl),
          ]
        ):
        ListView( //this one will be using when it already lvl5
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          children: <Widget>[
            _tree(_plantImage),
            _barnum(_remainStepCount, _fullPerLvl),
            _bar(_remainStepCount, _fullPerLvl),
            _bartxt('การเจริญเติบโต'),
            _distanceandstep(_km, _stepCountValue),
            _newtree(_lvl),
          ]
        ),
      ),
    );
  }
/// Generate a modifiable result set
List<Map<dynamic, dynamic>> makeModifiableResults(List<Map<dynamic, dynamic>> results) {
  // Generate modifiable
  return List<Map<dynamic, dynamic>>.generate(
      results.length, 
      (index) => Map<dynamic, dynamic>.from(results[index]),
      growable: true
    );
}  
//=================================pedometer part==================================
  //stepCountIncrease when device's vibrating
  void _onData(int stepCountValue) async {
    print('step Count value = $stepCountValue');
    if (stepCountValue > 0) {
      setState(() {
          _stepCountValue += 1;
          // _remainStepCount += 1;
          print('_stepCountValue = $_stepCountValue else');

          _totalStep += 1;
          print('_totalStep = $_totalStep else');
      });
    } else {
      print("device's stepCount = 0");
    }
    setState(() {
      _km = (_stepCountValue/2000).toStringAsFixed(2);
      print("_km = $_km");
      _totalKm = (_totalStep/2000).toStringAsFixed(2);
      print("_totalKm = $_totalKm");
    });

    print("totalKm = $_totalKm, totalStepCount = $_totalStep");

    _getLevel();
    updateRecord = Guest.fromUpdate(
      1,
      name,
      _km,
      _totalKm, 
      _stepCountValue, 
      _totalStep, 
      _remainStepCount, 
      _plants, 
      _lvl
    );
    if (globals.gp.db != null) {
      globals.gp.update(updateRecord);
    } else {
      print("not update yet");
    }
    List<Map> current = await globals.gp.db.rawQuery("select * from Guest");
    if (current[0]['name'] != "Guest") {
      //up to firebase
      _sendData();
    }
    print("=========================================here is current Guest===========================================");
    print(current);
    print("=========================================here is current Guest===========================================");
    // reset();
  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter Pedometer Error: $error");
  }

  //setup for new plant after done the previous one 
  void setUpNewPlant() async{
    setState(() {

      _stepCountValue = 0;
      _km = "0.0";
      _plants += 1;
      // _fullPerLvl = 1000; // default
      _fullPerLvl = 100;
      _remainStepCount = 0;
      _lvl = 0;
      _plantImage = "assets/maintree/LV$_lvl.png";
    });
    Guest resetRecord = Guest.fromUpdate(
        1,
        name, //
        _km,
        _totalKm, //
        _stepCountValue, 
        _totalStep, //
        _remainStepCount, 
        _plants, //
        _lvl
      );
      List<Map> currentRecord = await globals.gp.db.rawQuery("select * from Guest");
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      print(currentRecord[0]);
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      globals.gp.update(resetRecord);
      print("added new tree");
      List<Map> newRecord = await globals.gp.db.rawQuery("select * from Guest");
      print("cccccccccccccccccccccccccccccccccccccccc");
      print(newRecord[0]);
      print("cccccccccccccccccccccccccccccccccccccccc");
    }

  void reset() async {
    setState(() {
      _stepCountValue = 0;
      _totalStep = 0;
      _km = "0.0";
      _totalKm = "0.0";
      _plants = 0;
      // _fullPerLvl = 1000;
      _fullPerLvl = 100;
      _remainStepCount = 0;
      _lvl = 0;
      _plantImage = "assets/maintree/LV$_lvl.png";
    });
    Guest emptyRecord = Guest();
    List<Map> currentRecord = await globals.gp.db.rawQuery("select * from Guest");
    print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print(currentRecord[0]);
    print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    globals.gp.update(emptyRecord);
    print('reseted');
    List<Map> newRecord = await globals.gp.db.rawQuery("select * from Guest");
    print("cccccccccccccccccccccccccccccccccccccccc");
    print(newRecord[0]);
    print("cccccccccccccccccccccccccccccccccccccccc");
    if (name != 'Guest') {
      _sendData();
    }
  }
  
  //set remainStepCount and lvl
  void _getLevel() {
    // _remainStepCount += 1;
    //for deploy
    // if (_stepCountValue < 1000){ 
    //   setState(() => _lvl = 0);
    //   setState(() => _remainStepCount = _stepCountValue);
    //   setState(() => _fullPerLvl = 1000);
    // } else if (_remainStepCount < 5000) { 
    //   setState(() => _lvl = 1);
    //   setState(() => _remainStepCount = _stepCountValue-1000);
    //   setState(() => _fullPerLvl = 5000);
    // } else if (_remainStepCount < 10000) { 
    //   setState(() => _lvl = 2); 
    //   setState(() => _remainStepCount = _stepCountValue-5000);
    //   setState(() => _fullPerLvl = 10000);
    // } else if (_remainStepCount < 50000) { 
    //   setState(() => _lvl = 3);
    //   setState(() => _remainStepCount = _stepCountValue-10000);
    //   setState(() => _fullPerLvl = 50000);
    // } else if (_remainStepCount < 100000) {
    //   setState(() => _lvl = 4);
    //   setState(() => _remainStepCount = _stepCountValue-50000);
    //   setState(() => _fullPerLvl = 100000);
    // } else { 
    //   setState(() => _lvl = 5);
    //   setState(() => _remainStepCount = 100000);
    //   setState(() => _fullPerLvl = 100000);
    //for dev
    if (_stepCountValue < 100){ 
      setState(() => _lvl = 0);
      setState(() => _fullPerLvl = 100);
      setState(() => _remainStepCount = _stepCountValue);
    } else if (_stepCountValue < 300) { 
      setState(() => _lvl = 1);
      setState(() => _fullPerLvl = 200);
      setState(() => _remainStepCount = _stepCountValue-100);
    } else if (_stepCountValue < 600) { 
      setState(() => _lvl = 2); 
      setState(() => _fullPerLvl = 300);
      setState(() => _remainStepCount = _stepCountValue-300);
    } else if (_stepCountValue < 1000) { 
      setState(() => _lvl = 3);
      setState(() => _fullPerLvl = 400);
      setState(() => _remainStepCount = _stepCountValue-600);
    } else if (_stepCountValue < 1500) {
      setState(() => _lvl = 4);
      setState(() => _fullPerLvl = 500);
      setState(() => _remainStepCount = _stepCountValue-1000);
    } else { 
      setState(() => _lvl = 5);
      setState(() => _fullPerLvl = 500);
      setState(() => _remainStepCount = 500);
    }
    setState(() {
      this._plantImage = "assets/maintree/LV$_lvl.png";
    });
    print("remain : $_remainStepCount , fullPerLvl: $_fullPerLvl}");
    print("percent: ${_remainStepCount/_fullPerLvl}");
  }

// จัดการ location ================================================================================
  void _getLocation() async {
    try {
      location.onLocationChanged().listen((Map<String,double> currentLocation) {
        setState(() {
          double _latitude = double.parse(currentLocation['latitude'].toStringAsFixed(4));
          double _longitude = double.parse(currentLocation['longitude'].toStringAsFixed(4));
          if (latitude == 0 && longitude == 0){
            _addLocations(_latitude, _longitude);
            print("Lat: $_latitude Lng: $_longitude");
          } else {
            if (_latitude != latitude || _longitude != longitude) {
              _addLocations(_latitude, _longitude);
              print("Lat: $_latitude Lng: $_latitude");
            }
          }
        });
      });
    } on PlatformException {
      await showDialog<dynamic>(
        context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("No Location"),
              content: Text(
                "Please allow this App to use Location or turn on your GPS."),
              actions: <Widget>[
              FlatButton(
                child: Text(
                  "Ok"
                ),
                onPressed: () {
                  Navigator.of(context).pop();
              },
            )
          ],
        );
      });
    }
  }

  // เพิ่มจุดใน list polyline
  void _addLocations(_latitude, _longitude) {
    List tempList = [];
    _store.collection('register2').document(name).collection('date').document(date).get().then((snapshot) {
      List list = snapshot.data['position'];
      print(list.length);
      if (list.length!=0) {
        for (int i=0; i<list.length; i++) {
          tempList.add(list[i]);
        }
        tempList.add(_latitude);
        tempList.add(_longitude);
        _store.collection('register2').document(name).collection('date').document(date).setData({
          'date': date,
          'position': tempList,
        });
        print('Sent to firestore');
      } else {
        tempList.add(_latitude);
        tempList.add(_longitude);
        _store.collection('register2').document(name).collection('date').document(date).setData({
          'date': date,
          'position': tempList,
        });
        print('Sent to firestore');
      }
    });
    latitude = double.parse(_latitude.toStringAsFixed(4));
    longitude = double.parse(_longitude.toStringAsFixed(4));;
    print('added latlong into list');
  }

  // ลบค่าใน list polyline
  // void _onEnabled() async {
  //   setState(() {
  //     _polyline.clear();
  //   });
  //   print("Cleared Location List");
  // }
//=================================pedometer part================================== 
Widget _newtree(int level) {
  level == 5? visible = true: visible = false;
  return Visibility(
    visible: visible,
    child: Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: FlatButton(
        child: Text("New Tree"),
          onPressed: () async {
            //add new tree
            setUpNewPlant();
            // reset();
          },
          color: Colors.teal,
          textColor: Colors.white,
          splashColor: Colors.green,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
        ),
        alignment: Alignment.bottomCenter,
      ),
  );
}
}


Widget _distanceandstep(km, stepcount) {
  return Container(
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("ระยะทางรวม\n", textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0)),
                Text("$km\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0), textAlign: TextAlign.center,),
                Text("กิโลเมตร", textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("จำนวนก้าว\n", textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0)),
                Text("$stepcount\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0), textAlign: TextAlign.center,),
                Text("ก้าว", textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0)),
              ],
            ),
          ),
        ],
      )
    )  
  );
}

Widget _barnum(int remainStep, int fullPerLvl){
  return Text(
      '$remainStep /$fullPerLvl',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black, fontSize: 14.0)
  );
}

Widget _bar(int remainStep, int fullPerLvl) {
  double percentNum = remainStep/fullPerLvl;
  return Padding(
    padding: EdgeInsets.fromLTRB(62.0, 0, 0, 0),
    child: LinearPercentIndicator(
      width: 240.0,
      lineHeight: 14.0,
      percent: percentNum,
      backgroundColor: Colors.grey,
      progressColor: Colors.teal,
    ),
  );
}

Widget _bartxt(String txt){
  return Text(
      txt,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 10.0)
  );
}

Widget _tree(String plantImage) {
  return new Container(
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 120,
        child: Image.asset(plantImage),
      ),
    ),
  );
}

bool visible = false;
