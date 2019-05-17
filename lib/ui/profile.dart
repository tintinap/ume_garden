import 'package:flutter/material.dart';


class Profile extends StatefulWidget {
  @override
  ProfileState createState() {
    return ProfileState();
  }

}


class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Stack(
          children: <Widget>[
            _profile_container(),
            _treeandstat(context),
          ],
        ),
      ),
    );
  }
}

Widget _profile_container(){
  return Container(
    padding: EdgeInsets.all(16.0),
    child: ListView(
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
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 5.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 30,
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
        fontSize: 20.0,
        fontWeight: FontWeight.w400
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _treeandstat(context){
  return Container(
    child: Row(
      children: <Widget>[
        _tree(),
        _btn_stat(context),
      ],
    )
  );
}

Widget _tree(){
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
    child: Text(
      'จำนวนต้นไม้ x ต้น'
    ),
  );
}

Widget _btn_stat(context){
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
    child: RaisedButton(
      child: Text("บันทึกสถิติ",
        style: new TextStyle(
          fontSize: 16.0,
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

Widget _btn_edit(){

}