import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return MainScreenState();
  }
  
}

class MainScreenState extends State<MainScreen> {
  String _km = "0.0"; //distance
  String _totalKm = "0.0"; // Total distance
  int _stepCountValue = 0; //all Foot step record
  int  _remainStepCount = 0; //step that will be showed on screen
  int plants = 0; //all lvl 5 plants of user
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

//==================================design around here=====================================
  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: AppBar(
        title: Text("Ume Garden")
      ),
      body: Center(
          child: 
              Text("$_stepCountValue step $_km km RemainStep: $_remainStepCount Lvl: $_lvl", textAlign: TextAlign.center,),
        ),
    );
  }
//==================================design around here=====================================
  
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

      totalKm += _stepCountValue/2000;
      _totalKm = totalKm.toStringAsFixed(1);
      stepCountValue = 0;
      _stepCountValue = stepCountValue;
      _km = "0.0";
    });
  }
  
  //set remainStepCount and lvl
  void _getLevel() {
    if (_stepCountValue < 1000){ 
      setState(() => _lvl = 0);
      setState(() => _remainStepCount = _stepCountValue);
    } else if (_stepCountValue < 5000) { 
      setState(() => _lvl = 1);
      setState(() => _remainStepCount = _stepCountValue-1000);
    } else if (_stepCountValue < 10000) { 
      setState(() => _lvl = 2); 
      setState(() => _remainStepCount = _stepCountValue-5000);
    } else if (_stepCountValue < 50000) { 
      setState(() => _lvl = 3);
      setState(() => _remainStepCount = _stepCountValue-10000);
    } else if (_stepCountValue < 100000) { 
      setState(() => _lvl = 4);
      setState(() => _remainStepCount = _stepCountValue-50000);
    } else { 
      setState(() => _lvl = 5);
      setState(() => _remainStepCount = _stepCountValue-100000);
    }
  }
}


/*
Things to insert to db
-totalKm
-stepCountValue
-plants
-lvl
-remainStepCount
*/