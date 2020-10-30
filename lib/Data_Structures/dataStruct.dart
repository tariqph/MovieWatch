
import 'package:flutter/material.dart';

class MovieData {
  var title;
  var dur;
  var year;
  var genre;
  var synopsis;
  var image;
  var id;
  var platform;

  MovieData(
      this.title, this.dur, this.year, this.genre, this.synopsis, this.image, this.id, this.platform);

}

class UserData{
  var fullname, email, username, avatar;

  UserData(this.fullname, this.email, this.username, this.avatar);


}

Color baseColor = Colors.red[50];

//String avatarId;
