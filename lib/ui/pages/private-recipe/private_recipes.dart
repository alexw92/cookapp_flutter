import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/private-recipe/private-recipe-tile.component.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private-recipe-creation-dialog.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private-recipe-edit-page.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_screen.dart';

class PrivateRecipesComponent extends StatefulWidget {
  PrivateRecipesComponent({Key key}) : super(key: key);

  @override
  _PrivateRecipesComponentState createState() =>
      _PrivateRecipesComponentState();
}

class _PrivateRecipesComponentState extends State<PrivateRecipesComponent> {
  List<PrivateRecipe> recipeList = [];
  String apiToken;
  bool loading = false;

  void loadRecipes() async {
    loading = true;
    setState(() {
      recipeList = [];
    });
    recipeList = await RecipeController.getPrivateRecipes();
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
            title: Text(AppLocalizations.of(context).yourRecipes),
            actions: [
              IconButton(
                icon: Icon(Icons.add, size: 32),
              ),
              PopupMenuButton(
                onSelected: (result) {
                  switch (result) {
                    case 0:
                      _openSettings();
                      break;
                    case 1:
                      _signOut();
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
            title: Text(AppLocalizations.of(context).yourRecipes),
            actions: [
              IconButton(
                icon: Icon(Icons.add, size: 32),
                onPressed: _showRecipeCreateDialog,
              ),
              PopupMenuButton(
                onSelected: (result) {
                  switch (result) {
                    case 0:
                      _openSettings();
                      break;
                    case 1:
                      _signOut();
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
                  child: ListView(
                    primary: true,
                    padding: const EdgeInsets.all(0),
                    children: [...getAllTiles()],
                  ),
                ),
              )));
  }

  List<Widget> getAllTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < recipeList.length; i++) {
      myTiles.add(
        Dismissible(
          // https://stackoverflow.com/a/65751311/11751609
          key: UniqueKey(),
          child: PrivateRecipeTileComponent(
              privateRecipe: recipeList[i], apiToken: apiToken),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // added this block
            PrivateRecipe deletedItem = recipeList.removeAt(i);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${AppLocalizations.of(context).deletedRecipe} \"${deletedItem.name}\""),
                action: SnackBarAction(
                    label: AppLocalizations.of(context).undo,
                    onPressed: () => setState(
                          () => recipeList.insert(i, deletedItem),
                        ) // this is what you needed
                    ),
              ),
            );
          },
        ),
      );
    }
    return myTiles;
  }

  Future<void> refreshTriggered() async {
    return loadRecipes();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> _openSettings() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  Future<void> _showRecipeCreateDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new CreateRecipeDialog();
      },
    ).then(
        (privateRecipe) => {
              if (privateRecipe != null) {_openEditRecipeScreen(privateRecipe)}
            },
        onError: (error) => {print("Error in recipes " + error)});
  }

  Future<void> _openEditRecipeScreen(PrivateRecipe privateRecipe) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeEditPage(privateRecipe.id)));
  }
}
