import 'package:flutter/material.dart';
import 'package:slider/slider.dart';

class Setting extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }

}

class SettingState extends State<Setting> {
  double _sliderValueBG = 10.0;
  double _sliderValueVFX = 10.0;
  bool _noti = false;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
          children: <Widget>[
            _bgmusic(),
            Padding(
              padding: EdgeInsets.all(0),
              child: Slider(
                min: 0,
                max: 15,
                onChanged: (newRating) {
                  setState(() => _sliderValueBG = newRating);
                },
                value: _sliderValueBG,
                divisions: 5,
                activeColor: Colors.teal,
                inactiveColor: Colors.blueGrey,
              )
            ),
            _sfxmusic(),
            Padding(
              padding: EdgeInsets.all(0),
              child: Slider(
                min: 0,
                max: 15,
                onChanged: (newRating) {
                  setState(() => _sliderValueVFX = newRating);
                },
                value: _sliderValueVFX,
                divisions: 5,
                activeColor: Colors.teal,
                inactiveColor: Colors.blueGrey,
              )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                      value: _noti,
                      onChanged: (bool value) {
                          setState(() {
                              _noti = value;
                          });
                      },
                  ),
                  Text('Notifications'),
                ],
              ),
            ),
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
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.info),
          Text('About', textAlign: TextAlign.left),
        ]
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
    ),
  );
}

Widget _slider(target){
  return Padding(
    padding: EdgeInsets.all(0),
    child: Slider(
      min: 0,
      max: 15,
      onChanged: (newRating) {
        target = newRating;
      },
      value: target,
      divisions: 5,
      activeColor: Colors.teal,
      inactiveColor: Colors.blueGrey,
    )
  );
}