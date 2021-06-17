import 'package:cookable_flutter/core/io/token-store.dart';

class IOConfig{

  static final timeoutDuration = Duration(seconds: 3);
  static final tokenStore = TokenStore();
  static final apiUrl = "http://192.168.2.102:8080";
}