import 'package:flutter/material.dart';
import './ui/main_screen.dart';
import './ui/home.dart';
import './ui/profile.dart';
import './ui/editProfile.dart';
import './ui/setting.dart';
import './ui/plantProfile.dart';
import './ui/register.dart';
import './ui/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UME_Garden',
      showSemanticsDebugger: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      
      initialRoute: '/',
      routes: {
        "/" : (context) => MainScreen(),
        // "/" : (context) => Home(),
        "/profile" : (context) => Profile(),
        "/setting" : (context) => Setting(),
        "/editProfile" : (context) => EditProfile(),
        "/plant" : (context) => PlantProfile(),
        "/register" : (context) => Register(),
        "/login" : (context) => Login(),
      }
    );
  }
}
