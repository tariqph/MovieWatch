import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/dismissibleCard.dart';
import 'package:watchmovie/sideMenu.dart';
import 'dataStruct.dart';
import 'sideMenu.dart';
import 'circleImage.dart';

class CustomScaffold extends StatelessWidget {
  final List<MovieData> movies;

  CustomScaffold(this.movies);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      drawer: sideMenu(),

      //top Navigation bar
      appBar: AppBar(
        //leading: Icon(Icons.menu),
        title: Text('WatchParty'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Icon(Icons.filter_alt_sharp),
          ),
        ],
        backgroundColor: Colors.indigo,
      ),

      body: dismissibleCard(movies), //body with the Dismissible Card

      //bottom Navigation bar
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BottomAppBar(
          //clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              Container(
                height: 60,
                color: Colors.indigo[700],
                width: ((MediaQuery.of(context).size.width)/2)-1,
                child: OutlineButton.icon(
                  textColor: Colors.white,
                  highlightedBorderColor: Colors.black.withOpacity(0.12),
                  onPressed: () {
                    // Respond to button press
                  },
                  icon: Icon(Icons.party_mode, size: 30),
                  label: Text("CREATE PARTY   "),
                ),
              ),
              Spacer(),
              SizedBox(
                width: 0.5,
                height: 50,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
              ),
              Spacer(),
              Container(
                height: 60,
                color: Colors.indigo[700],
                width: ((MediaQuery.of(context).size.width)/2)-1,
                child: OutlineButton.icon(
                  textColor: CupertinoColors.white,
                  highlightedBorderColor: Colors.black.withOpacity(0.12),
                  onPressed: () {
                    // Respond to button press
                  },
                  icon: Icon(Icons.add, size: 30),
                  label: Text("     JOIN PARTY  "),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
