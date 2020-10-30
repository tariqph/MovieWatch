import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';
import 'package:watchmovie/SwipeGame/GameView.dart';

class StartParty extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartPartyState();
  }
}

class StartPartyState extends State<StartParty> {
  /*This is the Start Party route and  called when a user taps the Start Party button on the MainView.
  After the button is pressed a document is created in the Parties collection with partyStarted status
   as 'no'. When partyStarted is no in the doc, the doc is searchable by other users to join.
   After the doc creation this route is called. In this route the users who koi the party are visible and
   the creator has the right to kick any user from the party.
  */
  UserData userData;
  String partyStarted = 'no';
  bool userJoined = true;
  int i = 0;

  void dispose() {
    if (partyStarted == 'no') {
      deleteParty(userData.username);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userData = ModalRoute.of(context).settings.arguments;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ActiveParties')
            .doc(userData.username)
            .snapshots(),
        builder: (BuildContext context, snap) {
          //print(snap);
          if(snap.connectionState == ConnectionState.waiting){
            return  Scaffold(
                body:Container(
                    height: ((MediaQuery
                        .of(context)
                        .size
                        .height) * 0.6),
                    child: Column(children: [
                      Spacer(),
                      Center(
                          child: Container(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.blue)))),
                      Spacer()
                    ])));
          }
          else if (snap.data.exists) {
            return Scaffold(
              backgroundColor: baseColor,
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Party Room',
                  style: TextStyle(
                      color: Colors.black
                  ),),
              ),
              body:Column( children:[Row(children: <Widget>[
                Flexible(flex: 5, child: Divider(thickness: 2,)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Friends Joined",
                    style:
                    TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Flexible(flex: 17, child: Divider(thickness: 2,)),
              ]),StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Parties')
                    .doc(userData.username)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: ((MediaQuery
                            .of(context)
                            .size
                            .height) * 0.6),
                        child: Column(children: [
                          Spacer(),
                          Center(
                              child: Container(
                                  child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<
                                          Color>(
                                          Colors.blue)))),
                          Spacer()
                        ]));
                  }
                  int len = 0;

                  //print(snapshot.data.exists);
                  if (snapshot.data.exists) {
                    len = snapshot.data.get('memberCount');
                  }

                  /* if (len == 2 && i == 0) {
            setState(() {
              i++;
              userJoined = true;
            });
          }*/

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: len - 1,
                      itemBuilder: (BuildContext context, int index) {
                        return customTile(snapshot.data, index + 1);
                      });
                },
              )]),

              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                color: Colors.transparent,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    // padding: EdgeInsets.all(5),
                    iconSize: 70,
                    icon: Icon(Icons.play_circle_fill),
                    color: userJoined ? Colors.green[800] : Colors.green[200],
                    onPressed: () {
                      if (userJoined) {
                        setState(() {
                          partyStarted = 'yes';
                        });
                        partyStart(userData.username);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  GameView(
                                      userData.username, userData.username)),
                              (_) => false,
                        );
                      }
                    },
                  ),
                  IconButton(
                    // padding: EdgeInsets.all(5),
                    iconSize: 70,
                    icon: Icon(Icons.cancel),
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]),
              ),
            );
          }
          else {
            return  Scaffold(
              body:Container(
                height: ((MediaQuery
                    .of(context)
                    .size
                    .height) * 0.6),
                child: Column(children: [
                  Spacer(),
                  Center(
                      child: Container(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blue)))),
                  Spacer()
                ])));
          }
        }
          );
    }



  Future deleteParty(String username) async {
    //This function deletes the doc created in the Parties collection whe the User pops the routes or taps the cancel button.
    //This function deletes the doc created in the Parties collection whe the User pops the routes or taps the cancel button.Function
    await FirebaseFirestore.instance
        .collection('Parties')
        .doc(username)
        .delete()
        .then((value) {})
        .catchError((err) {
      print('Could not delete $err');
    });
  }

  Future partyStart(creator) async {
    await FirebaseFirestore.instance
        .collection('Parties')
        .doc(creator)
        .update({'partyStarted': 'yes'})
        .then((value) => print('party started'))
        .catchError((onError) => print(onError));
  }
}

// ignore: camel_case_types
class customTile extends StatelessWidget {
  /* Custom tile object for all pending friend request with
   nested buttons for accepting and declining requests  */
  // This tile is called by a dynamic Listview
  final party;

  final memberNumber;
  //Function decline, accept;
  customTile(this.party, this.memberNumber);

  @override
  Widget build(BuildContext context) {
    print(party.get('member')[memberNumber]);
    return Column(children: [
      ListTile(
        leading: CircleAvatar(
          //radius: 25,
          backgroundImage:
          AssetImage('assets/images/avatars/${party.get('avatars')[memberNumber]}.png'),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            party.get('member')[memberNumber],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(party.get('memberName')[memberNumber],
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
          ),*/
            IconButton(
              //color: Colors.green,
              icon: Icon(
                Icons.eject,
                color: Colors.red,
              ),
              iconSize: 50,
              splashRadius: 25,
              onPressed: () async {
                await kickOut(
                    party.get('member')[memberNumber],
                    party.get('memberName')[memberNumber],
                    party.get('creator'));
              },
            ),
            /*RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text("Kick"),
                color: Colors.red[600],
                textColor: Colors.white,
                onPressed: () async {
                 await kickOut(party.get('member')[memberNumber],party.get('memberName')[memberNumber], party.get('creator'));
                }),
            SizedBox(
              width: 4,
            ),*/
            /*
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text("Decline"),
                color: Colors.red[600],
                textColor: Colors.white,
                onPressed: () async {
                  await decline(name.get('friend1'), name.get('friend2'));
                })*/
          ],
        ),
      ),
     // Divider()
    ]);
  }

  kickOut(member, memberName, creator) async {
    /* This function uses a transaction to eject any user as the creator of the party decides.
    Transaction is used to change the array vale and memberCount atomically.
    * */

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Parties').doc(creator);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(docRef);

          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }

         // int newMemberCount = snapshot.get('memberCount') - 1;
          int newMemberCount = 0;

          var members = snapshot.get('member');
          var membersName = snapshot.get('memberName');
          var avatars = snapshot.get('avatars');

          var newMembers = [];
          var newMembersName = [];
          var newAvatars = [];

          for (int i = 0; i < members.length; i++) {
            if (members[i] != member) {
              newMembers.add(members[i]);
              newMembersName.add(membersName[i]);
              newAvatars.add(avatars[i]);
              newMemberCount++;
            }
          }

          // Perform an update on the document
          transaction.update(docRef, {
            'memberCount': newMemberCount,
            'member': newMembers, //arrayRemove will remove all members from same name
            'memberName': newMembersName,
            'avatars' : newAvatars
          });
        })
        .then((value) => print("member count updated"))
        .catchError((error) => print("Failed to update user followers"));
  }
}
