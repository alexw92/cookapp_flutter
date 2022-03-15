import 'package:cookable_flutter/common/LangState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import '../../../main.dart';

class LanguagesScreen extends StatefulWidget {
  final String language;

  LanguagesScreen({this.language});

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState(this.language);
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  List<String> languages = ['English', 'Deutsch', 'Español'];
  List<String> langCodes = ['en', 'de', 'es'];
  int languageIndex = 0;

  _LanguagesScreenState(String language) {
    languageIndex = languages.indexOf(language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).languages, style: TextStyle(color: Colors.white),)),
      body: SettingsList(sections: [
        SettingsSection(
            tiles: languages
                .map((lang) => SettingsTile(
                    title: lang,
                    trailing: trailingWidget(languages.indexOf(lang)),
                    onPressed: (BuildContext context) {
                      changeLanguage(languages.indexOf(lang));
                    }))
                .toList())
      ]),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.teal)
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
    LangState().currentLang = langCodes[index];
    CookableFlutter.setLocale(context, Locale(langCodes[index], ""));
    Navigator.pop(context, languages[index]);
  }
}
