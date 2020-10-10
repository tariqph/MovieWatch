import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
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
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          // '/task': (BuildContext context) => TaskPage(title: 'Task'),
          '/home': (BuildContext context) => homeView(),
          '/login': (BuildContext context) => loginView(),
          '/signup': (BuildContext context) => signInView(),
        });
  }
}




