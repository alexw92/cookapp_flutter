import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenStore {
  final storage = new FlutterSecureStorage();
  TokenStore._privateConstructor();

  static final TokenStore _instance = TokenStore._privateConstructor();

  factory TokenStore() {
    return _instance;
  }

  putToken(String userId, String token){
    return storage.write(key: userId, value: token);
  }

  getToken() async{
    var user = FirebaseAuth.instance.currentUser;
    var storedToken = await storage.read(key: user.uid);

    if(storedToken==null || JwtDecoder.isExpired(storedToken) || JwtDecoder.getRemainingTime(storedToken).inSeconds < 10){
      String token = await user.getIdToken(true);
      putToken(user.uid, token);
      return token;
    }
    else {
      return storedToken;
    }
  }

  deleteToken(String userId){
    return storage.delete(key: userId);
  }


  _isExpiredToken(String token){

  }

}