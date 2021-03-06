import 'package:cookable_flutter/ui/components/settings/Language_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String language = 'English';

  _SettingsPageState() {
    _fetchLocale();
  }

  Future<String> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    String languageCode = prefs.getString('languageCode') ?? 'en';

    if (languageCode == "en") {
      setState(() {
        language = 'English';
      });
    }
    if (languageCode == "de") {
      setState(() {
        language = 'Deutsch';
      });
    }
    if (languageCode == "es") {
      setState(() {
        language = 'Español';
      });
    }

    return language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).settings,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            titlePadding: EdgeInsets.all(20),
            tiles: [
              SettingsTile(
                title: AppLocalizations.of(context).language,
                subtitle: language,
                leading: Icon(Icons.language),
                onPressed: (context) async {
                  final result = await Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (_) => LanguagesScreen(language: language),
                      ))
                      .then((value) => _fetchLocale());
                  setState(() {
                    this.language = result;
                  });
                },
              ),
              // SettingsTile.switchTile(
              //   title: AppLocalizations.of(context).useSystemTheme,
              //   leading: Icon(Icons.phone_android),
              //   switchValue: isSwitched,
              //   onToggle: (value) {
              //     setState(() {
              //       isSwitched = value;
              //     });
              //   },
              // ),
            ],
          ),
          // SettingsSection(
          //   titlePadding: EdgeInsets.all(20),
          //   title: AppLocalizations.of(context).security,
          //   tiles: [
          //     SettingsTile.switchTile(
          //       title: AppLocalizations.of(context).useFingerprint,
          //       leading: Icon(Icons.fingerprint),
          //       switchValue: true,
          //       onToggle: (value) {},
          //     ),
          //   ],
          // ),
          SettingsSection(
            titlePadding: EdgeInsets.all(20),
            title: AppLocalizations.of(context).account,
            tiles: [
              SettingsTile(
                title: AppLocalizations.of(context).deleteAccount,
                leading: Icon(Icons.lock),
                onPressed: (context) async {},
                titleTextStyle: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
