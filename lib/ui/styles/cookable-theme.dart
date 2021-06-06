import 'package:flutter/material.dart';

class CookableTheme {
  ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey,
        accentColor: Colors.green,
        buttonColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,

        // Define the default font family.
        fontFamily: 'Helvetica-Neue-LT-Std-Light.ttf',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );

  //Better and easy to define colors and text styles something like below
  //and use it everywhere in the project --  makes it more meaningful
  //and easy to remember --Janki

  // static const darkBlue = Color(0xFF000033);
  // static const cornflowerBlue = Color(0xFF4881ea);
  static const largeBoldFont = TextStyle(
      fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white);
  static const noramlWhiteFont = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white);
  static const noramlBlackFont = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black);
}
