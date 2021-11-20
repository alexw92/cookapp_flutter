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
  _PrivateRecipesComponentState createState() => _PrivateRecipesComponentState();
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
    print(recipeList);
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
                icon: Icon(Icons.add),
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
                icon: Icon(Icons.add),
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
                  child: GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(0),
                    crossAxisCount: 1,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    children: [...getAllTiles()],
                  ),
                ),
              )
          ));
  }

  List<Widget> getAllTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < recipeList.length; i++) {
      myTiles.add(
        PrivateRecipeTileComponent(privateRecipe: recipeList[i], apiToken: apiToken),
      );
    }
    return myTiles;
  }

  Future<void> refreshTriggered() async {
    print("refresh recipes");
    return loadRecipes();
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

  Future<void> _showRecipeCreateDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new CreateRecipeDialog();
      },
    ).then((privateRecipe) => {
      print("private recipe after diag: "+privateRecipe.toString()),
      if(privateRecipe != null){
        _openEditRecipeScreen(privateRecipe)
      }
    }, onError: (error) =>{
      print("Error in recipes "+error)
    });
  }

  Future<void> _openEditRecipeScreen(PrivateRecipe privateRecipe) async {
    print('editRecipeScreen');
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => RecipeEditPage(privateRecipe.id)));
    print('editRecipeScreen completed');
  }
}
