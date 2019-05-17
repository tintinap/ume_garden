import 'package:flutter/material.dart';
import 'package:slider/slider.dart';

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
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            _bgmusic(),
            _slider(),
            _sfxmusic(),
            _notifications(),
            _about(context)
          ],
        ),
      ),
    );
  }
}

Widget _bgmusic() {
  return Container(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.music_note),
        Text('Background music'),
      ],
    ),
  );
}

Widget _sfxmusic() {
  return Container(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.volume_up),
        Text('SFX music'),
      ],
    ),
  );
}

Widget _notifications() {
  return Container(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.add_box),
        Text('Notifications'),
      ],
    ),
  );
}

Widget _about(BuildContext context) {
  return Container(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
    child: FlatButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.cloud_circle),
          Text('About', textAlign: TextAlign.left),
        ]
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/home');
      },
    ),
  );
}

Widget _slider(){
  return Padding(
    padding: EdgeInsets.all(0),
    child: Slider(
      min: 0,
      max: 15,
      value: 7,
      divisions: 5,
      activeColor: Colors.teal,
      inactiveColor: Colors.blueGrey,
    )
  );
}