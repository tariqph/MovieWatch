

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data_Structures/dataStruct.dart';
import 'CustomScaffold.dart';
import 'dart:core';


// ignore: camel_case_types
class homeView extends StatelessWidget { //should use this widget for future builder for getting movie data

  //final username;
  //homeView(this.username);


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
   /* List<MovieData> movies = [];*/
    return CustomScaffold(userData);

  }

}

