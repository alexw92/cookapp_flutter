import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  isMobilePlatform() {
    return (defaultTargetPlatform == TargetPlatform.iOS) ||
        (defaultTargetPlatform == TargetPlatform.android);
  }

  // Secure storage for IOS and Android

  final storage = new FlutterSecureStorage();

  TokenStore._privateConstructor();

  static final TokenStore _instance = TokenStore._privateConstructor();

  factory TokenStore() {
    return _instance;
  }

  putToken(String userId, String token) async {
    if (isMobilePlatform()) {
      return storage.write(key: userId, value: token);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(userId, token);
    }
  }

  getToken() async {
    if (isMobilePlatform()) {
      return _getTokenMobile();
    } else {
      return _getTokenWeb();
    }
  }

  _getTokenMobile() async {
    var user = FirebaseAuth.instance.currentUser;
    print(user);

    var storedToken = await storage.read(key: user.uid);

    if (storedToken == null ||
        JwtDecoder.isExpired(storedToken) ||
        JwtDecoder.getRemainingTime(storedToken).inSeconds < 10) {
      String token = await user.getIdToken(true);
      putToken(user.uid, token);
      return token;
    } else {
      return storedToken;
    }
  }

  _getTokenWeb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = FirebaseAuth.instance.currentUser;
    print(user);

    String storedToken = (prefs.getString(user.uid));

    if (storedToken == null ||
        JwtDecoder.isExpired(storedToken) ||
        JwtDecoder.getRemainingTime(storedToken).inSeconds < 10) {
      String token = await user.getIdToken(true);
      putToken(user.uid, token);
      return token;
    } else {
      return storedToken;
    }
  }

  deleteToken(String userId) async {
    if (isMobilePlatform())
      return storage.delete(key: userId);
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(userId);
    }
  }
}
