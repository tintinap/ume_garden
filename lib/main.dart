import 'package:flutter/material.dart';
import './ui/main_screen.dart';
import './ui/main.dart';

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
        "/" : (context) => HomePage(),
      }
    );
  }
}
