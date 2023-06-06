import "package:flutter/material.dart";

class FontFamily {
  static const nunito = 'Nunito';
}

class AppStyle {
  static const TextStyle h1 = TextStyle(
      fontFamily: FontFamily.nunito, fontSize: 108, color: Colors.white);
  static const TextStyle h2 = TextStyle(
      fontFamily: FontFamily.nunito, fontSize: 68, color: Colors.white);
  static const TextStyle h3 = TextStyle(
      fontFamily: FontFamily.nunito, fontSize: 42, color: Colors.white);
  static const TextStyle h4 = TextStyle(
      fontFamily: FontFamily.nunito, fontSize: 26, color: Colors.white);
  static const TextStyle h5 = TextStyle(
      fontFamily: FontFamily.nunito, fontSize: 16, color: Colors.white);
  static const TextStyle h6 = TextStyle(
      fontFamily: FontFamily.nunito, fontSize: 10, color: Colors.white);

  static const Color primaryColor = Color(0xffABC4FF);
  static const Color blackGrey = Color(0xff777777);
  static const Color secondColor = Color.fromARGB(255, 225, 251, 255);
  static const Color textColor = Color(0xff211500);
  static const Color lightBlue = Color(0xffD7E3FC);
  static const Color textGrey = Color(0xff898788);
  static const Color lightGrey = Color(0xffB2B6BD);
}
