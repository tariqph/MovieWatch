import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';
import 'package:watchmovie/FriendViews/friendCard.dart';

// ignore: camel_case_types
class sendRequest extends StatefulWidget {


  @override
  sendRequestState createState() {
    return sendRequestState();
  }
}

// ignore: camel_case_types
class sendRequestState extends State<sendRequest> {
  TextEditingController search = TextEditingController();
  bool isSearching = false;

  sendRequestState() {
    search.addListener(() {
      if (search.text.length > 3) {
        setState(() {
          isSearching = true;
        });
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = ModalRoute.of(context).settings.arguments;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: EdgeInsets.all(10),
            child: customFormField("Search for Friends", search, searchValidator)
        ),
        isSearching
            ? FutureBuilder(
                //Future builder to builder after the async retrieval of documents
                future: getData(search.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    //conditional for when documents are retrieved
                    //Map<String, dynamic> data = snapshot.data.data();
                    var rec = snapshot.data;
                   // print(rec);
                    //print("kil");
                    int len = rec.length;

                    return ListView.builder(
                         shrinkWrap: true,
                          itemCount: len,
                          itemBuilder: (BuildContext context, int index) {
                            return customTile(rec[index],userData,search);
                          }
                    );
                  } else {
                    return Center(

                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.blue)));
                  }
                })
            : Text("") ,

        /* (() {
      if (isSearching) {
        Text("in");
      }
      else {
        Text('out');
      }
    }())*/
      ],
    );
  }

  Future getData(String username) async {
/*
    Function to get the pending friend requests which retrieves
    documents from FriendPair collection
 */
    var wht = await FirebaseFirestore.instance
        .collection("Users")
        .where("searchArray", arrayContains: username)
        //.where("username", notEqualto: "pending")
        .limit(10)
        .get();
    //print(wht.documents[0].data);
    return wht.docs;
  }

  void send(String friend1, String friend1name,String friend2, String friend2name) async {

    /* Function to sen friend requests which creates a doc
    in FriendPair collection
     */
    await FirebaseFirestore.instance
        .collection("FriendPairs")
        .add(
        {
          'friend1': friend1,
          'friend1name' : friend1name,
          'friend2': friend2,
          'friend2name' : friend2name,
          'status' : 'pending'
        }
    )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  String searchValidator(String value) {
    if (!(value == value.toLowerCase())) {
      return 'Please use lowercase';
    } else {
      return null;
    }
  }
}

// ignore: camel_case_types
class customFormField extends StatelessWidget {
  final txt;
  // final bool pwd;
  final TextEditingController ctrl;
   final String Function(String) validate;
  customFormField(this.txt, this.ctrl,this.validate);

  @override
  Widget build(BuildContext context) {
    return /*Container(
      height: 50,
      child:*/ TextFormField(
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

// ignore: camel_case_types, must_be_immutable
class customTile extends StatelessWidget {
  /* Custom tile object for all pending friend request with
   nested buttons for accepting and declining requests  */
  // This tile is called by a dynamic Listview
  final name;
  final userData;
  TextEditingController search;
  customTile(this.name,this.userData,this.search);

  @override
  Widget build(BuildContext context) {
    if(userData.username == name.get('username')){
      return Container();
    }
    else {
      return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),

            ListTile(

                leading: CircleAvatar(
                  //radius: 25,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    name.get('username'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(name.get('fullname'),
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.blueGrey))
                ]),
                onTap: () {
                  popUp(context, name.get('username'),name.get('fullname'),userData.username,userData.fullname);
                 // search.clear();

                }

               /* trailing: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text("Send Request"),
                    color: Colors.green[600],
                    textColor: Colors.white,
                    onPressed: () async {
                       await send(userData.username,userData.fullname,name.get('username'),name.get('fullname'));
                    })*/
            ),

          ]);
    }


  }
  Future<void> popUp(context, friendUsername,friendFullname,username, fullname)  async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return friendCard(username, friendUsername, friendFullname,fullname);
        });
  }

}
