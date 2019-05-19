import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'statDistances.dart';

class CountDocument extends StatefulWidget {

  @override
  _CountState createState() => _CountState();
}

class _CountState extends State<CountDocument> {
  Firestore _store = Firestore.instance;
  int countDoc = 0;
  String date = 'May 19, 2019';
  List<DocumentSnapshot> allDocs;

  // นับจำนวน document ใน firestore เพื่อทำ loop
  Future _countDocuments() async {
    await _store.collection('location').document('non.naive@gmail.com').collection('date').getDocuments().then((doc){
      setState(() {
        countDoc = doc.documents.length;
      });
    });
    // for (var i in allDocs) {
    //   print(i);
    // }
  }

  // ส่งข้อมูลวันที่ไปหน้า stat
  void _sendDataToSecondScreen(BuildContext context) {
    String dateToSend = date;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatScreen(date: dateToSend),
        ));
  }

  // List<Widget>prepareCardWidgets(List<SomeObject> theObjects){
  // //here you can do any processing you need as long as you return a list of ```Widget```. 
  //     List<Widget> widgets = [];
  //     theObjects.forEach((item) {
  //       widgets.add(Card(child: Text(item.name),));
  //     });

  //     return widgets;
  //   }

  @override
  Widget build(BuildContext context) {
    _countDocuments();
    return Container(
      child: Center(
        child: ListView.builder(
          itemCount: countDoc,
          itemBuilder: (BuildContext contex, int index) {
            return new GestureDetector(
              onTap: () {
                _sendDataToSecondScreen(context);
                print('tabbed');
              },
              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.all(32.0)),
                    new Text('$index', 
                      style: new TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.black)
                    )
                  ],
                ),
              ),
            );
          },
        ),
        ),
    );
  }
}