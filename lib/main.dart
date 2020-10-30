import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:watchmovie/MainView/AvatarGrid.dart';
import 'package:watchmovie/SwipeGame/StartParty.dart';
import 'FriendViews/TabView.dart';
import 'package:watchmovie/Authentication/loginView.dart';
import 'package:watchmovie/Authentication/singUp.dart';
import 'Authentication/splashPage.dart';
import 'FriendViews/friendRequest.dart';
import 'MainView/homeView.dart';
import 'SwipeGame/JoinParty.dart';


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

        onGenerateRoute: (settings) {
    if (settings.name == "/signup") {
      return _createRoute1(signInView(), settings//settings is passed because without it arguments are not passed
      );
    }
    if (settings.name == "/friendtabs") {
      return _createRoute1(TabView(), settings);
    }
    if (settings.name == "/friendrequest") {
      return _createRoute1(friendRequest(), settings);
    }
    if (settings.name == "/startParty") {
      return _createRoute2(StartParty(), settings);
    }
    if (settings.name == "/joinParty") {
      return _createRoute2(JoinParty(), settings);
    }

    return null;
    },

        routes: <String, WidgetBuilder>{// named route are looked in routes first and if not found then in onGenerateRoute
          // '/task': (BuildContext context) => TaskPage(title: 'Task'),
          '/home': (BuildContext context) => homeView(),// Change this in future(actual meaning) to named route with passing arguments
          '/login': (BuildContext context) => loginView(),
         // '/avatarGrid':(BuildContext context) => AvatarGrid(),
         // '/signup': (BuildContext context) => signInView(),
          //'/friendrequest' :(BuildContext context) => friendRequest(),
          //'/friendtabs' :(BuildContext context) => TabView(),
          //'/startParty' :(BuildContext context) => StartParty(),
         // '/joinParty' :(BuildContext context) => JoinParty(),

        });
  }
}

Route _createRoute1(Widget widget, settings) {


  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createRoute2(Widget widget, settings) {


  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}






