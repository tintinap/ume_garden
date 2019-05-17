import 'package:flutter/material.dart';
import './ui/main_screen.dart';
import './ui/home.dart';
import './ui/profile.dart';
import './ui/editProfile.dart';
import './ui/setting.dart';
import './ui/plantProfile.dart';
import './ui/register.dart';
import './ui/login.dart';
import './services/authentication.dart';
import './pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UME_Garden',
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
      	"/" : (context) => RootPage(auth: new Auth())),
        // "/" : (context) => MainScreen(),
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
