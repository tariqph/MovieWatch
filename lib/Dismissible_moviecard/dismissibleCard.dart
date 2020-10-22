import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'movieCard.dart';
import '../Data_Structures/dataStruct.dart';

// MyApp is a StatefulWidget. This allows updating the state of the
// widget when an item is removed.
// ignore: camel_case_types
class dismissibleCard extends StatefulWidget {
  final List<MovieData> movies;

  //MyApp({Key key}) : super(key: key);
  dismissibleCard(this.movies);

  @override
  dismissibleCardState createState() {
    return dismissibleCardState();
  }
}

// ignore: camel_case_types
class dismissibleCardState extends State<dismissibleCard> with TickerProviderStateMixin{
  int index = 0;



  //here to
  /*AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..reset();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }*/
//here
  @override
  Widget build(BuildContext context) {
    //final title = 'Dismissing Items';

    return Directionality(
      textDirection: TextDirection.ltr,

      //child:Expanded(

      child:  Dismissible(
          background: Container(
              alignment: Alignment(-0.9, -0.5),
              child: Icon(
                Icons.favorite,
                color: Colors.green,
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
   /* ScaleTransition(
    scale: _animation,
    child:*/MovieCard(
              widget.movies[index].title,
              widget.movies[index].dur,
              widget.movies[index].year,
              widget.movies[index].genre,
              widget.movies[index].synopsis,
              widget.movies[index].image),
          onDismissed: (direction) {
            // Remove the item from the data source.
            setState(() {
              index++;
            });
          }),
     // ),
    );
  }
}
