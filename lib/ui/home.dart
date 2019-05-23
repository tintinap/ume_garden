import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_login_demo/models/guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/guest.dart';
import 'first.dart';
import '../globals.dart' as globals;

import 'package:pedometer/pedometer.dart';
import 'dart:async';

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
  String _plantImage = "assets/maintree/LV0.png";
  int _fullPerLvl = 1000;
  // GuestProvider gp = GuestProvider();
  Guest updateRecord = Guest();
  Guest resetRecord = Guest();
  
//=================================pedometer part==================================
  String _km = globals.guest[0]['km']; //"0.0" distance 
  String _totalKm = globals.guest[0]['totalKm']; //"0.0" Total distance
  int _stepCountValue = globals.guest[0]['step']; //0 all Foot step record
  int _totalStep = globals.guest[0]['totalStep']; //0 Total footstep
  int _remainStepCount = globals.guest[0]['remainStep']; //0 step that will be showed on screen
  int _plants = globals.guest[0]['tree']; //0 all lvl 5 plants of user
  StreamSubscription<int> _subscription; // for pedometer package
  int _lvl = globals.guest[0]['lvl'];
  String name = 'Guest';

  int _count = 1; // for pedo but no need to add to db

  // get from firestore
  int currentTree;

  @override
  void initState() {
    super.initState();
    //initPlatformState();
    setUpPedometer();

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
      // 'totalStep' : _totalStep,
      'remainStep': _remainStepCount,
      'name': widget.user,
      'total_step' : _totalStep
    });
  }

  Future _getData() async {
    await _store.collection('register2').getDocuments().then((doc){
      setState(() {
        doc.documents.forEach((doc) {
        if (widget.user == doc.data['name']) {
          name = doc.data['name'];
          currentTree = doc.data['tree'];
        }
       });
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.user!=null) {
      // _sendData();
    } else {
      name = 'Guest';
    }
    setState(() {
      _getData();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Yume Garden"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
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
                
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: widget.user, picture: url, tree: currentTree)));
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

        if (globals.guest[0]['step'] > _stepCountValue) {
          _stepCountValue = globals.guest[0]['step']+1;
          print('_stepCountValue = $_stepCountValue >');
        } else {
          _stepCountValue += 1;
          print('_stepCountValue = $_stepCountValue else');
        }

        if (globals.guest[0]['totalStep'] > _totalStep) {
          _totalStep = globals.guest[0]['totalStep']+1;
          print('_totalStep = $_totalStep >');
        } else {
          _totalStep += 1;
          print('_totalStep = $_totalStep else');
        }
      });
    } else {
      print("device's stepCount = 0");
    }
    setState(() {
      _km = (globals.guest[0]['step']/2000).toStringAsFixed(1);
      print("_km = $_km");
      _totalKm= (globals.guest[0]['step']/2000).toStringAsFixed(1);
      print("_totalKm = $_totalKm");
    });

    // double totalKm = 0;
    //   if (_plants > 0) {
    //     totalKm += _stepCountValue/2000;
    //     _totalKm = totalKm.toStringAsFixed(1);
    //     _totalStep += _stepCountValue;
    //   } else {
    //     _totalKm = _km;
    //     _totalStep = _stepCountValue;
    //   }
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
      _fullPerLvl = 1000;
      _remainStepCount = 0;
      _lvl = 0;
      _plantImage = "assets/maintree/LV$_lvl.png";
      _count = 1;
    });
    resetRecord = Guest.fromUpdate(
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
      _plants += 1;
      _fullPerLvl = 1000;
      _remainStepCount = 0;
      _lvl = 0;
      _plants = 0;
      _plantImage = "assets/maintree/LV$_lvl.png";
      _count = 1;
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
    this._plantImage = "assets/maintree/LV$_lvl.png";
  }
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
            // setUpNewPlant();
            reset();
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


