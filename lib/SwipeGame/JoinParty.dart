import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';

class JoinParty extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JoinPartyState();
  }
}

class JoinPartyState extends State<JoinParty> {
  TextEditingController search = TextEditingController();
  bool isSearching = false;
  bool showFriends = true;
  UserData userData;
  //var friends;

  JoinPartyState() {
    search.addListener(() {
      if (search.text.length > 3) {
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
        backgroundColor: Colors.white,
        //Base Scaffold is build first with the search bar is build without the future builder
        appBar: AppBar(
          title: Text('Join Party'),
        ),
        floatingActionButton: Container(
          //floating action button to refresh the Parties created by friends
          width: 80,
          height: 80,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            //color: Colors.red
          ),
          child: FloatingActionButton(
              backgroundColor: Colors.teal,
              //splashColor: Colors.yellow[900],
              child: Icon(Icons.refresh),
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
              child: customFormField(
                  "Search for Parties", search, searchValidator)),
          (showFriends) //ternary operator used, if isSearching is true then a party created
              // by a user is searched else it shows parties created by users who are already friends(if present)
              ? FutureBuilder(
                  future: joinParty(userData.username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
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
                      return Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blue)));
                    }
                  })
              : (isSearching)
                  ? Container(
                      child: Text('Searching'),
                    )
                  : Container(
                      child: Text('not Searching'),
                    )
        ]));
  }

  String searchValidator(String value) {
    if (!(value == value.toLowerCase())) {
      return 'Please use lowercase';
    } else {
      return null;
    }
  }

  Future joinParty(String username) async {
/*
    Function to get whether the searched user selected is a friend or not
 */
    List searchArray = [];
    //List len = [];

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
        .get();
  }
}

// ignore: camel_case_types
class customFormField extends StatelessWidget {
  final txt;
  // final bool pwd;
  final TextEditingController ctrl;
  final String Function(String) validate;
  customFormField(this.txt, this.ctrl, this.validate);

  @override
  Widget build(BuildContext context) {
    return /*Container(
      height: 50,
      child:*/
        TextFormField(
      minLines: 1,
      maxLines: 3,
      validator: validate, //put in a validator for only
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
  final docs;
  final userData;

  customTile(this.docs, this.userData);

  @override
  Widget build(BuildContext context) {
    /* if(userData.username == name.get('username')){
      return Container();
    }
    else {*/
    return Column(mainAxisSize: MainAxisSize.min, children: [
      //Divider(),

      ListTile(
          leading: CircleAvatar(
            //radius: 25,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${docs.get('creatorName')}\'s Party',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(docs.get('creator'),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    color: Colors.blueGrey))
          ]),
          onTap: () {
            //popUp(context, friendUsername,friendFullname,userData.username,userData.fullname);
          }
          ),
    ]);
  }
/*  Future<void> popUp(context, friendUsername,friendFullname,username, fullname)  async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return friendCard(username, friendUsername, friendFullname,fullname);
        });
  }*/

}
