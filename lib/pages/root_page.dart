// เช็คว่า user ได้ทำการ login ไว้รึเปล่า
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/login_signup_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/pages/home_page.dart';
import '../ui/home.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}
// ค่าสถานะต่างๆ ของ login 
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _test ='';
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _test = user.email;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

//5hk login อยู่ให้ทำการ set ค่า user id ที่ login ตอนนั้น
  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        _test = user.email;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      
    });
  }
// ถ้า logout ให้ set authStatus เป็น NOT_LOGGED_IN เเละ ให้ _userId เป็นว่าง
  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }



  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }



// เช็ค case ว่า login อยู่เปล่า ถ้า login อยู่ให้ไปหน้า Homepage Return ว่าจะออกไปหน้าไหน
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new Home(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            user: _test,
          );
        } else return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
