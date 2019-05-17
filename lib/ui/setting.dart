import 'package:flutter/material.dart';


class Setting extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }

}

class SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      /*
      body: Container(
        //color: Colors.amber,
        padding: EdgeInsets.all(30.0),
        margin: EdgeInsets.all(16.0),
        width: 500.0,
        height: 1000.0,
        child: Container(
          //color: Colors.teal,
          child: Text(
            'Background music\n\n\nSFX Music\n\n\n! Notification\n\n! About',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
      ),
      */
      body: Container(
        width: 400,
        height: 400,
        margin: EdgeInsets.all(20.0),
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Background music'),
            Text('ระยะทางของต้นไม้'),
            Text('xxx'),
          ],
        ),
      )
    );
  }
}