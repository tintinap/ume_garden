import 'package:flutter/material.dart';


class StatProfile extends StatefulWidget {
  @override
  StatProfileState createState() {
    return StatProfileState();
  }

}


class StatProfileState extends State<StatProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Stat"),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _profile_container(context),
              _tree(),
              _listview(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _profile_container(context){
  return Container(
    color: Colors.teal,
    height: 180.0,
    child: ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
         _profile(),
         _name(),
      ],
    ),
  );
}

Widget _profile(){
  return new Hero(
    tag: 'profile',
    child: Container(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 40,
        child: Image.asset('assets/guest.png'),
      ),
    ),
  ); 
}

Widget _name(){
  return Container(
    child: Text(
      'Jack\'tnp',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _tree(){
  return Container(
    padding: EdgeInsets.all(30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("จำนวนต้นไม้", textAlign: TextAlign.left, style: TextStyle(fontSize: 14.0, color: Colors.teal)),
              Text("xx ต้น", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), textAlign: TextAlign.left,),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(150, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text("ระยะทางรวม", textAlign: TextAlign.right, style: TextStyle(fontSize: 14.0, color: Colors.teal)),
              Text("xx กิโลเมตร", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), textAlign: TextAlign.right,),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _btn_stat(context){
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: RaisedButton(
      child: Text("บันทึกสถิติ",
        style: new TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/stat');
      },
      splashColor: Colors.grey,
      textColor: Colors.blueGrey,
      elevation: 5.0,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
    ),
  );
}

Widget _listview() {
  return Container(
        child: Center(
          child: Column(
            children: <Widget>[
             Card(
                child: Container(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: <Widget>[
                     Text('Hello World'),
                     Text('How are you?')
                    ],
                  ),
                ),
              ),
             Card(
                child: Container(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: <Widget>[
                     Text('Hello World'),
                     Text('How are you?')
                    ],
                  ),
                ),
              ),
             Card(
                child: Container(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: <Widget>[
                     Text('Hello World'),
                     Text('How are you?')
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}