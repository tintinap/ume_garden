import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }

}


class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100, right: 60, left: 60),

        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Image.asset(
                "resources/logo.png",
                height: 150,
              ),
              TextFormField(
                decoration: InputDecoration(
                  //labelText: "User Id",
                  hintText: "User Id",
                  icon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.text,
                onSaved: (value) => print(value),
                validator: (value){
                  if(value.isEmpty){
                    return "กรุณาระบุ user or password";
                  }
                  if(value.toLowerCase() == "admin"){
                    return "user or password ไม่ถูกต้อง";
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  //labelText: "Password",
                  hintText: "Password",
                  icon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                onSaved: (value) => print(value),
                validator: (value){
                  if(value.isEmpty){
                    return "กรุณาระบุ user or password";
                  }
                  if(value == "admin"){
                    return "user or password ไม่ถูกต้อง";
                  }
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: RaisedButton(
                  child: Text("LOGIN"),
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                ),
              ),
              Container(
                child: FlatButton(
                  child: Text("Register New Account"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  textColor: Colors.blue,
                ),
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
        )
      )
    );
  }
}