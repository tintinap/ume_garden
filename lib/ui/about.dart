import 'package:flutter/material.dart';
import 'package:slider/slider.dart';

class About extends StatefulWidget {
  @override
  AboutState createState() {
    return AboutState();
  }

}

class AboutState extends State<About> {
  double _sliderValueBG = 10.0;
  double _sliderValueVFX = 10.0;
  bool _noti = false;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
          children: <Widget>[
            _slider(),
            Text('version 0.7beta1\n', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            Text('___________\n', textAlign: TextAlign.center, ),
            Text('TEAM\n', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold)),
            Text('60070023\n', textAlign: TextAlign.center,),
            Text('60070028\n', textAlign: TextAlign.center,),
            Text('60070029\n', textAlign: TextAlign.center,),
            Text('60070031\n', textAlign: TextAlign.center,),
            Text('60070036\n', textAlign: TextAlign.center,),
            Text('60070046\n\n\n', textAlign: TextAlign.center,),
          ]
          //   _bgmusic(),
          //   Padding(
          //     padding: EdgeInsets.all(0),
          //     child: Slider(
          //       min: 0,
          //       max: 15,
          //       onChanged: (newRating) {
          //         setState(() => _sliderValueBG = newRating);
          //       },
          //       value: _sliderValueBG,
          //       divisions: 5,
          //       activeColor: Colors.teal,
          //       inactiveColor: Colors.blueGrey,
          //     )
          //   ),
          //   _sfxmusic(),
          //   Padding(
          //     padding: EdgeInsets.all(0),
          //     child: Slider(
          //       min: 0,
          //       max: 15,
          //       onChanged: (newRating) {
          //         setState(() => _sliderValueVFX = newRating);
          //       },
          //       value: _sliderValueVFX,
          //       divisions: 5,
          //       activeColor: Colors.teal,
          //       inactiveColor: Colors.blueGrey,
          //     )
          //   ),
          //   Container(
          //     padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         Checkbox(
          //             value: _noti,
          //             onChanged: (bool value) {
          //                 setState(() {
          //                     _noti = value;
          //                 });
          //             },
          //         ),
          //         Text('Notifications'),
          //       ],
          //     ),
          //   ),
          //   _about(context)
          // ],

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

Widget _slider(){
  return Padding(
    padding: EdgeInsets.all(5),
    child: Image.asset('assets/Logo.png'),
  );
}