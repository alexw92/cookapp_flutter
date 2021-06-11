import 'package:cookable_flutter/ui/components/app-bar.component.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get error => null;

  @override
  Widget build(BuildContext context) {
    RecipeController.getRecipes().then(
        (result) => print("List contains ${result.length} foodProducts."),
        onError: (error) => print("error requesting recipes"));
    FoodProductController.getFoodProducts().then(
        (result) => print("List contains ${result.length} recipes."),
        onError: (error) => print("error requesting food products"));
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
              Container(
                child: Center(
                  child: Text('My Ingredients'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Favourite Cookable Recipes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
