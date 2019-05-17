import 'package:flutter/material.dart';
//import './ui/main_screen.dart';
import './ui/home.dart';
import './ui/profile.dart';
import './ui/editProfile.dart';
import './ui/setting.dart';
import './ui/plantProfile.dart';
import './services/authentication.dart';
import './pages/root_page.dart';
import './ui/guest.dart';

void main() => runApp(MyApp());

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
      	"/" : (context) => Guest(),
      	"/auth" : (context) => RootPage(auth: new Auth()),
        "/home" : (context) => Home(),
        "/profile" : (context) => Profile(),
        "/setting" : (context) => Setting(),
        "/editProfile" : (context) => EditProfile(),
        "/plant" : (context) => PlantProfile(),
      }
    );
  }
}
