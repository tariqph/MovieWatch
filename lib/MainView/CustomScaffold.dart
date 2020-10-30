import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/globals.dart';
import '../Dismissible_moviecard/dismissibleCard.dart';
import '../Data_Structures/dataStruct.dart';
import 'sideMenu.dart';


class CustomScaffold extends StatefulWidget{
  final UserData userData;

  CustomScaffold(this.userData);
  @override
  State<StatefulWidget> createState() {
    return CustomScaffoldState();
  }

}

class CustomScaffoldState extends State<CustomScaffold> {

  Future future;


  @override
  void initState() {
    future = getMovieData();
    avatarId = widget.userData.avatar;
    super.initState();
  }
  /*
  Scaffold for the main screen with Dismissible moviecards
   */
  //final List<MovieData> movies;
  List<MovieData> movies = [];

  chngAvatar(newId){
    setState(() {
      avatarId = newId;
    });
  }



  @override
  Widget build(BuildContext context) {

   // print(avatarId);


    return Scaffold(

      backgroundColor: baseColor,
      drawer: sideMenu(widget.userData.username, chngAvatar),

      //top Navigation bar
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        // shadowColor: Colors.black,
        //leading: Icon(Icons.menu),
        /*  title: Text(userData.username,overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white),),*/
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                customNotification(widget.userData.username),
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
                Container(
                child: IconButton(
                  //color: Colors.white,
                  splashRadius: 25,
                  icon: Icon(Icons.face),
                  //tooltip: 'Increase volume by 10',
                  onPressed: () {
                    Navigator.pushNamed(context, '/friendtabs',
                        arguments: widget.userData);
                  },
                ))
              ],
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body:  FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
             // print(snapshot.data);
              var mData = snapshot.data;

              for (int i = 0; i < snapshot.data.length; i++) {
                movies.add(MovieData(
                    mData[i].get('title'),
                    mData[i].get('duration'),
                    mData[i].get('year'),
                    mData[i].get('genre'),
                    mData[i].get('synopsis'),
                    mData[i].get('image'),
                    mData[i].get('id'),
                    mData[i].get('platform')));
              }
             // movies.shuffle();

              return dismissibleCard(movies, 'no', widget.userData.username, widget.userData.username);
            }
            else {
              return Container(
                  height: ((MediaQuery.of(context).size.height) * 0.6),
                  child: Column(children: [
                    Spacer(),
                    Center(
                        child: Container(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue)))),
                    Spacer()
                  ]));
            }
          }),
      //body with the Dismissible Card


      //bottom Navigation bar
      bottomNavigationBar:
          /*ClipRRect(
       // borderRadius: BorderRadius.circular(50),
        child: */
          BottomAppBar(
        elevation: 0,
        color: Colors.red[50],
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
                    child: Text("Throw PARTY",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                    ),),
                    color: Colors.red[200],
                    //color: Colors.indigo[900],
                   // textColor: Colors.white,
                    onPressed: () {
                      startParty(widget.userData.username, widget.userData.fullname,
                          widget.userData.avatar);
                      Navigator.pushNamed(context, '/startParty',
                          arguments: widget.userData);
                    }),
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
                    child: Text("Join PARTY",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      ),),
                    color: Colors.deepOrange[200],
                   // color: Colors.indigo[900],
                    //textColor: Colors.black,
                    onPressed: () async {
                      Navigator.pushNamed(context, '/joinParty',
                          arguments: widget.userData);
                    }),
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

  Future startParty(String username, String fullname, avatar) async {

    //Function for when party starts
    var array = [];

    for (int i = 4; i < username.length + 1; i++) {
      array.add(username.substring(0, i).toLowerCase());
    }
    for (int i = 4; i < fullname.length + 1; i++) {
      array.add(fullname.substring(0, i).toLowerCase());
    }

    await FirebaseFirestore.instance
        .collection('Parties')
        .doc(username)
        .set({
          'creator': username,
          'creatorName': fullname,
          'memberCount': 1,
          'member': [username],
          'memberName': [fullname],
           'avatars' : [avatar],
          'searchArray': array,
          'partyStarted': 'no',
          'docRef': 'test',
          'collectionRef' : 'Test',
           username : []
        })
        .then((doc) {})
        .catchError((err) {
          print('Error creating document $err');
        });
  }

  Future getMovieData() async {
    var arr = [];
    await FirebaseFirestore.instance
        .collection('MovieRef')
        .doc('test')
        .get()
        .then((docs) async {
      int length = docs.get('docRefs').length;
      for (int i = 0; i < length / 5; i++) {
        await FirebaseFirestore.instance
            .collection('Test')
            .doc(docs.get('docRefs')[i])
            .get()
            .then((docSnap) {
          arr.add(docSnap);
          if(i==(length/5)-1){
            arr.shuffle();
          }
        }).catchError((onError) {
          print(onError);
        });
      }
    }).catchError((err) {
      print('error');
    });

    return arr;
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
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("FriendPairs")
            .where("friend2", isEqualTo: widget.username)
             .where("status", isEqualTo: 'pending')
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
                    return
                      InkWell(
                        radius:  60,
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        onTap: (){
                          Navigator.pushNamed(context, '/friendrequest',
                              arguments: widget.username);
                        },
                      child:Container(
                        margin: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      width: 35,
                      height: 35,
                      child: Stack(

                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            //iconSize: 35,

                            icon: Icon(
                              Icons.notifications,
                              color: color,
                            ),
                           /*onPressed: () {

                            },*/
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
                    )
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
                        height: 35,
                        width: 35,
                        child: IconButton(
                          splashRadius: 25,
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
                  return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: 35,
                      width: 35,
                      child: IconButton(
                        splashRadius: 25,
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
