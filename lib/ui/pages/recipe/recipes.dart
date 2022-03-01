import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/common/constants.dart';
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
  bool loadingFromApi = false;
  bool error = false;
  List recipeBannerColors = Constants.neutralColors1;

  Color _getRecipeBannerColor(int i) {
    return this.recipeBannerColors[i % this.recipeBannerColors.length];
  }

  void loadRecipes({reload = false, itemsInStockChanged = false}) async {
    setState(() {
      error = false;
      loadingFromApi = reload;
    });
    var prefs = await SharedPreferences.getInstance();
    var dietIndex = prefs.getInt('recipeDietFilter') ?? Diet.NORMAL.index;
    var highProteinFilter = prefs.getBool('highProteinFilter') ?? false;
    var highCarbFilter = prefs.getBool('highCarbFilter') ?? false;
    var diet = Diet.values[dietIndex];

    setState(() {
      recipeList = [];
    });

    var recipes = await recipeService
        .getFilteredRecipesOffline(diet, highProteinFilter, highCarbFilter,
            doReload: reload, itemsInStockChanged: itemsInStockChanged)
        .catchError((error) {
      print("filtered recipes " + error.toString());
      setState(() {
        this.error = true;
      });
    });
    setState(() {
      recipeList = recipes;
    });
    // reset reload flag after loading
    if (reload) {
      NeedsRecipeUpdateState().recipesUpdateNeeded = false;
    }
    apiToken = await TokenStore().getToken();
    await loadDefaultNutrition(reload: reload).catchError((error) {
      print("default nutrition" + error.toString());
      setState(() {
        this.error = true;
      });
    });
    setState(() {
      loadingFromApi = false;
    });
  }

  Future<void> loadDefaultNutrition({bool reload = false}) async {
    recipeService
        .getDefaultNutrients(reload: reload)
        .then((nutrients) => {defaultNutrients = nutrients});
  }

  @override
  void initState() {
    super.initState();
    var itemsInStockChanged = NeedsRecipeUpdateState().recipesUpdateNeeded;
    loadRecipes(itemsInStockChanged: itemsInStockChanged);
  }

  @override
  Widget build(BuildContext context) {
    if (loadingFromApi && !error)
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: TextField(
              onChanged: (value) {
                setState(() {
                  //searchString = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).searchByIngredient,
                suffixIcon: Icon(Icons.search),
              ),
            ),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
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
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: Center(
              child: CircularProgressIndicator(
            value: null,
            backgroundColor: Colors.teal,
          )));
    else if (!error)
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            // Todo try out this one https://pub.dev/packages/animated_search_bar
            // todo and this https://api.flutter.dev/flutter/material/Autocomplete-class.html
            title: TextField(
              onChanged: (value) {
                setState(() {
                  //searchString = value.toLowerCase();
                });
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).searchByIngredient,
                labelStyle: TextStyle(color: Colors.white54),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
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
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: RefreshIndicator(
              onRefresh: refreshTriggered,
              child: Container(
                color: Colors.black87,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView.builder(
                      primary: true,
                      padding: const EdgeInsets.all(0),
                      itemCount: recipeList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return RecipeTileComponent(
                          key: ValueKey(recipeList[i].id),
                          recipe: recipeList[i],
                          apiToken: apiToken,
                          userFoodUpdatedCallback: reloadRecipes,
                          likesUpdated: () => reloadRecipe(recipeList[i].id, i),
                          bannerColor: _getRecipeBannerColor(i),
                        );
                      }),
                ),
              )));
    else
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(
              AppLocalizations.of(context).recipes,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              // AppLocalizations.of(context).logout
              // AppLocalizations.of(context).settings
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
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
                  color: Colors.white,
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

  reloadRecipes() {
    loadRecipes(itemsInStockChanged: true);
  }

  reloadRecipe(id, index) async {
    // Todo problem: when likes changed, pop does not return on same height as before
    var recipe = await recipeService.getRecipe(id);
    setState(() {
      recipeList[index] = recipe;
    });
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
    showModalBottomSheet<void>(
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
          if (changedFilters)
            {
              loadRecipes(),
            }
        });
  }

  Future<void> _signOut() async {
    signOut(context);
  }

  Future<void> _openSettings() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }
}
