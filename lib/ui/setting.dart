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
      body: Container(
        //color: Colors.amber,
        padding: EdgeInsets.all(30.0),
        margin: EdgeInsets.all(16.0),
        width: 500.0,
        height: 300.0,
        child: Container(
          //color: Colors.teal,
          child: FlatButton.icon(
            icon: Icon(Icons.music_note),
            label: Text('Background music'),
          ),
        ),
      ),
    );
  }
}