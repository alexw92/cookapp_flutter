import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppTheme {
  ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal))),
        // Define the default font family.
        fontFamily: GoogleFonts.roboto().fontFamily,
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            floatingLabelStyle: TextStyle(color: Colors.teal)),
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
          button: GoogleFonts.roboto(),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          headline1: GoogleFonts.roboto(),
          headline2: GoogleFonts.roboto(),
          headline4: GoogleFonts.roboto(),
          headline5: GoogleFonts.roboto(),
          headline6: GoogleFonts.roboto(),
          subtitle1: GoogleFonts.roboto(),
          bodyText1: GoogleFonts.roboto(),
          bodyText2: GoogleFonts.roboto(),
          subtitle2: GoogleFonts.roboto(),
          overline: GoogleFonts.roboto(),
        ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen).copyWith(secondary: Colors.blueGrey),
      );

  //Better and easy to define colors and text styles something like below
  //and use it everywhere in the project --  makes it more meaningful
  //and easy to remember --Janki

  // static const darkBlue = Color(0xFF000033);
  // static const cornflowerBlue = Color(0xFF4881ea);
  static const darkGrey = Color(0xFF36454F);

  static const largeBoldFont = TextStyle(
      fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white);
  static const normalWhiteFont = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white);
  static const normalBlackFont = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black);
  static const smallWhiteFont = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white);
}
