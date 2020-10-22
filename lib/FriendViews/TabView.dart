import 'package:flutter/material.dart';
import 'package:watchmovie/FriendViews/FriendList.dart';
import 'package:watchmovie/FriendViews/sendRequest.dart';

class TabView extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(//icon: Icon(Icons.directions_car,
               // color: Colors.blue), text: "Send Request",
                  child: Text("Send Request",
                    style: TextStyle(fontSize: 20),
                  )
              ),
              Tab(//icon: Icon(Icons.directions_transit),
                //text: "Friends",
                child: Text("Friends",
                  style: TextStyle(fontSize: 20),
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