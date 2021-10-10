import 'package:cookable_flutter/core/providers/theme.provider.dart';
import 'package:cookable_flutter/ui/pages/homepage.dart';
import 'package:cookable_flutter/ui/pages/login_screen.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CookableFlutter());
}

class CookableFlutter extends StatefulWidget {
  CookableFlutter();

  @override
  _CookableFlutterState createState() => _CookableFlutterState();
}

class _CookableFlutterState extends State<CookableFlutter> {
  // This widget is the root of your application.
  final ThemeData _theme = CookableTheme().theme;
  User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initialTheme: _theme,
      materialAppBuilder: (context, theme) {
        return MaterialApp(
          title: 'Foodict',
          theme: _theme,
          //    supportedLocales: [const Locale('de'), const Locale('en')],
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) =>
                (_user == null) ? LoginScreen() : HomePage(),
          },
        );
      },
    );
  }
}
