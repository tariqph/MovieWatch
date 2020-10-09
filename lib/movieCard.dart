import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/circleImage.dart';





class MovieCard extends StatelessWidget {
  final title, dur, year, genre, synopsis;
  final image;
  MovieCard(
      this.title, this.dur, this.year, this.genre, this.synopsis, this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 700,
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        /*border: Border.all(
            color: Colors.red[500],
          ),*/
          borderRadius: BorderRadius.all(Radius.circular(10))),
      //color: Colors.indigo[100],
      //padding: EdgeInsets.all(6),
      margin: EdgeInsets.all(6.0),
      child: Card(
        //color: Colors.indigo[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.all(8),
                child: Text('$title',
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.8)),
            SizedBox(height: 2),
            FittedBox(
                fit: BoxFit.fill,
                child: Image.network(
                  image,
                )),
            SizedBox(height: 30),
            Container(
              // color: Colors.blue,

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage("assets/images/year.png"),
                        height: 20,
                        width: 20,
                      ),
                      Flexible(
                          flex: 1,
                          child: Text('$year',
                              style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                              textScaleFactor: 1.1)),
                      SizedBox(
                        width: 0.5,
                        height: 30,
                        child: const DecoratedBox(
                          decoration: const BoxDecoration(
                              color: Colors.grey
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: Text('$genre',
                              style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                              textScaleFactor: 1.1)),
                      SizedBox(
                        width: 0.5,
                        height: 30,
                        child: const DecoratedBox(
                          decoration: const BoxDecoration(
                              color: Colors.grey
                          ),
                        ),
                      ),
                      Image(
                        image: AssetImage("assets/images/duration.png"),
                        height: 20,
                        width: 20,
                      ),
                      Flexible(
                          flex: 1,
                          child: Text('$dur',
                              style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                              textScaleFactor: 1.1))
                    ])),
            SizedBox(height: 30),
            Row(
                children:[Spacer()
                  ,circleImageAsset(70,"assets/images/netflix.png"),Spacer()]),


            Container(
              //color: Colors.blue,
              padding: EdgeInsets.all(20),
              child: Text('$synopsis', textScaleFactor: 1.2),
            )
          ],
        ),
      ),
    );
  }
}
