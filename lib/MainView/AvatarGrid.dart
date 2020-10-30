

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Misc_widgets/circleImage.dart';
import 'package:watchmovie/Data_Structures/globals.dart';

class AvatarGrid extends StatelessWidget{

  final username;
  final Function refresh, chngAvatar;

  AvatarGrid(this.username, this.refresh, this.chngAvatar);

  final List avatars = ['av1','av2','av3','av4','av5','av6','av7','av8'
    ,'av9','av10','av11','av12','av13','av14','av15','av16','av17'
  ];


  @override
  Widget build(BuildContext context) {
    //print(avatarId);

   return FractionallySizedBox(
     widthFactor: 0.9,
     heightFactor: 0.5,
     child: Card(
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(10.0),
       ),
       child:GridView.builder(
           itemCount: avatars.length,
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 4),
           itemBuilder: (context, index) {
             return GestureDetector(

               onTap: () async{
                 await changeAvatar(avatars[index]);
                 Navigator.of(context).pop();
                 refresh(avatars[index]);
                 chngAvatar(avatars[index]);
                // avatarId = avatars[index];
                avatarId = avatars[index];
               },

              child: Padding(
                 padding: EdgeInsets.all(5),

                child: Container(
                 //decoration:BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
                     child: Hero(
                       tag: avatars[index],
                     child:circleImageAsset(
                       40,
                         "assets/images/avatars/${avatars[index]}.png"
                     ),)
                 ),

             ));
           })
     ),
   );
  }

  changeAvatar( newAvatar) async{


    await FirebaseFirestore.instance
    .collection('Users')
    .where('username', isEqualTo: username)
    .get()
    .then((querySnapshot){
      querySnapshot.docs.forEach((element) {
        element.reference
            .update({"avatar": newAvatar});
      });
    }).
    catchError((error) => print(error));

  }

}