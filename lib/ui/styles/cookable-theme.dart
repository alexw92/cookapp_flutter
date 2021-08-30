import 'package:flutter/material.dart';

class CookableTheme {
  ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        accentColor: Colors.blueGrey,
        buttonColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,

        // Define the default font family.
        fontFamily: 'Helvetica-Neue-LT-Std-Light.ttf',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        primarySwatch: Colors.lightGreen,
        //  accentColor: Colors.orange,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.orange),
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          headline3: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
          button: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          headline1: TextStyle(fontFamily: 'Quicksand'),
          headline2: TextStyle(fontFamily: 'Quicksand'),
          headline4: TextStyle(fontFamily: 'Quicksand'),
          headline5: TextStyle(fontFamily: 'NotoSans'),
          headline6: TextStyle(fontFamily: 'NotoSans'),
          subtitle1: TextStyle(fontFamily: 'NotoSans'),
          bodyText1: TextStyle(fontFamily: 'NotoSans'),
          bodyText2: TextStyle(fontFamily: 'NotoSans'),
          subtitle2: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      );

  //Better and easy to define colors and text styles something like below
  //and use it everywhere in the project --  makes it more meaningful
  //and easy to remember --Janki

  // static const darkBlue = Color(0xFF000033);
  // static const cornflowerBlue = Color(0xFF4881ea);
  static const darkGrey = Color(0xFF36454F);

  static const largeBoldFont = TextStyle(
      fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white);
  static const noramlWhiteFont = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white);
  static const noramlBlackFont = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black);
  static const smallWhiteFont = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white);
}
