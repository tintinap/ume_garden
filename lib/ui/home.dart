import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
              title: Text("Login&Register"),
              trailing: Icon(Icons.landscape),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),

            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            _tree(),
            _bar(),
            _bartxt(),
            _distance(),
          ],
        ),
      ),
    );
  }
}

Widget _distance() {
  return Container(
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 25.0, 0, 0),
      child: Text(
        'ระยะทางรวม\n\nXXX Km',
        textAlign: TextAlign.center
      ),
    ),
  );
}

Widget _bar() {
  return Padding(
    padding: EdgeInsets.fromLTRB(60.0, 0, 0, 0),
    child: LinearPercentIndicator(
      width: 140.0,
      lineHeight: 14.0,
      percent: 0.5,
      backgroundColor: Colors.grey,
      progressColor: Colors.teal,
    ),
  );
}

Widget _bartxt(){
  return Text(
      'การเจริญเติบโต',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 10.0)
  );
}

Widget _tree() {
  return new Container(
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 120,
        child: Image.asset('assets/LV5.png'),
      ),
    ),
  );
}