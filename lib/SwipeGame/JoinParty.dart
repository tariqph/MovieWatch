import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchmovie/Misc_widgets/circleImage.dart';
import 'package:watchmovie/SwipeGame/GameView.dart';

class JoinParty extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JoinPartyState();
  }
}

class JoinPartyState extends State<JoinParty> {
  /* This is the Join party view in which the user join a selected Party created by another user.
  This route is navigated after tapping the Join Party button in CustomScaffold.
  This widget utilizes multiple Future Builder and Streambuilder to implement the joining functionality.
   There are multiple ways for a user to join a created party. All the parties with partyStarted status as
   'no' are searchable explicitly by the user. Also, the parties created by a users who are an active friend are
   automatically visible. When a user taps a created party, the user's data is appended and memeberCount is updated
   in the party doc using a transaction. After that a dialog box opens up with details of the current party
   members which is updated using a streambuilder anytime a new user joins the party.
  * */

  TextEditingController searchParty = TextEditingController();
  bool isSearching = false;
  bool showFriends = true;
  UserData userData;
  //var friends;

  JoinPartyState() {
    searchParty.addListener(() {
      //listener to th Textformfield
      if (searchParty.text.length > 3) {
        setState(() {
          isSearching = true;
        });
      } else {
        setState(() {
          showFriends = false;
          isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    userData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: baseColor,
        //Base Scaffold is build first with the search bar is build without the future builder
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Join Party',
            style: TextStyle(color: Colors.black),
          ),
        ),
        floatingActionButton: Container(
          //floating action button to refresh the Parties created by friends
          width: 60,
          height: 60,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            //color: Colors.red
          ),
          child: FloatingActionButton(
              backgroundColor: Colors.teal,
              //splashColor: Colors.yellow[900],
              child: Icon(
                Icons.refresh,
                size: 50,
              ),
              onPressed: () {
                setState(() {
                  showFriends = true;
                });
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: EdgeInsets.all(10),
              child: customFormField("Search for Parties", searchParty)),
          (showFriends) //ternary operator used, if showFriends is true then parties created
              //  by users who are already friends is listed(if present)
              ? FutureBuilder(
                  future: showParties(userData.username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data != null) {
                        print(snapshot.data.docs.length);
                        int len = snapshot.data.docs.length;
                        var docs = snapshot.data.docs;

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: len,
                            itemBuilder: (BuildContext context, int index) {
                              // return Text('element$index');
                              return customTile(docs[index], userData);
                            });
                      } else {
                        return Container();
                      }
                    } else {
                      return Container(
                          height: ((MediaQuery.of(context).size.height) * 0.6),
                          child: Column(children: [
                            Spacer(),
                            Center(
                                child: Container(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.blue)))),
                            Spacer()
                          ]));
                    }
                  })
              : (isSearching)
                  ? FutureBuilder(
                      //Future builder to builder after the async retrieval of documents
                      future: getParty(searchParty.text.toLowerCase()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          //conditional for when documents are retrieved
                          //Map<String, dynamic> data = snapshot.data.data();
                          var rec = snapshot.data.docs;
                          // print(rec);
                          //print("kil");
                          int len = rec.length;

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: len,
                              itemBuilder: (BuildContext context, int index) {
                                return customTile(rec[index], userData);
                              });
                        } else {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.blue)));
                        }
                      })
                  : Container(
                      child: Text(''),
                    )
        ]));
  }

  /*String searchValidator(String value) {
    if (!(value == value.toLowerCase())) {
      return 'Please use lowercase';
    } else {
      return null;
    }
  }*/

  Future showParties(String username) async {
/*
    Function to get whether the searched user selected is a friend or not
 */
    List searchArray = [];
    //List len = [];

    //check this function later for async functionality and limit the number of friends to 10

    //This function doesn't work if the user has no friends

    await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend1", isEqualTo: username)
        .where("status", isEqualTo: 'active')
        .get()
        .then((wht1) {
      wht1.docs.forEach((doc) {
        searchArray.add(doc.get('friend2'));
      });
    }).catchError((onError) {
      print("error $onError");
    });
    await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: username)
        .where("status", isEqualTo: 'active')
        .get()
        .then((wht1) {
      wht1.docs.forEach((doc) {
        searchArray.add(doc.get('friend1'));
      });
    }).catchError((onError) {
      print("error $onError");
    });

    return await FirebaseFirestore.instance
        .collection('Parties')
        .where('creator', whereIn: searchArray)
        .where('partyStarted', isEqualTo: 'no')
        .get();
  }

  Future getParty(String username) async {
/*
  This function gets the parties from the search functionality
 */
    var wht = await FirebaseFirestore.instance
        .collection("Parties")
        .where("searchArray", arrayContains: username)
        .where('partyStarted', isEqualTo: 'no')
        //.where("username", notEqualto: "pending")
        .limit(10)
        .get();
    //print(wht.documents[0].data);
    return wht;
  }
}

