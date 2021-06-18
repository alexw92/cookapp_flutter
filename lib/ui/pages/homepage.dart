import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/ui/components/app-bar.component.dart';
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
    FirebaseAuth.instance.signInAnonymously().then((UserCredential user) => {
          RecipeController.getRecipes().then(
              (result) => print("List contains ${result.length} recipes."),
              onError: (error) => print("error requesting recipes: $error")),
          FoodProductController.getFoodProducts().then(
              (result) => print("List contains ${result.length} food products."),
              onError: (error) => print("error requesting food products: $error"))
        });

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
