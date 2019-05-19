import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:flutter_db_operations/database_helper.dart';
import '../models/guest.dart';
import 'dart:async';


class TestPage extends StatefulWidget {
  @override
 TestPageState createState() {
    return TestPageState();
  }

}



class TestPageState extends State<TestPage> {
  GuestProvider db = GuestProvider();
  final TextEditingController _subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

 @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    db.open('guest.db');
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    String guestName = '';
    return Scaffold(
      appBar: AppBar(
        title: Text("User Stat"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: Text("HI DUDE"),
            ),
            _form1(context),
            // db.getGuest(1) != null?
            // FutureBuilder(
            //   future: db.getGuest(1),
            //   builder: (BuildContext context, AsyncSnapshot<Guest> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       print("connectioning");
            //         if (snapshot.hasData) {
            //           Guest g = snapshot.data;
            //           guestName = g.getkm;
            //           print("this is what u r w8ing for a long time =======> $guestName");
            //           return Container();
            //         } else {
            //           return Center(
            //             child: Text("No Guest"),
            //           );
            //         }
            //     } else {
            //       return CircularProgressIndicator();
            //     }
            //   },
              // Center(child: Text("there is a guest."),
            // ),
            // :
            // Center(child: Text("no guest"),),
            Text("guest name is =>$guestName"),
          ]      
        )
      ),
    );
  }




  Widget _form1(BuildContext context){
      return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _subjectController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),//ryu version
            child: RaisedButton(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  print("======");
                  print(await db.db.rawQuery("select * from Guest"));
                  print("======");
                  Guest g = Guest();
                  int aaa = 1000;
                  // g.step = 2;
                  g.km = _subjectController.text;
                  if (db.db == null) {
                    print("111111");
                    await db.insert(g);
                  } else {
                    // await db.update(g);
                  //   print(db.update(g).toString()+'-----------------------------------------------------------------------');
                  }
                  List<Map> e = await db.db.rawQuery("select * from Guest");
                  int test = e[0]['step'];
                  test+=1;
                  String a ='';
                  // db.deleting(1);
                  print(await db.db.rawUpdate("update Guest set step = $test where id=1"));
                  print(e);
                  
                  // print("==========>${e[0]['km']}");
                  a = await db.db.rawQuery("select * from Guest").toString();
                  print(a);
                  print('added guest');
                  
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
















}












