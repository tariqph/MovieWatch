import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/circleImage.dart';
import 'package:watchmovie/loginView.dart';

// ignore: camel_case_types
class sideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Logout"),
                content: Text("Are you sure? "),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      try {
               FirebaseAuth.instance.signOut().then((_) {
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => loginView()),
              (_) => false);
              });
              } catch (e) {
              print(e); // TODO: show dialog with error
              }
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });


    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(children: [
              Text(
                'Side menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              circleImageAsset(70, "assets/images/netflix.png")
            ]),
            decoration: BoxDecoration(
              color: Colors.indigo[900],
              /*image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg')
                )*/
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              _signOut();
            },
          ),
        ],
      ),
    );
  }
}
