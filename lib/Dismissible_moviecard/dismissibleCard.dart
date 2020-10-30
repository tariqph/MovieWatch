import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'movieCard.dart';
import '../Data_Structures/dataStruct.dart';

// MyApp is a StatefulWidget. This allows updating the state of the
// widget when an item is removed.
// ignore: camel_case_types
class dismissibleCard extends StatefulWidget {
  final List<MovieData> movies;
  final String gameActive;
  final username;
  final creator;


  //MyApp({Key key}) : super(key: key);
  dismissibleCard(this.movies, this.gameActive, this.username, this.creator);

  @override
  dismissibleCardState createState() {
    return dismissibleCardState();
  }
}

// ignore: camel_case_types
class dismissibleCardState extends State<dismissibleCard> with TickerProviderStateMixin{
  int index = 0;
  var selectionArray = [];


  //here to
  AnimationController _controller;
  Animation<double> _animation;




  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.6,
      vsync: this,
    )..animateTo(1);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );
    super.initState();


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }
//here
  @override
  Widget build(BuildContext context) {
    //final title = 'Dismissing Items';
    _controller.forward();
  // print(index);

    return
      Directionality(
      textDirection: TextDirection.ltr,

      //child:Expanded(

      child:  Dismissible(
          background: Container(
              alignment: Alignment(-0.9, -0.5),
              child: Icon(
                Icons.favorite,
                color: Colors.purple,
                size: 50,
              )),
          secondaryBackground: Container(
              alignment: Alignment(0.9, -0.5),
              child: Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 50,
              )),
          key: UniqueKey(),
          child:
          /*Column(children: [
            SizedBox(
              height: 100,
            ),*/
    ScaleTransition(
    scale: _animation,
    child:MovieCard(
              widget.movies[index].title,
              widget.movies[index].dur,
              widget.movies[index].year,
              widget.movies[index].genre,
              widget.movies[index].synopsis,
              widget.movies[index].image,
              widget.movies[index].platform)),


          onDismissed: (direction) {

       if(widget.gameActive == 'yes'){
         if(direction == DismissDirection.endToStart ){
           //print('disliked');
           selectionArray.add(0);
         }
         if(direction == DismissDirection.startToEnd){
           //print('Liked');
           selectionArray.add(1);
         }
         updateMovieSelection(widget.creator, widget.username, selectionArray);
          }


      /* SystemSound.play(SystemSoundType.click);*/

            setState(() {
          _controller.reset();
              index++;
            });
          }),
     // ),
    );
  }
 Future updateMovieSelection(creator,  username, selectionArray) async{
    await FirebaseFirestore.instance
        .collection('Parties')
        .doc(creator)
        .update({username: selectionArray })
        .then((value) => print('updated succesfully'))
        .catchError((onError)=> print('update unsuccessful'));
 }

}
