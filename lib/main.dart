import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'FriendViews/TabView.dart';
import 'package:watchmovie/Authentication/loginView.dart';
import 'package:watchmovie/Authentication/singUp.dart';
import 'Authentication/splashPage.dart';
import 'FriendViews/friendRequest.dart';
import 'MainView/homeView.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   // final username="place";
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          // '/task': (BuildContext context) => TaskPage(title: 'Task'),
          '/home': (BuildContext context) => homeView(),// Change this in future(actual meaning) to named route with passing arguments
          '/login': (BuildContext context) => loginView(),
          '/signup': (BuildContext context) => signInView(),
          '/friendrequest' :(BuildContext context) => friendRequest(),
          '/friendtabs' :(BuildContext context) => TabView(),

        });
  }
}




