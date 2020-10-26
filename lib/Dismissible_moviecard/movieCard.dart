import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Misc_widgets/circleImage.dart';

class MovieCard extends StatelessWidget {
  final title, dur, year, genre, synopsis, platform;
  final image;
  MovieCard(
      this.title, this.dur, this.year, this.genre, this.synopsis, this.image, this.platform);
  @override
  Widget build(BuildContext context) {

    var height = (MediaQuery.of(context).size.height);

    return Container(
      //height: 600,
      decoration: BoxDecoration(
          color: Colors.indigo[50],
          /*border: Border.all(
            color: Colors.red[500],
          ),*/
          borderRadius: BorderRadius.all(Radius.circular(10))),
      //color: Colors.indigo[100],
      //padding: EdgeInsets.all(6),
      margin: EdgeInsets.all(6.0),
      // child: Expanded(
      child:
      Card(
        //color: Colors.indigo[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2,
        //child: Expanded(
        child:
        Column(
           mainAxisSize: MainAxisSize.max, //added
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height/27,
             /* height: 30,
              width: 30,*/
            ),
            // Expanded(
            //here
            // child:
            Container(
                padding: EdgeInsets.all(8),
                child: Text('$title',
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.8)),
            SizedBox(
              height: height/445,
              //height: 2,
              width: 30,
            ),
    /*        Container(
              //uncommented

              height: 230,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(image),
                ),
              ),
            ),*/
            //  SizedBox.expand(,
            Container(
              height: height/3.87,
              //height: 230,

               child:FittedBox(
               fit: BoxFit.fill,
                child:
                FadeInImage.assetNetwork(
                 // fadeInDuration: Duration(milliseconds: 700),
                  placeholder: "assets/images/placeholder.png",
                  image: image,
                ),
                /*Image.network(
                  image,
                ),*/
      ),),

            // ),
            SizedBox(
              height: height/27,
              //height: 30,
              width: 30,
            ),
            //Expanded(
            //here
            // child:
            Container(
                // color: Colors.blue,

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Flexible(
                      child: Image(
                    image: AssetImage("assets/images/year.png"),
                   height: height/44.57,
                   // height: 20,
                    width: 20,
                  )),
                  Flexible(
                      flex: 1,
                      child: Text('$year',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                          textScaleFactor: 1.1)),
                  SizedBox(
                    width: 0.5,
                    height: height/27,
                    //height: 30,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.grey),
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
                   height: height/27,
                   // height: 30,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.grey),
                    ),
                  ),
                  Flexible(
                      child: Image(
                    image: AssetImage("assets/images/duration.png"),
                    height: height/44.57,
                        //height: 20,
                    width: 20,
                  )),
                  Flexible(
                      flex: 1,
                      child: Text('$dur',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                          textScaleFactor: 1.1))
                ])),
            SizedBox(
              height: height/27,
              //height: 30,
              width: 30,
            ),
            //Expanded(
            //here
            //child:
            Row(children: [
              Spacer(),
              circleImageAsset(70, "assets/images/$platform.png"),
              Spacer()
            ]),
            //Expanded(
            //here
            // child:
            Container(
              //color: Colors.blue,
              padding: EdgeInsets.all(20),
              child: Text('$synopsis', textScaleFactor: 1.2,
               // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
