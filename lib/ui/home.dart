import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }

}


class HomeState extends State<Home> {
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
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text("Setting"),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            

            ListTile(
              title: Text("Login"),
              trailing: Icon(Icons.landscape),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              title: Text("Register"),
              trailing: Icon(Icons.laptop_mac),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),


            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: (
            Row(
              children: <Widget>[
                //ระยะทางรวม
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'ระยะทางรวม',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        'xx.xx km',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                //แคลอรี่
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'แคลอรี่',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        'xx.xx cal',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}