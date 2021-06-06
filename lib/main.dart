import 'package:cookable_flutter/core/providers/theme.provider.dart';
import 'package:cookable_flutter/ui/pages/homepage.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initialTheme: _theme,
      materialAppBuilder: (context, theme) {
        return MaterialApp(
          title: 'Cookable',
          theme: theme,
          supportedLocales: [const Locale('de'), const Locale('en')],
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => HomePage(),
          },
        );
      },
    );
  }
}
