import 'package:flutter/material.dart';


class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    return RegisterState();
  }

}


class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  var password_1 = '';
  var password_2 = '';
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30, right: 20, left: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  //labelText: "Email",
                  hintText: "Email",
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => print(value),
                validator: (value){
                  if(value.isEmpty){
                    return "กรุณาระบุข้อมูลให้ครบถ้วน";
                  }
                  if(value.toLowerCase() == "admin"){
                    return "user นี้มีอยู่ในระบบแล้ว";
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
                  this.password_1 = value;
                  if(value.isEmpty){
                    return "กรุณาระบุข้อมูลให้ครบถ้วน";
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
                  this.password_2 = value;
                  if(value.isEmpty){
                    
                    return "กรุณาระบุข้อมูลให้ครบถ้วน";
                  }
                  if(password_1 != password_2){
                    print(password_1);
                    
                    print(password_2);
                    return "รหัสผ่านไม่ตรงกัน";
                  }
                },
              ),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  child: RaisedButton(
                    child: Text("CONTINUE"),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Navigator.pushNamed(context, '/');
                      }
                    },
                  ),
              ),
            ],
          ),
        ),
      )
    );
  }
}