import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/ui/home.dart';
import 'dart:async';
//Image Plugin
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _formKey = GlobalKey<FormState>();

class EditProfile extends StatefulWidget {
  final String user;
  final String name;
  EditProfile({Key key, this.user, this.name}) : super(key: key);
  @override
  EditProfileState createState() {
    return EditProfileState();
  }
}

File sampleImage;

class EditProfileState extends State<EditProfile> {
  static getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (tempImage != null) {
      sampleImage = tempImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _editform(context, widget.user, widget.name),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _editform(context, String picture, String picturen) {
  return Padding(
    padding: EdgeInsets.all(25),
    child: Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _profile(picturen),
            enableUpload(),
          ],
        ),
        //_username(),
        _btn_all(context, picture),
      ],
    ),
  );
}

Widget _btn_all(context, picture) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
    child: Row(
      children: <Widget>[
        _btn_cancel(context),
        _btn_save(picture, context),
      ],
    ),
  );
}

Widget _btn_save(picture, context) {
  return Container(
    margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
    child: OutlineButton(
      // color: Colors.transparent,
      borderSide: BorderSide(color: Colors.blue),
      splashColor: Colors.blue,
      child: Text("save"),
      onPressed: () async{
        print(picture);
        try{
          final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('$picture');
          final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
          await Navigator.pushNamed(context, '/auth');
          }
        catch(e){
          print(e);
        }
        
      },
      textColor: Colors.blue,
    ),
  );
}

Widget _btn_cancel(context) {
  return Container(
    child: FlatButton(
      color: Colors.red,
      child: Text("cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
      textColor: Colors.white,
    ),
    alignment: Alignment.topLeft,
  );
}

Widget _username() {
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            hintText: 'champ tid hee',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
        ),
      ],
    ),
  );
}

Widget _profile(String a) {
  return Hero(
    tag: 'profile',
    child: Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 120,
          // backgroundImage: NetworkImage(a),
          child: ClipOval(
            child: Image.network(a, width: 180, height: 180, fit: BoxFit.cover),
          ),
        ),
      ),
    ),
  );
}

Widget enableUpload() {
  return Container(
    child: Column(
      children: <Widget>[
        FlatButton(
          // elevation: 7.0,
          child: /*Text('Upload')*/ Opacity(
            child: Icon(Icons.camera_alt, size: 60, color: Colors.white,),
            opacity: .6,
            
          ),
          color: Colors.transparent,
          // textColor: Colors.white,
          // backgroundColor: Colors.transparent,
          // shape: RoundedRectangleBorder(W
          // borderRadius: BorderRadius.circular(30.0),
          // side: BorderSide(color: Colors.black)),
          onPressed: () {
            EditProfileState.getImage();
          },
        )
      ],
    ),
  );
}
