import 'package:flutter/material.dart';
import 'package:ume_garden/ui/geoLocation.dart';
import './ui/googleMapScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UME_Garden',
      showSemanticsDebugger: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      initialRoute: '/location',
      routes: {
        "/" : (context) => MapScreen(),
        "/location": (context) => LocationScreen()
      }
    );
  }
}