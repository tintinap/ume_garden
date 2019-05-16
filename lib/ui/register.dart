import 'package:flutter/material.dart';


class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    return RegisterState();
  }

}


class RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
    );
  }
}