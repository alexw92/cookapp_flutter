import 'package:cookable_flutter/core/io/token-store.dart';

class IOConfig{

  static final timeoutDuration = Duration(seconds: 15);
  static final tokenStore = TokenStore();
  static final apiUrlDev = "http://192.168.2.102:8080";
  static final apiUrlLive = "https://alexanderwerthmann.de:8443";
  static final apiUrl = apiUrlLive;
}