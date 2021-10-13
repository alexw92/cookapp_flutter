import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagesScreen extends StatefulWidget {
  final String language;
  LanguagesScreen({this.language});

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState(this.language);
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  List<String> languages = ['English', 'German'];
  int languageIndex = 0;

  _LanguagesScreenState(String language){
    languageIndex = languages.indexOf(language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Languages')),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: "English",
              trailing: trailingWidget(0),
              onPressed: (BuildContext context) {
                changeLanguage(0);
              },
            ),
            SettingsTile(
              title: "German",
              trailing: trailingWidget(1),
              onPressed: (BuildContext context) {
                changeLanguage(1);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
    Navigator.pop(context, languages[index]);
  }
}