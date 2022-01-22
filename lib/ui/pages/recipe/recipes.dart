import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/core/caching/recipe_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/signin_signout.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/recipe/recipe-filter-dialog.component.dart';
import 'package:cookable_flutter/ui/components/recipe/recipe-tile.component.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
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
  RecipeService recipeService = RecipeService();
  DefaultNutrients defaultNutrients;
  String apiToken;
  bool loading = false;
  bool error = false;

  void loadRecipes({reload = false}) async {
    setState(() {
      error = false;
      loading = true;
    });
    var prefs = await SharedPreferences.getInstance();
    var dietIndex = prefs.getInt('recipeDietFilter') ?? Diet.NORMAL.index;
    var highProteinFilter = prefs.getBool('highProteinFilter') ?? false;
    var highCarbFilter = prefs.getBool('highCarbFilter') ?? false;
    var diet = Diet.values[dietIndex];
    setState(() {
      recipeList = [];
    });

    recipeList = await recipeService
        .getFilteredRecipes(diet, highProteinFilter, highCarbFilter,
            reload: reload)
        .catchError((error) {
      print("filtered recipes " + error.toString());
      setState(() {
        this.error = true;
      });
    });
    // reset reload flag after loading
    if (reload) {
      NeedsRecipeUpdateState().recipesUpdateNeeded = false;
    }
    apiToken = await TokenStore().getToken();
    await loadDefaultNutrition().catchError((error) {
      print("default nutrition" + error.toString());
      setState(() {
        this.error = true;
      });
    });
    setState(() {
      loading = false;
    });
  }

  Future<void> loadDefaultNutrition() async {
    recipeService.getDefaultNutrients()
        .then((nutrients) => {defaultNutrients = nutrients});
  }

  @override
  void initState() {
    super.initState();
    var reload = NeedsRecipeUpdateState().recipesUpdateNeeded;
    loadRecipes(reload: reload);
  }

  @override
  Widget build(BuildContext context) {
    if (loading && !error)
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).recipes),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              IconButton(
                icon: Icon(Icons.filter_list),
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
    else if (!error)
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).recipes),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
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
              )));
    else
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).recipes),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
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
              child: Container(
            height: 100,
            child: Card(
                elevation: 10,
                // height: 400,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child:
                          Text(AppLocalizations.of(context).somethingWentWrong),
                    ),
                    ElevatedButton(
                        onPressed: refreshTriggered,
                        child: Text(AppLocalizations.of(context).tryAgain))
                  ],
                )),
          )));
  }

  List<Widget> getAllTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < recipeList.length; i++) {
      myTiles.add(
        RecipeTileComponent(
            recipe: recipeList[i],
            apiToken: apiToken,
            userFoodUpdatedCallback: reloadRecipes),
      );
    }
    return myTiles;
  }

  reloadRecipes() {
    loadRecipes(reload: true);
  }

  Future<void> refreshTriggered() async {
    print("refresh recipes");
    return loadRecipes(reload: true);
  }

  Future<void> _showFilterDialog() async {
    var prefs = await SharedPreferences.getInstance();
    var dietIndex = prefs.getInt('recipeDietFilter') ?? Diet.NORMAL.index;
    var diet = Diet.values[dietIndex];
    var highProteinFilter = prefs.getBool('highProteinFilter') ?? false;
    var highCarbFilter = prefs.getBool('highCarbFilter') ?? false;

    int dietIndexNew;
    bool highProteinFilterNew;
    bool highCarbFilterNew;
    bool changedFilters;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new FilterRecipesDialog(
          diet: diet,
          filterHighCarb: highCarbFilter,
          filterHighProtein: highProteinFilter,
        );
      },
    ).then((_) => {
          dietIndexNew = prefs.getInt('recipeDietFilter') ?? Diet.NORMAL.index,
          highProteinFilterNew = prefs.getBool('highProteinFilter') ?? false,
          highCarbFilterNew = prefs.getBool('highCarbFilter') ?? false,
          changedFilters = !(dietIndexNew == dietIndex &&
              highProteinFilterNew == highProteinFilter &&
              highCarbFilterNew == highCarbFilter),
          if (changedFilters) {loadRecipes(reload: true)}
        });
  }

  Future<void> _signOut() async {
    signOut(context);
  }

  Future<void> _openSettings() async {
    print('settings');
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
    print('settings completed');
  }
}
