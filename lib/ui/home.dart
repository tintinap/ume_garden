import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_demo/models/guest.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pedometer/pedometer.dart';
import 'dart:async';

import 'profile.dart';

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
  Firestore _store = Firestore.instance;
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
  String name;

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
  
  Future _sendData() async {
    await _store.collection('register2').document(widget.user).setData({
      'km': _km,
      'totalKm': _totalKm,
      'lvl': _lvl,
      'tree': _plants,
      'step': _stepCountValue,
      'remainStep': _remainStepCount,
      'name': widget.user
    });
  }

  Future _getName() async {
    await _store.collection('register2').getDocuments().then((doc){
      setState(() {
        doc.documents.forEach((doc) {
        if (doc.data['name'] == widget.user) {
          name = doc.data['name'];
        }
       });
      });
    });
  }

  @override
  Widget build(BuildContext context,) {
    if (widget.user!=null) {
      _sendData();
    } else {
      name = 'Guest';
    }
    _getName();
    return Scaffold(
      appBar: AppBar(
        title: Text("Little Garden"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("$name"),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: widget.user)));
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
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: Container(
        child: visible == false?
        ListView( //this one when has not lvl5 yet
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
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
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
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
      print("_km = $_km");
    });
    double totalKm = 0;
      if (_plants > 0) {
        totalKm += _stepCountValue/2000;
        _totalKm = totalKm.toStringAsFixed(1);
        _totalStep += _stepCountValue;
      } else {
        _totalKm = _km;
        _totalStep = _stepCountValue;
      }
    print("totalKm = $_totalKm, totalStepCount = $_totalStep");

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
      stepCountValue = 0;
      _stepCountValue = stepCountValue;
      _km = "0.0";
      _plants += 1;
      _fullPerLvl = 1000;
    });
  }
  
  //set remainStepCount and lvl
  void _getLevel() {
    //for deploy
    // if (_stepCountValue < 1000){ 
    //   setState(() => _lvl = 0);
    //   setState(() => _remainStepCount = _stepCountValue);
    //   setState(() => _fullPerLvl = 1000);
    // } else if (_stepCountValue < 5000) { 
    //   setState(() => _lvl = 1);
    //   setState(() => _remainStepCount = _stepCountValue-1000);
    //   setState(() => _fullPerLvl = 5000);
    // } else if (_stepCountValue < 10000) { 
    //   setState(() => _lvl = 2); 
    //   setState(() => _remainStepCount = _stepCountValue-5000);
    //   setState(() => _fullPerLvl = 10000);
    // } else if (_stepCountValue < 50000) { 
    //   setState(() => _lvl = 3);
    //   setState(() => _remainStepCount = _stepCountValue-10000);
    //   setState(() => _fullPerLvl = 50000);
    // } else if (_stepCountValue < 100000) {
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
      setState(() => _remainStepCount = _stepCountValue);
      setState(() => _fullPerLvl = 100);
    } else if (_stepCountValue < 200) { 
      setState(() => _lvl = 1);
      setState(() => _remainStepCount = _stepCountValue-100);
      setState(() => _fullPerLvl = 200);
    } else if (_stepCountValue < 300) { 
      setState(() => _lvl = 2); 
      setState(() => _remainStepCount = _stepCountValue-200);
      setState(() => _fullPerLvl = 300);
    } else if (_stepCountValue < 400) { 
      setState(() => _lvl = 3);
      setState(() => _remainStepCount = _stepCountValue-300);
      setState(() => _fullPerLvl = 400);
    } else if (_stepCountValue < 500) {
      setState(() => _lvl = 4);
      setState(() => _remainStepCount = _stepCountValue-400);
      setState(() => _fullPerLvl = 500);
    } else { 
      setState(() => _lvl = 5);
      setState(() => _remainStepCount = 500);
      setState(() => _fullPerLvl = 500);
    }
    this._plantImage = "assets/LV$_lvl.png";
  }
//=================================pedometer part==================================  
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
Widget _newtree(int level){
  level == 5? visible = true: visible = false;
  return Visibility(
    visible: visible,
    child: Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: FlatButton(
        child: Text("New Tree"),
          onPressed: () {
            //add new tree
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