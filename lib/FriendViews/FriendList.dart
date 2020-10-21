import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/dataStruct.dart';

import 'friendCard.dart';

class FriendList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FriendListState();
  }

}

class FriendListState extends State<FriendList> with AutomaticKeepAliveClientMixin<FriendList>{

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
   super.build(context);
    final UserData userData = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(
      //Future builder to builder after the async retrieval of documents
        future: getData(userData.username),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //conditional for when documents are retrieved
            //Map<String, dynamic> data = snapshot.data.data();
            var rec = snapshot.data;
            print(rec);
            //print("hh");
            int len1 = rec[0].length;
            int len2 = rec[1].length;
            print(len1);
            print(len2);
            //print("jj");

            return
              Container (
              child:Column(mainAxisSize: MainAxisSize.min,

                children:[
                    ListView.builder(
                        shrinkWrap: true,
                  itemCount: len1,
                  itemBuilder: (BuildContext context, int index) {
                    return customTile(rec[0][index].get('friend2'),rec[0][index].get('friend2name'), userData);
                  }),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: len2,
                      itemBuilder: (BuildContext context, int index) {
                        return customTile(rec[1][index].get('friend1'),rec[1][index].get('friend1name'), userData);
                      }),
              ]
            ));
          } else {
            return  Center(
                  child: CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.blue)));
          }
        });

  }

  Future getData(String username) async {
/*
    Function to get whether the searched user selected is a friend or not
 */
    var wht1 = await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend1", isEqualTo: username)
        .where("status", isEqualTo: 'active')
        .get();
    var wht2 = await FirebaseFirestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: username)
        .where("status", isEqualTo: 'active')
        .get();
    //print(wht.documents[0].data);
    return [wht1.docs, wht2.docs];
    //return wht1.docs;
  }
}

// ignore: camel_case_types, must_be_immutable
class customTile extends StatelessWidget {
  /* Custom tile object for all pending friend request with
   nested buttons for accepting and declining requests  */
  // This tile is called by a dynamic Listview
  final friendUsername;
  final friendFullname;
  final userData;


  customTile(this.friendUsername,this.friendFullname, this.userData);

  @override
  Widget build(BuildContext context) {
   /* if(userData.username == name.get('username')){
      return Container();
    }
    else {*/
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
                    friendUsername,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(friendFullname,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.blueGrey))
                ]),
                onTap: () {
                  popUp(context, friendUsername,friendFullname,userData.username,userData.fullname);


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
  Future<void> popUp(context, friendUsername,friendFullname,username, fullname)  async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return friendCard(username, friendUsername, friendFullname,fullname);
        });
  }

}
