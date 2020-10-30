import 'package:flutter/material.dart';
import 'package:watchmovie/FriendViews/FriendList.dart';
import 'package:watchmovie/FriendViews/sendRequest.dart';

class TabView extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.red[50],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(//\icon: Icon(Icons.directions_car,
               // color: Colors.blue), text: "Send Request",
                  child: Text("Send Requests",
                    style: TextStyle(fontSize: 16,
                    color: Colors.black),
                  ),

              ),
              Tab(//icon: Icon(Icons.boot),
                //text: "Friends",
                child: Text("Friends",
                  style: TextStyle(fontSize: 16,
                      color: Colors.black),
                ),
                ),
            ],
          ),
          //title: Text('Persistent Tab Demo'),
        ),
        body: TabBarView(
          children: [
        sendRequest(),
            FriendList(),
          ],
        ),
      ),
    );
  }
}