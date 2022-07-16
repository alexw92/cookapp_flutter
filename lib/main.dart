import 'dart:math';

import 'package:cookable_flutter/core/providers/theme.provider.dart';
import 'package:cookable_flutter/ui/pages/homepage.dart';
import 'package:cookable_flutter/ui/pages/login_screen.dart';
import 'package:cookable_flutter/ui/styles/app-theme.dart';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'common/LangState.dart';
import 'core/data/models.dart';
import 'core/io/controllers.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
  Hive.registerAdapter(PrivateRecipeAdapter());
  Hive.registerAdapter(ReducedUserAdapter());
  Hive.registerAdapter(DefaultNutrientsAdapter());
  Hive.registerAdapter(FoodProductAdapter());
  Hive.registerAdapter(TotalRecipeLikesAdapter());
  Hive.registerAdapter(UserRecipeLikeAdapter());
  await Firebase.initializeApp();

  try {
    // submit deviceRegistrationToken on start
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String token = await _firebaseMessaging.getToken();

    UserController.submitFirebaseDeviceRegistrationToken(token)
        .then((value) => null);
  }
  catch(e){
    print(e);
  }

  // set cron
  final cron = Cron();
  final random = new Random();
  var m = random.nextInt(59);
  var h = random.nextInt(20);
  print('Submitting device registration cron scheduled for $m $h * * *');
  cron.schedule(Schedule.parse('$m $h * * *'), () async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String token = await _firebaseMessaging.getToken();

    UserController.submitFirebaseDeviceRegistrationToken(token)
        .then((value) => null);
  });
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    //await FirebaseMessaging.instance.
    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(CookableFlutter());
}

class CookableFlutter extends StatefulWidget {
  CookableFlutter();

  /*
  To Change Locale of App
   */
  static void setLocale(BuildContext context, Locale newLocale) async {
    _CookableFlutterState state =
        context.findAncestorStateOfType<_CookableFlutterState>();

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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String fcmToken = "Getting Firebase Token";

  getTokenFCM() async {
    String token = await _firebaseMessaging.getToken();
    setState(() {
      fcmToken = token;
      print(fcmToken);
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('message: ' + message.messageId + ' ' + message.messageType);
      }
    });

    // I think this is for Foreground messages received when app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message);
      if (message != null) {
        print(message.messageId);
        print(message.messageType);
        if (message.data["body"] != null)
          print(String.fromCharCodes(Runes(message.data["body"])));
        print('message (onMessage.listen): ' + message.messageId);
      }
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          String.fromCharCodes(Runes(notification.title)),
          notification.body != null
              ? String.fromCharCodes(Runes(notification.body))
              : "",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher' // Todo replace with appropriate icon
            ),
          ),
        );
      }
    });

    getTokenFCM();

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
