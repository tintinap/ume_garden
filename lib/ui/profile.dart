import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'statProfile.dart';

class Profile extends StatefulWidget {
  final String user;

  Profile({Key key, this.user}): super(key: key);
  @override
  ProfileState createState() {
    return ProfileState();
  }

}


class ProfileState extends State<Profile> {
  Firestore _store = Firestore.instance;
  int tree;
  String name;
  @override
  Widget build(BuildContext context) {
    _getTree();
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _profile_container(context, name),
              _treeandstat(context, widget.user, tree),
              _treelist(),
            ],
          ),
        ),
      ),
    );
  }

  Future _getTree() async {
    await _store.collection('register2').getDocuments().then((doc){
      setState(() {
        doc.documents.forEach((doc) {
        if (doc.data['name'] == widget.user) {
          tree = doc.data['tree'];
          name = doc.data['name'];
        }
       });
      });
    });
  }

}


Widget _profile_container(context, name){
  return Container(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    height: 180.0,
    child: ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
         _btn_edit(context),
         _profile(),
         _name(name),
         
      ],
    ),
  );
}

Widget _profile(){
  return Hero(
    tag: 'profile',
    child: Padding(
      padding: EdgeInsets.all(0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 40,
        child: Image.asset('assets/guest.png'),
      ),
    ),
  ); 
}

Widget _name(name){
  return Container(
    child: Text(
      '$name',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _treeandstat(context, user, tree){
  return Container(
    padding: EdgeInsets.fromLTRB(25, 0, 20, 15),
    child: Row(
      children: <Widget>[
        _tree(tree),
        _btn_stat(context, user),
      ],
    )
  );
}

Widget _tree(tree){
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 0, 35, 0),
    child: Text(
      'จำนวนต้นไม้ $tree ต้น'
    ),
  );
}

Widget _btn_stat(context, user){
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => StatProfile(user: user)));
      },
      splashColor: Colors.grey,
      textColor: Colors.blueGrey,
      elevation: 5.0,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),  
    ),
  );
}

Widget _btn_edit(context){
  return Container(
    child: RaisedButton(
      child: Text("Edit Profile",
        style: new TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
        onPressed: () {
          Navigator.pushNamed(context, '/editProfile');
        },
        color: Colors.white,
        splashColor: Colors.white,
        textColor: Colors.blueGrey,
         elevation: 5.0,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        // textColor: Colors.blue,
        ),
      alignment: Alignment.bottomRight,
  );
}

Widget _treelist(){
  return Container(
    child: Wrap(
      children: <Widget>[
        _treestage(),
        _treestage(),
        _treestage(),
        _treestage(),
        _treestage(),
      ],
    )
  );
}
Widget _treestage(){
  return Container(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Column(
      children: <Widget>[
        Image.asset("assets/LV5.png", height: 150),
        Text('Lv 5/5')
      ],
    )
  );
}