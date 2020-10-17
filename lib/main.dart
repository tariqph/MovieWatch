import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'file:///C:/Users/naray/AndroidStudioProjects/watchmovie/lib/FriendViews/friendRequest.dart';
import 'package:watchmovie/Authentication/loginView.dart';
import 'package:watchmovie/Authentication/singUp.dart';
import 'Authentication/splashPage.dart';
import 'MainView/homeView.dart';


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
          '/home': (BuildContext context) => homeView(username),// Change this in future(actual meaning) to named route with passing arguments
          '/login': (BuildContext context) => loginView(),
          '/signup': (BuildContext context) => signInView(),
          '/friendrequest' :(BuildContext context) => friendRequest(),

        });
  }
}




