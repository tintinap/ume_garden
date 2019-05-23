import 'package:flutter/material.dart';
import 'package:slider/slider.dart';
import 'home.dart';
import '../globals.dart' as globals;

import '../models/guest.dart';

class First extends StatefulWidget {

  @override
  GuestState createState() {
    return GuestState();
  }

}

class GuestState extends State<First> {

  static List<Map> guet = [];
  
  @override
  Widget build(BuildContext) {
    // gp.open("Guest.db");
    print("pang");
    return Scaffold(
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            _logo(),
            _buttonbox(context, globals.gp),
          ],
        ),
      ),
    );
  }
}

 Widget _buttonbox(context, provider){
    return new Container(
        padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _auth(context),
              _guest(context, provider),
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
          child: Image.asset('assets/Logo.png'),
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
        print('pressed sign in');
        Navigator.pushNamed(context, '/auth');
      },
      splashColor: Colors.teal,
      textColor: Colors.white,
      elevation: 5.0,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
    ),
  );
}

Widget _guest(context, provider) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
    child: RaisedButton(
      child: Text("Guest",
        style: new TextStyle(
          fontSize: 16.0,
        ),
      ),
      onPressed: () async{
        // Navigator.pushNamed(context, '/home');
        GuestState.guet = await provider.db.rawQuery("select * from Guest");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(guestd: GuestState.guet,)));
        print("<================================>");
        print("thisone ${GuestState.guet}");
        print("<================================>");
      },
      splashColor: Colors.grey,
      textColor: Colors.blueGrey,
      elevation: 5.0,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
    ),
  );
}
