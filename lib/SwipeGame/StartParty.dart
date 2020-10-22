import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';

class StartParty extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartPartyState();
  }
}

class StartPartyState extends State<StartParty> {
  UserData userData;

  void dispose() {
    deleteParty(userData.username);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('Start Party'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Parties')
              .doc(userData.username)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
          int len =0;

            print(snapshot.data.exists);
            if(snapshot.data.exists){
              len = snapshot.data.get('memberCount');
            }


            return ListView.builder(
                shrinkWrap: true,
                itemCount: len - 1,
                itemBuilder: (BuildContext context, int index) {
                  return customTile(snapshot.data, index +1);
                });
          },
        ));
  }

  Future deleteParty(String username) async {
    await FirebaseFirestore.instance
        .collection('Parties')
        .doc(username)
        .delete()
        .then((value) {})
        .catchError((err) {
      print('Could not delete $err');
    });
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
  customTile(this.party,this.memberNumber);

  @override
  Widget build(BuildContext context) {
    print(party.get('member')[memberNumber]);
    return Column(children: [
      ListTile(
        leading: CircleAvatar(
          //radius: 25,
          backgroundImage: AssetImage('assets/images/avatar.png'),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            party.get('member')[memberNumber],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(party.get('memberName')[memberNumber],
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.blueGrey))
        ]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [/*IconButton(
            //color: Colors.green,
            icon:Icon(Icons.check_circle,color: Colors.green,),
            iconSize: 50,
            splashRadius: 25,
            onPressed: () async {
              await accept(name.get('friend1'), name.get('friend2'));
            },
          ),*/
            /*IconButton(
              //color: Colors.green,
              icon:Icon(Icons.cancel,color: Colors.red,),
              iconSize: 50,
              splashRadius: 25,
              onPressed: () async {
                //await kickOut(name.get('friend1'), name.get('friend2'));

              },
            ),*/
             RaisedButton(
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
            ),
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
      Divider()
    ]);
  }

  kickOut( member,memberName ,creator) async{


    DocumentReference docRef=  FirebaseFirestore.instance
        .collection('Parties').doc(creator);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      // Update the follower count based on the current count
      // Note: this could be done without a transaction
      // by updating the population using FieldValue.increment()

      int newMemberCount = snapshot.get('memberCount') - 1;

      // Perform an update on the document
      transaction.update(docRef, {'memberCount': newMemberCount,
      'member': FieldValue.arrayRemove([member]),
        'memberName': FieldValue.arrayRemove([memberName]),
      });

      // Return the new count
      //return newFollowerCount;
    })
        .then((value) => print("Follower count updated to $value"))
        .catchError((error) => print("Failed to update user followers: $error"));

  }

}

