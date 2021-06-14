import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  getToken(String userId){
    return storage.read(key: userId);
  }

  deleteToken(String userId){
    return storage.delete(key: userId);
  }


}