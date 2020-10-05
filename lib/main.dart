import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'movieCard.dart';
import 'dataStruct.dart';
import 'scaffold.dart';

void main() {
  List<MovieData> movies = List<MovieData>(10);
  movies[0] = MovieData('2 Fast 2 Furious', '1h 47m', '2003', 'Crime',("It's a major double-cross when former cop Brian teams up with his ex-con buddy to transport a shipment of \"dirty\" money for a shady importer-exporter."),
      'https://occ-0-2599-2186.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaDXU4ra0HJLgkDbKmVwFpzMGxLJp_zNuEN7hjEmLHP_HmoGqSfojwtkYYPbbPn4mJyFmTNS4vRdmOe2eWOrAi9W73o.webp?r=8e9');
  movies[1] = MovieData('title1', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/7436/747436-h');
  movies[2] = MovieData('title', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/8185/768185-h');
  movies[3] = MovieData('title1', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/7436/747436-h');
  movies[4] = MovieData('title', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/8185/768185-h');
  movies[5] = MovieData('title1', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/7436/747436-h');
  movies[6] = MovieData('title', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/8185/768185-h');
  movies[7] = MovieData('title1', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/7436/747436-h');
  movies[8] = MovieData('title', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/8185/768185-h');
  movies[9] = MovieData('title1', 'dur', 'year', 'genre', 'synopsis',
      'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_1_5x/sources/r1/cms/prod/7436/747436-h');

  runApp(MainApp(movies));
}

class MainApp extends StatelessWidget {
  final List<MovieData> movies;
  MainApp(this.movies);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomScaffold(movies),
    );
  }
}

