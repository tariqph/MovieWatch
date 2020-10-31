import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchmovie/Data_Structures/globals.dart';
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
    //avatarId = userData.avatar;

    return CustomScaffold(userData);

  }
}

