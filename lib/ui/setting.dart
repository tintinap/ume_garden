import 'package:flutter/material.dart';


class Setting extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }

}


class SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
    );
  }
}