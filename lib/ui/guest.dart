import 'package:flutter/material.dart';
import 'package:slider/slider.dart';

class Guest extends StatefulWidget {
  @override
  GuestState createState() {
    return GuestState();
  }

}

class GuestState extends State<Guest> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            _logo(),
            _buttonbox(context),
          ],
        ),
      ),
    );
  }
}

 Widget _buttonbox(context){
    return new Container(
        padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _auth(context),
              _guest(context),
            ],
          ),
        ));
  }

  Widget _logo() {
    return new Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 150,
          child: Image.asset('assets/Logo2.png'),
        ),
      ),
    );
  }

Widget _auth(context) {
  return ButtonTheme(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    child: RaisedButton(
      child: Text("Sign in",
        style: new TextStyle(
          fontSize: 16.0,
        ),
      ),
      color: Colors.teal,
      onPressed: () {
        Navigator.pushNamed(context, '/auth');
      },
      splashColor: Colors.teal,
      textColor: Colors.white,
      elevation: 5.0,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
    ),
  );
}

Widget _guest(context) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
    child: RaisedButton(
      child: Text("Guest",
        style: new TextStyle(
          fontSize: 16.0,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/home');
      },
      splashColor: Colors.grey,
      textColor: Colors.blueGrey,
      elevation: 5.0,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
    ),
  );
}
