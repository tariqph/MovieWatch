

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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


  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(  //Future builder to builder after the async retrieval of documents
        future: getData(username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //conditional for when documents are retrieved
            //Map<String, dynamic> data = snapshot.data.data();
            var rec = snapshot.data;
            print(rec);
            int len = rec.length;

            return Scaffold(
              appBar: AppBar(
                title: Text("Friend Requests"),
                backgroundColor: Colors.indigo[900],
              ),
              body: ListView.builder(
                  itemCount: len,
                  itemBuilder: (BuildContext context, int index) {
                    return customTile(rec[index], declineRequest,acceptRequest);
                  }),
            );
          } else {
            return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blue))),
            );
          }
        });
  }

  Future<List<DocumentSnapshot>> getData(String username) async {
/*
    Function to get the pending friend requests which retrieves
    documents from FriendPair collection
 */
    var wht = await Firestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: username)
        .where("status", isEqualTo: "pending")
        .getDocuments();
    //print(wht.documents[0].data);
    return wht.documents;
  }

  void declineRequest(String friend1, String friend2) async {
    /*
    Function to decline friend request which deletes the FriendPair collection document
    with pending status
     */
    await Firestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: friend2)
        .where("friend1", isEqualTo: friend1)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
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
    await Firestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: friend2)
        .where("friend1", isEqualTo: friend1)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({"status": "active"});
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
  final name;
  Function decline, accept;
  customTile(this.name, this.decline,this.accept);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: FlutterLogo(),
        title: Text(name.data['friend1name']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text("Accept"),
                color: Colors.green[600],
                textColor: Colors.white,
                onPressed: () async {
                  await accept(name.data['friend1'], name.data['friend2']);
                }),
            SizedBox(
              width: 4,
            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text("Decline"),
                color: Colors.red[600],
                textColor: Colors.white,
                onPressed: () async {
                  await decline(name.data['friend1'], name.data['friend2']);
                })
          ],
        ),
      ),
      Divider()
    ]);
  }
}