// ignore: camel_case_types
class customFormField extends StatelessWidget {
  final txt;
  // final bool pwd;
  final TextEditingController ctrl;
  //final String Function(String) validate;
  customFormField(this.txt, this.ctrl);

  @override
  Widget build(BuildContext context) {
    return /*Container(
      height: 50,
      child:*/
        TextFormField(
      minLines: 1,
      maxLines: 3,
      //  validator: validate, //put in a validator for only
      controller: ctrl,
      autovalidateMode: AutovalidateMode.always,
      //obscureText: pwd,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        prefixIcon: Icon(CupertinoIcons.search),
        hintText: txt,
        fillColor: Colors.black.withOpacity(0.1),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.6), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.05),
            width: 0.5,
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class customTile extends StatelessWidget {
  /* Custom tile object for all parties created by User's friends  */
  // This tile is called by a dynamic Listview
  final partyDoc;
  final userData;

  customTile(this.partyDoc, this.userData);

  @override
  Widget build(BuildContext context) {
    /* if(userData.username == name.get('username')){
      return Container();
    }
    else {*/
    return Column(mainAxisSize: MainAxisSize.min, children: [
      //Divider(),

      ListTile(
          leading: circleImageAsset(50, 'assets/images/avatars/${partyDoc.get('avatars')[0]}.png'),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${partyDoc.get('creatorName')}\'s Party',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(partyDoc.get('creator'),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    color: Colors.blueGrey))
          ]),
          onTap: () async {
            int memberNumber = await joinParty(
                userData.username, userData.fullname, partyDoc.get('creator'));
            print(memberNumber);
            /*print(partyDoc.get('creator'));
            print(userData.username);
            print(userData.fullname);*/

            popUp(context, partyDoc.get('creator'), userData.username,
                userData.fullname, memberNumber);
          }),
    ]);
  }

  joinParty(member, memberName, creator) async {
    int newMemberCount;

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Parties').doc(creator);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      newMemberCount = snapshot.get('memberCount') + 1;
      var members = snapshot.get('member');
      var membersName = snapshot.get('memberName');
      var avatars = snapshot.get('avatars');

      members.add(userData.username);
      membersName.add(userData.fullname);
      avatars.add(userData.avatar);

      // Perform an update on the document
      transaction.set(
          docRef,
          {
            'memberCount': newMemberCount,
            'member': members,
            'memberName': membersName,
            'avatars': avatars,
            member: []
          },
          SetOptions(merge: true));

      // return newMemberCount;
    }).then((value) {
      print("member count updated");
      return newMemberCount;
    }).catchError((error) => print("Failed to join Party $error"));
  }

  Future popUp(context, creator, member, memberName, memberNumber) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PartyCard(creator, member, memberName, memberNumber);
        });
  }
}

class PartyCard extends StatefulWidget {
  final creator;
  final member;
  final memberName;
  final memberNumber;

  PartyCard(this.creator, this.member, this.memberName, this.memberNumber);

  @override
  State<StatefulWidget> createState() {
    return PartyCardState();
  }
}

