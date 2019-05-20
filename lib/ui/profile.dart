import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'statProfile.dart';
import 'editProfile.dart';



String test;
class Profile extends StatefulWidget {
  final String user;
  final String picture;
  final int tree;
  Profile({Key key, this.user, this.picture, this.tree}): super(key: key);
  @override
  ProfileState createState() {
    //print(user + '---------------------------------------------------------');
    return ProfileState();
  }

}


class ProfileState extends State<Profile> {
  Firestore _store = Firestore.instance;
  int tree;
  String a;
  String name;
  @override
  Widget build(BuildContext context) {
    print(widget.tree);
    a = widget.user;
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
              _profile_container(context,a, name,widget.picture),
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


Widget _profile_container(context, a, name, picture){
  return Container(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    height: 180.0,
    child: ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
         _btn_edit(context,a,picture),
         _profile(picture),
         //_name(name),
      ],
    ),
  );
}

 
Widget _profile(String a){
  return Hero(
    tag: 'profile',
    child: Padding(
      padding: EdgeInsets.all(0),
      child: CircleAvatar (
        backgroundColor: Colors.transparent,
        radius: 40,
        child: Image.network(a),
      ),
    ),
  );
  
  // return Container(
  //   padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
  //   height: 150,
  //   width: 100,
  //   decoration: BoxDecoration(
  //     shape: BoxShape.circle,
  //     image: DecorationImage(
  //       fit: BoxFit.fill,
  //       image: NetworkImage(a)
  //     ),
  //   ),
  // );
}

Widget _name(name){
  return Container(
    child: Text(
      '$name',
      style: TextStyle(
        fontSize: 14.0,
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
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StatProfile(user: user)));
      },
      color: Colors.white,
      splashColor: Colors.grey,
      textColor: Colors.blueGrey,
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.grey)),  
    ),
  );
}

Widget _btn_edit(context,user,picture){
  return Container(
    child: RaisedButton(
      child: Text("Edit Profile",
        style: new TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(user: user, name: picture)));
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

List<Widget> _loopTree(amount, level){
  List<Widget> items = List();
  for (int i = 0; i < amount; i++){
    items.add(_treestage(level));
  }
  return items;
}

Widget _treelist(){
  return Container(
    child: Wrap(
      children: _loopTree(5, 5),
    )
  );
}
Widget _treestage(int _lvl){
  return Container(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Column(
      children: <Widget>[
        Image.asset("assets/squaretree/LV$_lvl.png", height: 150),
      ],
    )
  );
}