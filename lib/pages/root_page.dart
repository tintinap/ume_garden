// เช็คว่า user ได้ทำการ login ไว้รึเปล่า
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/login_signup_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/pages/home_page.dart';
import '../ui/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guest.dart';
import '../globals.dart' as globals;


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
  Firestore _store = Firestore.instance;
  String name;
  String _km;
  String _totalKm; 
  int _stepCountValue; 
  int _totalStep;
  int _remainStepCount; 
  int _tree; 
  int _lvl;


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
      _test = '';
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

List<Map> _guestd = [];
bool _isLoading = false;
 Future getfirebaseData() async { 
    await _store.collection("register2").where("name",  isEqualTo: _test).getDocuments().then((doc){
      setState(() {
        doc.documents.forEach((doc) {
          name = doc.data['name'];
          _km = doc.data['km'];
          _totalKm = doc.data['totalKm'];
          _stepCountValue = doc.data['step'];
          _totalStep = doc.data['totalStep'];
          _remainStepCount = doc.data['remainStep'];
          _tree = doc.data['tree'];
          _lvl = doc.data['lvl'];
      });
      });
    });
    setState(() {
      _guestd = [
        {'id': 1,
        'name': name,
        'km': _km,
        'totalKm': _totalKm,
        'step': _stepCountValue,
        'totalStep': _totalStep,
        'remainStep': _remainStepCount,
        'tree': _tree,
        'lvl': _lvl
        }
      ];
    });
     setState(() {
        _isLoading = false;
     });
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
          getfirebaseData();
          // print(_test);
          // print('-------------------------');
          // print(name);
          // print('-------------------------2');
          // print(_guestd[0]['name']);
          // print('-------------------------3');
          if (_test == _guestd[0]['name']) {
            return new Home(
              userId: _userId,
              auth: widget.auth,
              onSignedOut: _onSignedOut,
              user: _test,
              guestd: this._guestd,
            );
          } else {
            return _buildWaitingScreen();
          }
        } else {
          return _buildWaitingScreen();
        }
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
