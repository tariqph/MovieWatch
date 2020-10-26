import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Authentication/loginView.dart';
import 'package:watchmovie/Misc_widgets/circleImage.dart';


// ignore: camel_case_types
class sideMenu extends StatelessWidget {

  final username;
  sideMenu(this.username);
  @override
  Widget build(BuildContext context) {

    Future<void> _signOut()  async{
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure? "),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () async{
                    try {
                      await FirebaseAuth.instance.signOut().then((_) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginView()),
                            (_) => false);
                      });
                    } catch (e) {
                      print(e); //
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

    return /*Container(
      width: 250,
      child: */Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(children: [
              Spacer(),
              circleImageAsset(50,"assets/images/avatar.png"),
               /* backgroundColor: Colors.brown.shade800,
                child: Text('TA'),*/

              Text(
                username,
                style: TextStyle(color: Colors.white,
                    fontSize: 20
                ),
              ),
              Spacer()
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
   // ),
    );
  }
}
