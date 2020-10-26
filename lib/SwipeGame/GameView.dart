import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Authentication/splashPage.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';
import 'package:watchmovie/Dismissible_moviecard/dismissibleCard.dart';

class GameView extends StatefulWidget {
  final creator;
  final username;

  GameView(this.creator, this.username);
  @override
  State<StatefulWidget> createState() {
    return GameViewState();
  }
}

class GameViewState extends State<GameView> {
  List<MovieData> movies = [];
  Future future;

  @override
  void initState() {
    future = getMovieData(widget.creator);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Swipe Away',
            style: TextStyle(
                //color: Colors.black
                ),
          ),
          // backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.indigo[50],
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: SizedBox(
            height: 60,
          ),
        ),
        floatingActionButton: Container(

            //floating action button to refresh the Parties created by friends
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.close_rounded,
                color: Colors.red,
                size: 60,
              ),

              onPressed: (){
                cancelGame(widget.creator, widget.username);
              },
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: FutureBuilder(
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

                return dismissibleCard(
                    movies, 'yes', widget.username, widget.creator);
              } else {
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
            }));
  }

  Future getMovieData(docRef) async {
    var arr = [];
    await FirebaseFirestore.instance
        .collection('ActiveParties')
        .doc(docRef)
        .get()
        .then((docs) async {
      int length = docs.get('docRefs').length;
      var collectionRef = docs.get('collectionRef');
      for (int i = 0; i < length / 5; i++) {
        await FirebaseFirestore.instance
            .collection(collectionRef)
            .doc(docs.get('docRefs')[i])
            .get()
            .then((docSnap) {
          arr.add(docSnap);
        }).catchError((onError) {
          print(onError);
        });
      }
    }).catchError((err) {
      print('error');
    });

    return arr;
  }

  Future cancelGame(creator, username)  async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Cancel"),
            content: Text("Are you sure? "),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () async{

                  if(creator == username){
                    await deleteParty(creator);
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) => SplashPage()),
                          (_) => false, );
                  }

                  else{
                    await leaveParty(creator, username);
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) => SplashPage()),
                          (_) => false, );

                  }

                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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

  Future leaveParty(creator, member) async {
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

      int newMemberCount = snapshot.get('memberCount') - 1;
      var members = snapshot.get('member');
      var membersName = snapshot.get('memberName');

     var newMembers = [];
     var newMembersName = [];

      for(int i =0; i< members.length; i++){
        if(members[i] != member){
          newMembers.add(members[i]);
          newMembersName.add(membersName[i]);
        }
      }


      // Perform an update on the document
      transaction.update(docRef, {
        'memberCount': newMemberCount,
        'member': newMembers, //arrayRemove will remove all members from same name
        'memberName': newMembersName,
      });
    })
        .then((value) => print("member count updated"))
        .catchError((error) => print("Failed to leave Party"));
  }

}
