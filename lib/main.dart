import 'package:flutter/material.dart';
import 'package:ume_garden/ui/countDocuments.dart';
import 'package:ume_garden/ui/statDistances.dart';
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
      
      initialRoute: '/count',
      routes: {
        "/" : (context) => MapScreen(),
        "/stat": (context) => StatScreen(date: null),
        "/count": (context) => CountDocument()
      }
    );
  }
}