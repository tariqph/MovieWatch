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

  void dispose(){
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


        return  Text(userData.username);

      },
    ));
  }

  Future deleteParty(String username) async{
    await FirebaseFirestore.instance
        .collection('Parties')
        .doc(username)
        .delete()
        .then((value) {

    }).catchError((err){
      print('Could not delete $err');
    });
  }
}
