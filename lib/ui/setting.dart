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
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            _bgmusic(),
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
