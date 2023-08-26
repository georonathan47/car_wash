import 'package:flutter/material.dart';

class Const{
  static var logo = 'assets/logo.png';
  static Color primaryColor1 = const Color(0XFF27046B);
  static Color primaryColor2 = const Color(0XFFfa9416);
  static wi(context){
    return MediaQuery.of(context).size.width;
  }
  static hi(context){
    return MediaQuery.of(context).size.height;
  }
  static appbar(String title){
    return AppBar(
      backgroundColor: Const.primaryColor1,
      title: Text(title),
    );
  }

}