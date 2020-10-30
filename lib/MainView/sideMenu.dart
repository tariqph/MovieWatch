import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Authentication/loginView.dart';
//import 'package:watchmovie/Data_Structures/dataStruct.dart';
import 'package:watchmovie/Data_Structures/globals.dart';
import 'package:watchmovie/MainView/AvatarGrid.dart';
import 'package:watchmovie/Misc_widgets/circleImage.dart';

// ignore: camel_case_types
class sideMenu extends StatefulWidget {
  final username;
  Function chngAvatar;
  sideMenu(this.username, this.chngAvatar);
  State<StatefulWidget> createState() {
    return sideMenuState(username, chngAvatar);
  }
}

// ignore: camel_case_types
class sideMenuState extends State<sideMenu> {
  final username;
  Function chngAvatar;
  sideMenuState(this.username, this.chngAvatar);
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
                  onPressed: () async {
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
// print('ggg${globals.avatarId}');
    return Container(
        width: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(children: [
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        //showAvatars(context);
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            barrierDismissible: true,
                            pageBuilder: (BuildContext context, _, __) {
                              return AvatarGrid(username, refresh, chngAvatar);
                            }));
                      },
                      child: Hero(
                          tag: avatarId,
                          child: circleImageAsset(
                              50, "assets/images/avatars/$avatarId.png"))),
                  /* backgroundColor: Colors.brown.shade800,
                child: Text('TA'),*/

                  Text(
                    username,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Spacer()
                ]),
                decoration: BoxDecoration(
                  color: Colors.red[300],
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
        ));
  }
/*
  Future showAvatars(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AvatarGrid();
        });
  }*/

  refresh(newAvatar) {
    setState(() {
    });

  }
}
