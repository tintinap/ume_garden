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
  String _stepCountValue = '0'; //all Foot step record
  int  _remainStepCount = 0; //step that will be showed on screen 
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

  //stepCountIncrease when device's vibrating
  void _onData(int stepCountValue) async {
    print('step Count value = $stepCountValue');
    setState(() {
      _stepCountValue = "$stepCountValue";
      print('_step Count value = $_stepCountValue');
    });

  }

  //Reset StepCountValue 
  void reset() {
    setState(() {
      int stepCountValue = 0;
      stepCountValue = 0;
      _stepCountValue = "$stepCountValue";
    });
  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter Pedometer Error: $error");
  }


  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: AppBar(
        title: Text("Ume Garden")
      ),
      body: Center(
          child: 
              Text("$_stepCountValue step $_km km RemainStep: $_remainStepCount", textAlign: TextAlign.center,),
        ),
    );
  }
  
}