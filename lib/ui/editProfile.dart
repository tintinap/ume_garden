import 'package:flutter/material.dart';


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
    );
  }
}