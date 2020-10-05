import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'movieCard.dart';
import 'dataStruct.dart';
import 'scaffold.dart';




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
class dismissibleCardState extends State<dismissibleCard> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    //final title = 'Dismissing Items';

    return Directionality(
      textDirection: TextDirection.ltr,

      //child:Expanded(

      child: Dismissible(
          background: Container(
              alignment: Alignment(-0.9, -0.5),
              child: Icon(
                Icons.favorite,
                color: Colors.green,
                size: 100,
              )),
          secondaryBackground: Container(
              alignment: Alignment(0.9, -0.5),
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 100,
              )),
          key: UniqueKey(),
          child:
          /*Column(children: [
            SizedBox(
              height: 100,
            ),*/
          MovieCard(
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
