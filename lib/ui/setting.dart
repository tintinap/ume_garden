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
      body: new Row(
        children: <Widget>[
          new IconButton(icon: Icon(Icons.add)),
          new Text('\n\nBackground music\n\n', textAlign: TextAlign.center),
        ],
        Container(
          new IconButton(icon: Icon(Icons.music_note)),
          new Text('\n\nSFX music\n\n', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}