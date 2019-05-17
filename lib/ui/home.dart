import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_demo/models/todo.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pedometer/pedometer.dart';
import 'dart:async';

class Home extends StatefulWidget {
  Home(
    {
      Key key, this.auth, this.userId, this.onSignedOut,this.user,
    }
  )
    : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String user;
  
  @override
  HomeState createState() {
    return HomeState();
  }

}


class HomeState extends State<Home> {
  String _plantImage = "assets/LV0.png";
  int _fullPerLvl = 1000;
  
//=================================pedometer part==================================
  String _km = "0.0"; //distance
  String _totalKm = "0.0"; // Total distance
  int _stepCountValue = 0; //all Foot step record
  int _totalStep = 0; // Total footstep
  int  _remainStepCount = 0; //step that will be showed on screen
  int _plants = 0; //all lvl 5 plants of user
  StreamSubscription<int> _subscription; // for pedometer package
  int _lvl = 0;

  @override
  void initState() {
    super.initState();
    //initPlatformState();
    setUpPedometer();
  }

  void setUpPedometer() {
    Pedometer pedometer = new Pedometer();
    this._subscription = pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }
//=================================pedometer part==================================

  _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignedOut();
      } catch (e) {
        print(e);
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Little Garden"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Thanapon Wongprasert"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "J",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.person_outline),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text("Setting"),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            

            ListTile(
              title: Text("Login&Register"),
              trailing: Icon(Icons.landscape),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),

            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            _tree(_plantImage),
            _barnum(_remainStepCount, _fullPerLvl),
            _bar(_remainStepCount, _fullPerLvl),
            _bartxt('การเจริญเติบโต'),
            _distanceandstep(_km, _stepCountValue),
          ],
        ),
      ),
    );
  }
//=================================pedometer part==================================
  //stepCountIncrease when device's vibrating
  void _onData(int stepCountValue) async {
    print('step Count value = $stepCountValue');
    setState(() {
      _stepCountValue = stepCountValue;
      print('_step Count value = $_stepCountValue');
    });

    setState(() {
      _km = (stepCountValue/2000).toStringAsFixed(1);
    });

    _getLevel();

  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter Pedometer Error: $error");
  }

  //setup for new plant after done the previous one 
  void setUpNewPlant() {
    setState(() {
      int stepCountValue = 0;
      double totalKm = 0;
      if (_plants > 1) {
        totalKm += _stepCountValue/2000;
        _totalKm = totalKm.toStringAsFixed(1);
        _totalStep += _stepCountValue;
      } else {
        _totalKm = _km;
        _totalStep = _stepCountValue;
      }
      stepCountValue = 0;
      _stepCountValue = stepCountValue;
      _km = "0.0";
      _plants += 1;
      _fullPerLvl = 1000;
    });
  }
  
  //set remainStepCount and lvl
  void _getLevel() {
    if (_stepCountValue < 1000){ 
      setState(() => _lvl = 0);
      setState(() => _remainStepCount = _stepCountValue);
      setState(() => _fullPerLvl = 1000);
    } else if (_stepCountValue < 5000) { 
      setState(() => _lvl = 1);
      setState(() => _remainStepCount = _stepCountValue-1000);
      setState(() => _fullPerLvl = 5000);
    } else if (_stepCountValue < 10000) { 
      setState(() => _lvl = 2); 
      setState(() => _remainStepCount = _stepCountValue-5000);
      setState(() => _fullPerLvl = 10000);
    } else if (_stepCountValue < 50000) { 
      setState(() => _lvl = 3);
      setState(() => _remainStepCount = _stepCountValue-10000);
      setState(() => _fullPerLvl = 50000);
    } else if (_stepCountValue < 100000) {
      setState(() => _lvl = 4);
      setState(() => _remainStepCount = _stepCountValue-50000);
      setState(() => _fullPerLvl = 100000);
    } else { 
      setState(() => _lvl = 5);
      setState(() => _remainStepCount = _stepCountValue-100000);
    }
    this._plantImage = "assets/LV$_lvl.png";
  }
//=================================pedometer part==================================  
}


Widget _distanceandstep(km, stepcount) {
  return Container(
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 35.0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
            child: (Text('ระยะทางรวม\n\n$km\n\nกิโลเมตร', textAlign: TextAlign.center)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: (Text('จำนวนก้าว\n\n$stepcount\n\nก้าว', textAlign: TextAlign.center)),
          ),
        ],
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
    padding: EdgeInsets.fromLTRB(80.0, 0, 0, 0),
    child: LinearPercentIndicator(
      width: 140.0,
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