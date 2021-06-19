import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/fridge.component.dart';
import 'package:cookable_flutter/ui/components/recepies.component.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get error => null;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .signInAnonymously()
        .then((UserCredential user) => {TokenStore().getToken()});

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Fridge',
                    style: CookableTheme.noramlWhiteFont,
                  ),
                ),
                Tab(
                  child: Text('Recipes', style: CookableTheme.noramlWhiteFont),
                ),
              ],
            ),
            title: Container(
              child: Center(
                child: Text(
                  'Cookable',
                  style: CookableTheme.largeBoldFont,
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              FridgeComponent(),
              RecepiesComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
