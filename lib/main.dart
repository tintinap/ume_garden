import 'package:flutter/material.dart';
import 'package:flutter_login_demo/ui/testpage.dart';
//import './ui/main_screen.dart';
import './ui/home.dart';
import './ui/profile.dart';
import './ui/editProfile.dart';
import './ui/setting.dart';
import './ui/plantProfile.dart';
import './services/authentication.dart';
import './pages/root_page.dart';
import './ui/first.dart';
import './ui/statprofile.dart';
// import './ui/testpage.dart';
import 'models/guest.dart';

import 'globals.dart' as globals;

// GuestProvider gp = GuestProvider();
void main() async{
  await globals.gp.open('guest.db');
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YUME GARDEN',
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
      	"/" : (context) => First(),
      	"/auth" : (context) => RootPage(auth: new Auth()),
        "/home" : (context) => Home(),
        "/profile" : (context) => Profile(),
        "/setting" : (context) => Setting(),
        "/editProfile" : (context) => EditProfile(),
        "/statProfile" : (context) => StatProfile(),
        "/plant" : (context) => PlantProfile(),
        // "/test" : (context) => TestPage(),
      }
    );
  }
}
