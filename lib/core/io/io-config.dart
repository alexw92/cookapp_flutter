import 'package:cookable_flutter/core/io/token-store.dart';

class IOConfig{

  static final timeoutDuration = Duration(seconds: 3);
  static final tokenStore = TokenStore();
  static final apiUrlDev = "http://192.168.2.102:8080";
  static final apiUrlLive = "http://cookable.eu-central-1.elasticbeanstalk.com";
  static final apiUrl = apiUrlDev;
}