import 'package:flutter/material.dart';


class PlantProfile extends StatefulWidget {
  @override
  PlantProfileState createState() {
    return PlantProfileState();
  }

}


class PlantProfileState extends State<PlantProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PlantProfile"),
        centerTitle: true,
      ),
    );
  }
}