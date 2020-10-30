import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Misc_widgets/circleImage.dart';

// ignore: camel_case_types
class friendRequest extends StatefulWidget {
  //String username;
  // friendRequest(this.username);
  friendRequest({Key key}) : super(key: key);

  @override
  friendRequestState createState() => friendRequestState();
}

// ignore: camel_case_types
class friendRequestState extends State<friendRequest> {
  //final String username = "tariqph";

  void dispose() {
    print('exit');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context).settings.arguments;
    //print("hh1");
    //print(username);

    return FutureBuilder(
        //Future builder to builder after the async retrieval of documents
        future: getData(username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //conditional for when documents are retrieved
            //Map<String, dynamic> data = snapshot.data.data();
            var rec = snapshot.data;

            int len = rec.length;


            return Scaffold(
              backgroundColor: Colors.red[50],
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text("Friend Requests",
                style: TextStyle(
                    fontSize: 18,
                  color: Colors.black
                ),),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body:Column(
              children: [Divider(
                height: 5,
                thickness: 2,
                //color: Colors.black,
              ),ListView.builder(
                shrinkWrap: true,
                  itemCount: len,
                  itemBuilder: (BuildContext context, int index) {
                    return customTile(
                        rec[index], declineRequest, acceptRequest);
                  })]),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text("Friend Requests",
                    style: TextStyle(
                        color: Colors.black,
                            fontSize: 16
                    )
                ),
                backgroundColor: Colors.transparent,
              ),
              body: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blue))),
            );
          }
        });
  }

  Future getData(String username) async {
/*
    Function to get the pending friend requests which retrieves
    documents from FriendPair collection
 */
    var wht = await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: username)
        .where("status", isEqualTo: "pending")
        .get();
    /* print("herrrr");
    print(wht.docs[0]);*/
    return wht.docs;
  }

  void declineRequest(String friend1, String friend2) async {
    /*
    Function to decline friend request which deletes the FriendPair collection document
    with pending status
     */
    await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: friend2)
        .where("friend1", isEqualTo: friend1)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
        setState(() {});
      }
    }).catchError((onError) => print(onError));
  }

  void acceptRequest(String friend1, String friend2) async {
    /* Function to accept friend requests which updates
    the status in FriendPair collection document and triggers
    a cloud function to append individual Users document
     */
    await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: friend2)
        .where("friend1", isEqualTo: friend1)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({"status": "active"});
        setState(() {});
      }
    }).catchError((onError) => print(onError));
  }
}

// ignore: camel_case_types, must_be_immutable
class customTile extends StatelessWidget {
  /* Custom tile object for all pending friend request with
   nested buttons for accepting and declining requests  */
  // This tile is called by a dynamic Listview
  final friendData;
  Function decline, accept;
  customTile(this.friendData, this.decline, this.accept);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
      ListTile(
        leading: circleImageAsset(50, 'assets/images/avatars/${friendData.get('friend1avatar')}.png'),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            friendData.get('friend1'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(friendData.get('friend1name'),
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  color: Colors.blueGrey))
        ]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*IconButton(
            //color: Colors.green,
            icon:Icon(Icons.check_circle,color: Colors.green,),
            iconSize: 50,
            splashRadius: 25,
            onPressed: () async {
              await accept(name.get('friend1'), name.get('friend2'));
            },
          ),
            IconButton(
              //color: Colors.green,
              icon:Icon(Icons.cancel,color: Colors.red,),
              iconSize: 50,
              splashRadius: 25,
              onPressed: () async {
                await decline(name.get('friend1'), name.get('friend2'));

              },
            ),*/
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0)),
                ),
                child: Text("Accept"),
                color: Colors.green[600],
                textColor: Colors.white,
                onPressed: () async {
                  await accept(friendData.get('friend1'), friendData.get('friend2'));
                }),
            SizedBox(
              width: 1,
            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0)),
                ),
                child: Text("Decline"),
                color: Colors.red[600],
                textColor: Colors.white,
                onPressed: () async {
                  await decline(friendData.get('friend1'), friendData.get('friend2'));
                })
          ],
        ),
      ),
    ]);
  }
}
