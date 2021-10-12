import 'package:cookable_flutter/ui/components/settings/Language_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SettingsList(
        sections: [
          SettingsSection(
            titlePadding: EdgeInsets.all(20),
            title: 'Settings',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: language,
                leading: Icon(Icons.language),
                onPressed: (context) async {
                  final result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LanguagesScreen(language: 'English'),
                  ));
                  this.language = result;
                },
              ),
              SettingsTile.switchTile(
                title: 'Use System Theme',
                leading: Icon(Icons.phone_android),
                switchValue: isSwitched,
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            titlePadding: EdgeInsets.all(20),
            title: 'Security',
            tiles: [
              SettingsTile.switchTile(
                title: 'Use fingerprint',
                leading: Icon(Icons.fingerprint),
                switchValue: true,
                onToggle: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
