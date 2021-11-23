class LangState {
  static final LangState _singleton = LangState._internal();
  String currentLang = "en";

  factory LangState() {
    return _singleton;
  }

  LangState._internal();
}