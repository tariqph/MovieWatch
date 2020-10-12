import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:watchmovie/friendRequest.dart';
import 'package:watchmovie/loginView.dart';
import 'package:watchmovie/singUp.dart';
import 'package:watchmovie/splashPage.dart';
import 'homeView.dart';


void main() {

  runApp(MainApp());
}

class MainApp extends StatelessWidget {

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final username="place";
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          // '/task': (BuildContext context) => TaskPage(title: 'Task'),
          '/home': (BuildContext context) => homeView(username),
          '/login': (BuildContext context) => loginView(),
          '/signup': (BuildContext context) => signInView(),
          '/friendrequest' :(BuildContext context) => friendRequest(),

        });
  }
}




