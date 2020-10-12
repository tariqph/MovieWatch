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
  final String username = "tariqph";
  //var snapshot;

  /*@override
  // ignore: must_call_super
 void initState() {
   getData(username).then((result){

 // setState(() {
    snapshot = result.documents;
 // });
  //print(result.documents[0].data);
});

  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //Map<String, dynamic> data = snapshot.data.data();
            var rec = snapshot.data;
            print(rec);
            int len = rec.length;

            return Scaffold(
              appBar: AppBar(
                title: Text("Friend Requests"),
                backgroundColor: Colors.indigo[900],
              ),
              body: ListView.builder
                (
                  itemCount: len,
                  itemBuilder: (BuildContext context, int index) {
                    return customTile(rec[index],declineRequest);
                  }
              ),
            );
          }
          else {
            return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue))
          ),);
          }
        });
  }

  Future<List<DocumentSnapshot>> getData(String username) async {
// QuerySnapshot querySnapshot =
    var wht = await Firestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: username)
    .where("status",isEqualTo: "pending")
        .getDocuments();
    //print(wht.documents[0].data);
    return wht.documents;
    //int l = querySnapshot.documents.length;
/* setState(() {
   snapshot = querySnapshot.documents;
 });*/
//return querySnapshot;

    //print(snapshot);
    //return querySnapshot.documents;
  }

  void declineRequest(String friend1, String friend2) async{

    await Firestore.instance
        .collection("FriendPairs")
        .where("friend2", isEqualTo: friend2)
        .where("friend1", isEqualTo: friend1).getDocuments()
       .then((snapshot) {
     for (DocumentSnapshot ds in snapshot.documents){
       ds.reference.delete();
     setState(() {
     });}
     }).catchError((onError) => print(onError));
  }
}


// ignore: camel_case_types, must_be_immutable
class customTile extends StatelessWidget {

  final name;
  Function decline;
  customTile(this.name, this.decline);

  @override
  Widget build(BuildContext context) {
    return Column(
    children:[ListTile(
        leading: FlutterLogo(),
        title: Text(name.data['friend1name']),
       /*trailing:RaisedButton(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(4.0),
           ),
           child: Text("Accept"),
           color: Colors.green[600],
           textColor: Colors.white,
           onPressed: () {

           }) ,*/
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
                onPressed: () {

                }),SizedBox(width: 4,),
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text("Decline"),
                color: Colors.red[600],
                textColor: Colors.white,
                onPressed: () async{
                  await decline(name.data['friend1'],name.data['friend2']);


                })
          ],
        ),
    ),Divider()]);
  }
}
