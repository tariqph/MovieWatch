import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../MainView/homeView.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user)  => {
              if (user == null)
                {
                  //print("I'm here")
                  Navigator.pushReplacementNamed(context, "/login")
                }
              else
                {
                  // print("I'm here"),
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user.uid)
                      .get()
                      .then((DocumentSnapshot s) => {
                            // print("I'm here1"),
                            print(s.data()['username']),
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        homeView(s.data()['username'])))
                          })
                      .catchError((err) => print("hhuuu"))
                }
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Center(
        child: Container(
          child: Text("WatchParty",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
