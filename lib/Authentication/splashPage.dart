import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';



class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) => {
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
                       // print("I'm here111"),
                        //print(s.data()['username']),
                        Navigator.pushReplacementNamed(context, '/home',
                            arguments: UserData(s.get('fullname'), s.get('email'), s.get('username'))
                           )
                            /*MaterialPageRoute(
                                    builder: (context) =>
                                        homeView(s.get('username'))
                                )*/

                      })
                  .catchError((err) => print(err))
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
