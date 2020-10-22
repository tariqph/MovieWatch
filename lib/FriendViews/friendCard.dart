import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class friendCard extends StatefulWidget {
  final username;
  final friendUsername;
  final friendFullname;
  final fullname;

  friendCard(
      this.username, this.friendUsername, this.friendFullname, this.fullname);

  @override
  State<StatefulWidget> createState() {
    return friendCardState();
  }
}

// ignore: camel_case_types
class friendCardState extends State<friendCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(widget.username, widget.friendUsername),
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.done)) {
            //print(snapshot.data[0][0].get('status'));
            //print(snapshot.data[0].length);

            if (snapshot.data[0].length == 1) {
              return fCard(
                  widget.username,
                  widget.friendUsername,
                  widget.friendFullname,
                  widget.fullname,
                  snapshot.data[0][0].get('status'));
            } else if (snapshot.data[1].length == 1) {
              return fCard(
                  widget.username,
                  widget.friendUsername,
                  widget.friendFullname,
                  widget.fullname,
                  snapshot.data[1][0].get('status'));
            } else {
              return fCard(widget.username, widget.friendUsername,
                  widget.friendFullname, widget.fullname, 'notF');
            }
          } else {
            return FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,

                //color: Colors.red,
                child: Card(
                  //color: Colors.green[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  elevation: 2,
                  child: Shimmer.fromColors(
                      child: Center(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[600],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 10,
                                width: 200,
                                color: Colors.grey[300],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 10,
                                  width: 100,
                                  color: Colors.grey[300]),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                  height: 10,
                                  width: 200,
                                  color: Colors.grey[300]),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 10,
                                  width: 100,
                                  color: Colors.grey[300]),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                  height: 10,
                                  width: 200,
                                  color: Colors.grey[300]),
                              SizedBox(
                                height: 30,
                              ),
                            ]),
                      ),
                      enabled: true,
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100]),
                ));
          }
        });
  }

  Future getData(String username, String friend) async {
/*
    Function to get whether the searched user selected is a friend or not
 */
    var wht1 = await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend1", isEqualTo: username)
        .where("friend2", isEqualTo: friend)
        .get();
    var wht2 = await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend1", isEqualTo: friend)
        .where("friend2", isEqualTo: username)
        .get();
    //print(wht.documents[0].data);
    return [wht1.docs, wht2.docs];
    //return wht1.docs;
  }
}


// ignore: camel_case_types
class fCard extends StatelessWidget {
  final username;
  final friendUsername;
  final friendFullname;
  final fullname;
  final status;


  fCard(this.username, this.friendUsername, this.friendFullname, this.fullname,
      this.status);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.6,
        widthFactor: 0.9,

        //color: Colors.red,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            elevation: 2,
            //color: Colors.teal,

            child: Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.account_circle,
                  size: 130,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  friendFullname,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                    color: Colors.grey,
                    child: SizedBox(
                      width: 150,
                      height: 0.5,
                    )),
                Text(
                  friendUsername,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 60,
                ),
                (status == "active" || status == "pending")
                ?(status == 'active')?Text('Friends'):Text("Pending Request")
                :Text(""),
                (status == "active" || status == "pending")
                    ? RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        icon: (status == "active")
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : Icon(Icons.pending, color: Colors.red),
                        label: (status == "active")
                            ? Text("Unfriend")
                            : Text("Delete Request"),
                        color: Colors.green[600],
                        textColor: Colors.white,
                        onPressed: () async {
                          await unFriend(username, friendUsername);
                          Navigator.of(context).pop();
                        })
                    : RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        icon: Icon(Icons.add_circle, color: Colors.red),
                        label: Text("Send Request"),
                        color: Colors.green[600],
                        textColor: Colors.white,
                        onPressed: () async {
                          await send(username, fullname, friendUsername,
                              friendFullname);
                          Navigator.of(context).pop();
                        })
              ],
            ))));
  }

  Future send(String friend1, String friend1name, String friend2,
  String friend2name) async {
  /* Function to sen friend requests which creates a doc
    in FriendPair collection
     */
  await FirebaseFirestore.instance
      .collection("FriendPairs")
      .add({
  'friend1': friend1,
  'friend1name': friend1name,
  'friend2': friend2,
  'friend2name': friend2name,
  'status': 'pending'
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
  }

  Future unFriend(String friend1, String friend2
      ) async {
    /* Function to sen friend requests which creates a doc
    in FriendPair collection
     */
    await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend1",isEqualTo:friend1)
        .where("friend2",isEqualTo:friend2)
        .get()
        .then((querySnapshot){
          querySnapshot.docs.forEach((doc){
            doc.reference.delete();
          });

    }).catchError((error) => print("Failed to delete user: $error"));

    await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend1",isEqualTo:friend2)
        .where("friend2",isEqualTo:friend1)
        .get()
        .then((querySnapshot){
      querySnapshot.docs.forEach((doc){
        doc.reference.delete();
      });

    }).catchError((error) => print("Failed to delete user: $error"));


  }

}
