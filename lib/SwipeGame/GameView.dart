import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Authentication/splashPage.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';
import 'package:watchmovie/Dismissible_moviecard/dismissibleCard.dart';
import 'package:watchmovie/Dismissible_moviecard/movieCard.dart';

class GameView extends StatefulWidget {
  final creator;
  final username;

  GameView(this.creator, this.username);
  @override
  State<StatefulWidget> createState() {
    return GameViewState();
  }
}

class GameViewState extends State<GameView> with TickerProviderStateMixin {
  List<MovieData> movies = [];
  Future future;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {

    future = getMovieData(widget.creator);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      //lowerBound: 0.6,
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  /*  _controller.reset();
    _controller.forward();*/

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Swipe Away',
            style: TextStyle(
                color: Colors.black
                ),
          ),
          // backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.red[50],
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
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.close_rounded,
                color: Colors.red,
                size: 60,
              ),
              onPressed: () {
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

                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('ActiveParties')
                        .doc(widget.creator)
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      if(snap.data.exists) {
                        if (snap.data.get('match') == 'no') {
                        /*  print('lll');
                          print(movies.length);
                          print('kkk');*/
                          return dismissibleCard(
                              movies, 'yes', widget.username, widget.creator);
                        }
                        else {
                          _controller.reset();
                          _controller.forward();
                          print(snap.data.get('movie')['title']);
                          return ScaleTransition(
                              scale: _animation, child:
                          Animate(
                              snap.data.get('movie')['title'],
                              snap.data.get('movie')['duration'],
                              snap.data.get('movie')['year'],
                              snap.data.get('movie')['genre'],
                              snap.data.get('movie')['synopsis'],
                              snap.data.get('movie')['image'],
                              snap.data.get('movie')['platform'])
                          );
                        }
                      }
                      else{
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
                    });
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

  Future cancelGame(creator, username) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Cancel"),
            content: Text("Are you sure? "),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () async {
                  if (creator == username) {
                    await deleteParty(creator);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SplashPage()),
                      ModalRoute.withName('/home'),
                    );
                  } else {
                    await leaveParty(creator, username);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SplashPage()),
                      (_) => false,
                    );
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

          //int newMemberCount = snapshot.get('memberCount') - 1;
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
        .catchError((error) => print("Failed to leave Party"));
  }
}


class Animate extends StatefulWidget{

  final title, dur, year, genre, synopsis, platform;
  final image;
  Animate(
      this.title, this.dur, this.year, this.genre, this.synopsis, this.image, this.platform);

  @override
  State<StatefulWidget> createState() {
    return AnimateState();
  }

}

class AnimateState extends State<Animate>{

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(

      duration: const Duration(milliseconds: 1000),
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.fastOutSlowIn,
        transitionBuilder: (widget, animation) => RotationTransition(
          turns: animation,
          child: ScaleTransition(
            scale: animation,
            child: widget,
          ),


        ),
        child:(!isTapped)?
         GestureDetector(
           onTap: (){
             setState(() {
               isTapped = true;
             });
           },
          child: MatchCard()
         )

         : MatchedMovie(widget.title, widget.dur, widget.year, widget.genre, widget.synopsis,
              widget.image, widget.platform)
    );

  }

}


class MatchCard extends StatelessWidget{

  /*final bool isTapped;

  MatchCard(this.isTapped);*/


  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      key: UniqueKey(),
        child: Container(

            decoration: BoxDecoration(
              color: Colors.red[50],
                borderRadius: BorderRadius.all(Radius.circular(50))),
            height: height / 3,
            width: width - 10,
            child:Card(
              color: Colors.red[50],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset(
                        "assets/images/match.png",
                      )

                  )),
            )
        ));
  }
}




class MatchedMovie extends StatelessWidget{

  final title, dur, year, genre, synopsis, platform;
  final image;
  MatchedMovie(
      this.title, this.dur, this.year, this.genre, this.synopsis, this.image, this.platform);

  @override
  Widget build(BuildContext context) {
    return MovieCard(title, dur, year, genre, synopsis, image, platform);

  }

}
