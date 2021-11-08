import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/recipe-tile.component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipesComponent extends StatefulWidget {
  RecipesComponent({Key key}) : super(key: key);

  @override
  _RecipesComponentState createState() => _RecipesComponentState();
}

class _RecipesComponentState extends State<RecipesComponent> {
  List<Recipe> recipeList = [];
  String apiToken;
  bool loading = false;

  void loadRecipes() async {
    loading = true;
    recipeList = await RecipeController.getRecipes();
    apiToken = await TokenStore().getToken();
    await loadDefaultNutrition();
    setState(() {
      loading = false;
    });
  }

  Future<void> loadDefaultNutrition() async {
    var prefs = await SharedPreferences.getInstance();
    RecipeController.getDefaultNutrients().then((nutrients) => {
          prefs.setInt('dailyCalories', nutrients.recDailyCalories),
          prefs.setDouble('dailyCarbohydrate', nutrients.recDailyCarbohydrate),
          prefs.setDouble('dailyProtein', nutrients.recDailyProtein),
          prefs.setDouble('dailyFat', nutrients.recDailyFat)
        });
  }

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).recipes),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              PopupMenuButton(
                onSelected: (result) {
                  switch (result) {
                    case 0:
                      1;
                      break;
                    case 1:
                      0;
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: Text(AppLocalizations.of(context).settings),
                      value: 0),
                  PopupMenuItem(
                      child: Text(AppLocalizations.of(context).logout),
                      value: 1)
                ],
                icon: Icon(
                  Icons.settings,
                ),
              )
            ],
          ),
          body: Center(
              child: CircularProgressIndicator(
            value: null,
            backgroundColor: Colors.green,
          )));
    else
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).recipes),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              PopupMenuButton(
                onSelected: (result) {
                  switch (result) {
                    case 0:
                      0;
                      break;
                    case 1:
                      1;
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: Text(AppLocalizations.of(context).settings),
                      value: 0),
                  PopupMenuItem(
                      child: Text(AppLocalizations.of(context).logout),
                      value: 1)
                ],
                icon: Icon(
                  Icons.settings,
                ),
              )
            ],
          ),
          body: RefreshIndicator(
              onRefresh: refreshTriggered,
              child: Container(
                color: Colors.green,
                child: Container(
                  // height: 400,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(0),
                    crossAxisCount: 1,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    children: [...getAllTiles()],
                  ),
                ),
              )));
  }

  List<Widget> getAllTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < recipeList.length; i++) {
      myTiles.add(
        RecipeTileComponent(recipe: recipeList[i], apiToken: apiToken),
      );
    }
    return myTiles;
  }

  Future<void> refreshTriggered() async {
    print("refresh recipes");
    return loadRecipes();
  }
}
