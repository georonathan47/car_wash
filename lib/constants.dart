import 'package:flutter/material.dart';

class Const{
  static var logo = 'assets/logo.png';
  static Color primaryColor = const Color(0XFF000000);
  static wi(context){
    return MediaQuery.of(context).size.width;
  }
  static hi(context){
    return MediaQuery.of(context).size.height;
  }
  static appbar(String title){
    return AppBar(
      backgroundColor: Const.primaryColor,
      title: Text(title),
    );
  }

}