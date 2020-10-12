import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/dismissibleCard.dart';
import 'package:watchmovie/sideMenu.dart';
import 'dataStruct.dart';
import 'sideMenu.dart';
import 'circleImage.dart';

class CustomScaffold extends StatelessWidget {
  final List<MovieData> movies;
  final username;

  CustomScaffold(this.movies,this.username);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      drawer: sideMenu(),

      //top Navigation bar
      appBar: AppBar(
        //leading: Icon(Icons.menu),
        title: Text(username),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                  //tooltip: 'Increase volume by 10',
                  onPressed: () {
                    Navigator.pushNamed(context, '/friendrequest');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.face),
                  //tooltip: 'Increase volume by 10',
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
        backgroundColor: Colors.indigo[900],
      ),

      body: dismissibleCard(movies),
      //body with the Dismissible Card

      //bottom Navigation bar
      bottomNavigationBar:
          /*ClipRRect(
       // borderRadius: BorderRadius.circular(50),
        child: */
          BottomAppBar(
        elevation: 0,
        color: Colors.indigo[50],
        //clipBehavior: Clip.hardEdge,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              Spacer(),
              Container(
                height: 60,
                //color: Colors.indigo[700],
                width: ((MediaQuery.of(context).size.width) / 2) - 10,
                child: RaisedButton(
                   // elevation: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text("Throw PARTY"),
                    color: Colors.indigo[900],
                    textColor: Colors.white,
                    onPressed: () {}),
              ),
              /* Spacer(),
              SizedBox(
                width: 0.5,
                height: 50,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
              ),
              Spacer()*/
              Spacer(),
              Container(
                height: 60,
                // color: Colors.indigo[700],
                width: ((MediaQuery.of(context).size.width) / 2) - 10,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text("Join PARTY"),
                    color: Colors.indigo[900],
                    textColor: Colors.white,
                    onPressed: () {}),
              ),
              Spacer()
            ],
          ),
          SizedBox(
            height: 10,
          )
        ]),
        //),
      ),
      /* floatingActionButton: Container(
        width: 80,
        height: 80,

        decoration: BoxDecoration(shape: BoxShape.circle,
        //color: Colors.red
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
            splashColor: Colors.yellow[900],
            child: circleImageAsset(75, "assets/images/addfriend.png"),
            onPressed: () {}),
      ),*/
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
