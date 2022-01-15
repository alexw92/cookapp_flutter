import 'package:cookable_flutter/core/providers/theme.provider.dart';
import 'package:cookable_flutter/ui/pages/homepage.dart';
import 'package:cookable_flutter/ui/pages/login_screen.dart';
import 'package:cookable_flutter/ui/styles/app-theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'common/LangState.dart';
import 'core/data/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(RecipeInstructionAdapter());
  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(QuantityUnitAdapter());
  Hive.registerAdapter(DietAdapter());
  Hive.registerAdapter(NutrientsAdapter());
  Hive.registerAdapter(UserFoodProductAdapter());
  Hive.registerAdapter(FoodCategoryAdapter());
  await Firebase.initializeApp();
  runApp(CookableFlutter());
}

class CookableFlutter extends StatefulWidget {
  CookableFlutter();

  /*
  To Change Locale of App
   */
  static void setLocale(BuildContext context, Locale newLocale) async {
    _CookableFlutterState state = context.findAncestorStateOfType<_CookableFlutterState>();

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', newLocale.languageCode);
    prefs.setString('countryCode', "");

    state.setState(() {
      state._locale = newLocale;
    });

  }

  @override
  _CookableFlutterState createState() => _CookableFlutterState();
}

class _CookableFlutterState extends State<CookableFlutter> {
  // This widget is the root of your application.
  final ThemeData _theme = MyAppTheme().theme;
  Locale _locale = Locale('en', '');
  User _user;

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        _user = FirebaseAuth.instance.currentUser;
        this._locale = locale;
      });
    });
  }

  Future<Locale> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    String languageCode = prefs.getString('languageCode') ?? 'en';
    String countryCode = prefs.getString('countryCode') ?? '';
    LangState().currentLang = languageCode;

    return Locale(languageCode, countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initialTheme: _theme,
      materialAppBuilder: (context, theme) {
        return MaterialApp(
          title: 'Foodict',
          locale: _locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('es', ''), // Spanish, no country code
            Locale('de', ''), // German, no country code
          ],
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
