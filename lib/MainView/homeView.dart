

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data_Structures/dataStruct.dart';
import 'CustomScaffold.dart';
import 'dart:core';


// ignore: camel_case_types
class homeView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return homeViewState();
  }
}


// ignore: camel_case_types
class homeViewState extends State<homeView> { //should use this widget for future builder for getting movie data

  //final username;
  //homeView(this.username);
  List<MovieData> movies = [];

  @override
  Widget build(BuildContext context) {
    final UserData userData  = ModalRoute.of(context).settings.arguments;
    //final username = args.email;
   // print(username);
    /*final List<MovieData> movies = List<MovieData>(6);
    movies[0]= MovieData('2 Fast 2 Furious', '1h 47m', '2003', 'Crime',("It's a major double-cross when former cop Brian teams up with his ex-con buddy to transport a shipment of \"dirty\" money for a shady importer-exporter."),
        'https://occ-0-2599-2186.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaDXU4ra0HJLgkDbKmVwFpzMGxLJp_zNuEN7hjEmLHP_HmoGqSfojwtkYYPbbPn4mJyFmTNS4vRdmOe2eWOrAi9W73o.webp?r=8e9', 'ioioj', 'hotstar');
    movies[1]= MovieData('2 Fast 2 Furious', '1h 47m', '2003', 'Crime',("It's a major double-cross when former cop Brian teams up with his ex-con buddy to transport a shipment of \"dirty\" money for a shady importer-exporter."),
        'https://occ-0-2599-2186.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaDXU4ra0HJLgkDbKmVwFpzMGxLJp_zNuEN7hjEmLHP_HmoGqSfojwtkYYPbbPn4mJyFmTNS4vRdmOe2eWOrAi9W73o.webp?r=8e9', 'ioioj', 'hotstar');
    movies[2]= MovieData('2 Fast 2 Furious', '1h 47m', '2003', 'Crime',("It's a major double-cross when former cop Brian teams up with his ex-con buddy to transport a shipment of \"dirty\" money for a shady importer-exporter."),
        'https://occ-0-2599-2186.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaDXU4ra0HJLgkDbKmVwFpzMGxLJp_zNuEN7hjEmLHP_HmoGqSfojwtkYYPbbPn4mJyFmTNS4vRdmOe2eWOrAi9W73o.webp?r=8e9', 'ioioj', 'hotstar');
    movies[3]= MovieData('2 Fast 2 Furious', '1h 47m', '2003', 'Crime',("It's a major double-cross when former cop Brian teams up with his ex-con buddy to transport a shipment of \"dirty\" money for a shady importer-exporter."),
        'https://occ-0-2599-2186.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaDXU4ra0HJLgkDbKmVwFpzMGxLJp_zNuEN7hjEmLHP_HmoGqSfojwtkYYPbbPn4mJyFmTNS4vRdmOe2eWOrAi9W73o.webp?r=8e9', 'ioioj', 'hotstar');
    movies[4]= MovieData('2 Fast 2 Furious', '1h 47m', '2003', 'Crime',("It's a major double-cross when former cop Brian teams up with his ex-con buddy to transport a shipment of \"dirty\" money for a shady importer-exporter."),
        'https://occ-0-2599-2186.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaDXU4ra0HJLgkDbKmVwFpzMGxLJp_zNuEN7hjEmLHP_HmoGqSfojwtkYYPbbPn4mJyFmTNS4vRdmOe2eWOrAi9W73o.webp?r=8e9', 'ioioj', 'hotstar');
    movies[5]= MovieData('2 Fast 2 Furious', '1h 47m', '2003', 'Crime',("It's a major double-cross when former cop Brian teams up with his ex-con buddy to transport a shipment of \"dirty\" money for a shady importer-exporter."),
        'https://occ-0-2599-2186.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaDXU4ra0HJLgkDbKmVwFpzMGxLJp_zNuEN7hjEmLHP_HmoGqSfojwtkYYPbbPn4mJyFmTNS4vRdmOe2eWOrAi9W73o.webp?r=8e9', 'ioioj', 'hotstar');
*/
    return /*MaterialApp(
      title: 'New',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:*/
      FutureBuilder(
        future:getMovieData(),
      builder:(context, snapshot) {

          if(snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data.length);
            var mData = snapshot.data;

            for(int i =0;i<snapshot.data.length;i++){
              movies.add(MovieData(mData[i].get('title'),
                  mData[i].get('duration'),
                  mData[i].get('year'),
                  mData[i].get('genre'),
                  mData[i].get('synopsis'),
                  mData[i].get('image'),
                  mData[i].get('id'),
                  mData[i].get('platform')));
            }
            movies.shuffle();


            return CustomScaffold(movies, userData);
          }
          else {
            return Container(
                height: ((MediaQuery.of(context).size.height)*0.6),
                child:
                Column(
                    children:[Spacer(),
                      Center(
                          child: Container(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.blue)))),
                      Spacer()]));
          }


      }
      );

  }

  Future getMovieData()async{
    var arr = [];
    await FirebaseFirestore.instance
        .collection('MovieRef')
        .doc('test')
        .get()
        .then((docs)async{
       int length = docs.get('docRefs').length;
       for(int i=0;i<length/5;i++){
         await FirebaseFirestore.instance
             .collection('Test')
             .doc(docs.get('docRefs')[i])
             .get()
             .then((docSnap){
               arr.add(docSnap);
         }).catchError((onError){
           print(onError);
         });
       }
    }).catchError((err){
      print('error');
    });

    return arr;
  }


}

