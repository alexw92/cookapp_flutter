import 'package:cookable_flutter/ui/components/fridgenew.component.dart';
import 'package:cookable_flutter/ui/components/recipes.component.dart';
import 'package:cookable_flutter/ui/pages/dashboard.dart';
import 'package:cookable_flutter/ui/pages/login_screen.dart';
import 'package:cookable_flutter/ui/pages/profile.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'image_upload_test.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get error => null;

  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    // FridgeComponent(),
    ToggleFridgeWidget(),
    RecipesComponent(),
    ProfilePage(),
    ImageUploadPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Foodict'),
          actions: [
            // AppLocalizations.of(context).logout
            // AppLocalizations.of(context).settings
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(AppLocalizations.of(context).settings),
                  onTap: _openSettings,
                ),
                // PopupMenuItem(
                //   child: Text(AppLocalizations.of(context).logout),
                //   onTap: _signOut,
                // )
              ],
              icon: Icon(
                Icons.settings,
              ),
            ),
            IconButton(onPressed: _openSettings, icon: Icon(Icons.settings))
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context).home,
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.shopping_basket),
            //   label: 'Fridge',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: AppLocalizations.of(context).fridge,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lunch_dining),
              label: AppLocalizations.of(context).recipes,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppLocalizations.of(context).profile,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'ImageTest',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    print('signout');
    await FirebaseAuth.instance.signOut();
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> _openSettings() async {
    print('settings');
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
    print('settings completed');
  }
}
