import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }

}


class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Little Garden"),
      centerTitle: true,
    ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Thanapon Wongprasert"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "J",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.person_outline),
            ),
            ListTile(
              title: Text("Setting"),
              trailing: Icon(Icons.settings),
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
            ),
          ],
        ),
      ),//this will just add the Navigation Drawer Icon
    ),
  }