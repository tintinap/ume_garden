import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class EditProfile extends StatefulWidget {
  @override
  EditProfileState createState() {
    return EditProfileState();
  }

}


class EditProfileState extends State<EditProfile> {
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
              _editform(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _editform() {
  return Padding(
    padding: EdgeInsets.all(25),
    child: Column(
      children: <Widget>[
        _btn_all(),
        _profile(),
        _username(),
      ],
    ),
  );
}

Widget _btn_all() {
  return Row(
    children: <Widget>[
      _btn_cancel(),
      _btn_save(),
    ],
  );
}

Widget _btn_save() {
  return Container(
    margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
    child: FlatButton(
      child: Text("save"),
      onPressed: () {
        //press to set username
      },
      textColor: Colors.blue,
    ),
  );
}

Widget _btn_cancel() {
  return Container(
    
    child: FlatButton(
      child: Text("cancel"),
        onPressed: () {

        },
        textColor: Colors.blue,
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

Widget _profile(){
  return new Hero(
    tag: 'profile',
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 5.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 40,
        child: Image.asset('assets/guest.png'),
      ),
    ),
  ); 
}
