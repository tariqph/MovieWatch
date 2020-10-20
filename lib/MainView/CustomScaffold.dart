import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Dismissible_moviecard/dismissibleCard.dart';
import '../Data_Structures/dataStruct.dart';
import 'sideMenu.dart';

class CustomScaffold extends StatelessWidget {
  /*
  Scaffold for the main screen with Dismissible moviecards
   */
  final List<MovieData> movies;
  final UserData userData;

  CustomScaffold(this.movies, this.userData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      drawer: sideMenu(userData.username),

      //top Navigation bar
      appBar: AppBar(

       // shadowColor: Colors.black,
        //leading: Icon(Icons.menu),
      /*  title: Text(userData.username,overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white),),*/
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                customNotification(userData.username),
                SizedBox(
                  width: 15,
                ),
                /* IconButton(
                  icon: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                  //tooltip: 'Increase volume by 10',
                  onPressed: () {
                    Navigator.pushNamed(context, '/friendrequest',
                        arguments: username);
                  },
                )*/
                IconButton(
                  color: Colors.white,
                  splashRadius: 25,
                  icon: Icon(Icons.face),
                  //tooltip: 'Increase volume by 10',
                  onPressed: () {
                    Navigator.pushNamed(context, '/friendtabs',
                        arguments: userData);
                  },
                )
              ],
            ),
          ),
        ],
        backgroundColor: Colors.indigo[900],
        elevation: 0,
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
              mainAxisSize: MainAxisSize.max,
              children: [
               Spacer(),
                Container(

                  height: 60,
                  //color: Colors.indigo[700],
                  width: ((MediaQuery.of(context).size.width) / 2) - 10,
                  child: RaisedButton(
                       elevation: 10,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0)),
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
                //Spacer(),
                SizedBox(
                  width: 1,
                ),
                Container(
                  height: 60,
                  // color: Colors.indigo[700],
                  width: ((MediaQuery.of(context).size.width) / 2) - 10,
                  child: RaisedButton(
                    elevation: 10,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0)),
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

// ignore: camel_case_types
class customNotification extends StatefulWidget {
  final username;
  customNotification(this.username);

  @override
  State<StatefulWidget> createState() {
    return customNotificationState();
  }
}

// ignore: camel_case_types
class customNotificationState extends State<customNotification> {
  // ignore: must_call_super
  /* initState(){
  }
*/

  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("FriendPairs")
            .where("friend2", isEqualTo: widget.username)
            .snapshots(),
        builder: (context, strm) {
         // print((strm.hasError));

         // print(strm.connectionState);
          /*  if (strm.hasError) {
            print("here1");
            return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                height: 30,
                width: 30,
                child: IconButton(
                  //iconSize: 35,
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/friendrequest',
                        arguments: widget.username);
                  },
                ));
          }

          if (strm.connectionState == ConnectionState.waiting) {
            print("here3");
            return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                height: 30,
                width: 30,
                child: IconButton(
                  //iconSize: 35,
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/friendrequest',
                        arguments: widget.username);
                  },
                ));
            return Text("Loading");
          }*/

          return FutureBuilder(
              //Future builder to builder after the async retrieval of documents
              future: getData(widget.username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //print(snapshot.data[0].get('friend1name'));
                  if (snapshot.data.length > 0) {
                    String notif;
                    int len = snapshot.data.length;
                    if (len > 9) {
                      notif = "9+";
                    } else {
                      notif = snapshot.data.length.toString();
                    }

                   // print("here4");
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      width: 30,
                      height: 30,
                      child: Stack(
                        children: [
                          IconButton(
                            //iconSize: 35,

                            icon: Icon(
                              Icons.notifications,
                              color: color,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/friendrequest',
                                  arguments: widget.username);
                            },
                          ),
                          Container(
                            /*   width: 30,
                            height: 30,*/
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(top: 5),
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red[700],
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: Text(
                                    notif,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    /* IconButton(
                      icon: Icon(
                        Icons.notifications_active,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/friendrequest',
                            arguments: widget.username);
                      },
                    );*/

                  } else {
                    //print("here5");
                    return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        height: 30,
                        width: 30,
                        child: IconButton(
                          // iconSize: 35,
                          icon: Icon(
                            Icons.notifications,
                            color: color,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/friendrequest',
                                arguments: widget.username);
                          },
                        ));
                  }
                } else {
                 // print("here6");
                  return
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: 30,
                      width: 30,
                      child: IconButton(
                        //iconSize: 35,
                        icon: Icon(
                          Icons.notifications,
                          color: color,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/friendrequest',
                              arguments: widget.username);
                        },
                      ));
                }
              });
        });
  }

/*
  void _timer() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      setState(() {
        print("1 second closer to NYE!");
        // Anything else you want
      });
      _timer();
    });
  }
*/

  Future getData(String username) async {
/*
    Function to get the if there are pending friend requests which retrieves
    documents from FriendPair collection and checks if it is empty
 */
    var wht = await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: widget.username)
        .where("status", isEqualTo: "pending")
        .get();
    //print(wht.documents[0].data);
    return wht.docs;
  }
}

//Exception handling for StreamBuilder

/*if (strm.hasError) {
            return IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/friendrequest',
                    arguments: widget.username);
              },
            );
            print('Something went wrong');
          }*/

/* if (strm.connectionState == ConnectionState.waiting) {
            return IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/friendrequest',
                    arguments: widget.username);
              },
            );
          }
*/
/*if (strm.hasError) {
    return Text('Something went wrong');
    }

    if (strm.connectionState == ConnectionState.waiting) {
    return Text("Loading");
    }
*/