class PartyCardState extends State<PartyCard> {
  void dispose() {
    //The function leaveParty is automatically called when the dialog box showing the party member is popped.

    if (partyStarted == 'no') {
      leaveParty(widget.creator, widget.member, widget.memberName,
          widget.memberNumber);
    }
    super.dispose();
  }

  String partyStarted = 'no';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Parties')
            .doc(widget.creator)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,

                //color: Colors.red,
                child: Card(
                  //color: Colors.green[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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

          print(snapshot.data.exists);

          if (snapshot.data.exists) {
            bool flag = false;

            for (int i = 0; i < snapshot.data.get('member').length; i++) {
              if (snapshot.data.get('member')[i] == widget.member) {
                flag = true;
              }
            }
            if (flag) {
              return FractionallySizedBox(
                  heightFactor: 0.6,
                  widthFactor: 0.9,

                  //color: Colors.red,
                  child: Card(
                      //color: Colors.green[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: Column(
                          //mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                                flex: 3,
                                child: FractionallySizedBox(
                                    heightFactor: 1,
                                    child: Center(
                                        child: Text(
                                      '${snapshot.data.get('creatorName')}\'s Party',
                                      style: TextStyle(fontSize: 22),
                                    )))),
                            Row(children: <Widget>[
                              Flexible(flex: 3, child: Divider()),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Friends Joined",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                              Flexible(flex: 17, child: Divider()),
                            ]),
                            Flexible(
                                flex: 12,
                                child: FractionallySizedBox(
                                    heightFactor: 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 40),
                                      // color: Colors.red,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemExtent: 50,
                                          itemCount:
                                              snapshot.data.get('memberCount'),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            // return Text('element$index');
                                            return Container(
                                              //margin: EdgeInsets.al,
                                              height: 100,
                                              child: ListTile(

                                                //dense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0),

                                                /*leading: Icon(Icons.stop_circle,
                      color: Colors.green,
                      size: 10,),*/              leading: circleImageAsset(40,
                                                  'assets/images/avatars/'
                                                      '${snapshot.data.get(
                                                      'avatars')[index]}.png'),
                                                title: Row(
                                                  children: [

                                                    Text(
                                                      snapshot.data.get(
                                                          'memberName')[index],
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    )
                                                  ],
                                                )));
                                          }),
                                    ))),
                            Flexible(
                                flex: 4,
                                child: FractionallySizedBox(
                                    heightFactor: 1,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                // padding: EdgeInsets.all(5),
                                                iconSize: 70,
                                                icon: Icon(
                                                    Icons.play_circle_fill),
                                                color: (snapshot.data.get(
                                                            'partyStarted') ==
                                                        'no')
                                                    ? Colors.green[200]
                                                    : Colors.green[800],
                                                onPressed: () {
                                                  if (snapshot.data.get(
                                                          'partyStarted') ==
                                                      'yes') {
                                                    setState(() {
                                                      partyStarted = 'yes';
                                                    });

                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              GameView(
                                                                  widget
                                                                      .creator,
                                                                  widget
                                                                      .member)),
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
                                            ]))))
                          ])));
            } else {
              return FractionallySizedBox(
                  heightFactor: 0.6,
                  widthFactor: 0.9,

                  //color: Colors.red,
                  child: Card(
                      color: Color.fromRGBO(0, 152, 191, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 100,),
                            Image.asset('assets/images/kicked.png'),
                            SizedBox(height: 50,),
                            Text(
                              "You've been Booted",
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      )));
            }
          } else {
            return FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,

                //color: Colors.red,
                child: Card(
                    //color: Colors.green[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 100,),
                          Image.asset('assets/images/cancelled.png'),
                          SizedBox(height: 50,),
                          Text(
                            "Party Cancelled",
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    )));
          }
        });
  }

  Future leaveParty(creator, member, memberName, memberNumber) async {
    /*This function uses a transaction to remove the user data from the party doc
     after the user decides to leave the party.
     */
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
            'member':
                newMembers, //arrayRemove will remove all members from same name
            'memberName': newMembersName,
            'avatars': newAvatars
          });
        })
        .then((value) => print("member count updated"))
        .catchError((error) => print("Failed to leave Party"));
  }
}
