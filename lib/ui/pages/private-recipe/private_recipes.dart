import 'package:cookable_flutter/core/caching/private_recipe_service.dart';
import 'package:cookable_flutter/core/caching/recipe_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/signin_signout.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/private-recipe/private-recipe-tile.component.dart';
import 'package:cookable_flutter/ui/components/recipe/recipe-tile.component.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private-recipe-creation-dialog.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private-recipe-edit-page.dart';
import 'package:cookable_flutter/ui/pages/recipe/recipes.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivateRecipesComponent extends StatefulWidget {
  int pageIndex = 0;

  PrivateRecipesComponent({Key key}) : super(key: key);

  @override
  _PrivateRecipesComponentState createState() =>
      _PrivateRecipesComponentState();
}

// Preserve state: https://stackoverflow.com/a/59749688/11751609 seems to have worked
class _PrivateRecipesComponentState extends State<PrivateRecipesComponent>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<PrivateRecipe> recipeList = [];
  List<Recipe> likedRecipesList = [];
  PrivateRecipeService privateRecipeService = PrivateRecipeService();
  RecipeService recipeService = RecipeService();
  DefaultNutrients defaultNutrients;
  String apiToken;
  bool loadingFromApi = false;
  bool error = false;
  TabController _tabController;

  void loadRecipes({reload = false}) async {
    setState(() {
      this.error = false;
      this.loadingFromApi = true;
    });
    recipeList = await privateRecipeService
        .getPrivateRecipes(reload: reload)
        .catchError((error) {
      print("private recipes " + error.toString());
      setState(() {
        this.error = true;
      });
    });
    apiToken = await TokenStore().getToken();
    await loadDefaultNutrition();
    setState(() {
      loadingFromApi = false;
    });
  }

  Future<void> reloadLikedRecipesFromBox() async {
    likedRecipesList =
        await recipeService.getLikedRecipes().catchError((error) {
      print("recipes " + error.toString());
      setState(() {
        this.error = true;
      });
    });
  }

  Future<void> reloadRecipesFromBox() async {
    var recipes = await privateRecipeService
        .getPrivateRecipes(reload: false)
        .catchError((error) {
      print("private recipes " + error.toString());
      setState(() {
        this.error = true;
      });
    });
    setState(() {
      recipeList = recipes;
    });
  }

  Future<void> loadDefaultNutrition() async {
    recipeService
        .getDefaultNutrients()
        .then((nutrients) => {defaultNutrients = nutrients});
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
        length: 2, initialIndex: _getInitialIndex(), vsync: this);
    _tabController.addListener(() {
      print("New Index ${_tabController.index}");
      PageStorage.of(context).writeState(context, _tabController.index,
          identifier: ValueKey("recipe_tab_key"));
    });
    loadRecipes();
    reloadLikedRecipesFromBox();
    print("init state");
  }

  int _getInitialIndex() {
    int initialIndex = PageStorage.of(context)
            .readState(context, identifier: ValueKey("recipe_tab_key")) ??
        0;
    print("Initial Index ${initialIndex}");
    return initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (loadingFromApi)
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
    else if (!error)
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
          body: Scaffold(
              appBar: AppBar(
                  toolbarHeight: 0,
                  bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        Tab(
                          text:
                              AppLocalizations.of(context).tab_favouriteRecipes,
                          icon: Icon(Icons.favorite_outline),
                        ),
                        Tab(
                          text: AppLocalizations.of(context).tab_yourRecipes,
                          icon: Icon(Icons.star),
                        ),
                      ])),
              body: getTabBarView()));
    else
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

  TabBarView getTabBarView() {
    return TabBarView(controller: _tabController, children: [
      RefreshIndicator(
          onRefresh: likedRecipesRefreshTriggered,
          key: new PageStorageKey<String>('PrivateRecipesTabBarView:0'),
          child: likedRecipesList.isNotEmpty
              ? ListView.builder(
                  primary: true,
                  padding: const EdgeInsets.all(0),
                  itemCount: likedRecipesList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return RecipeTileComponent(
                        recipe: likedRecipesList[i], apiToken: apiToken);
                  },
                )
              : Center(
                  child: Card(
                      elevation: 20,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Wrap(children: [
                            Text(
                              AppLocalizations.of(context).prettyEmptyHere,
                              style: TextStyle(fontSize: 26),
                            ),
                            Text(
                              AppLocalizations.of(context).likeRecipeToAdd,
                              style: TextStyle(fontSize: 16),
                            ),
                            Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecipesComponent()));
                                    },
                                    child: Text(AppLocalizations.of(context)
                                        .goToRecipes)))
                          ]))))),
      RefreshIndicator(
          onRefresh: refreshTriggered,
          key: new PageStorageKey<String>('PrivateRecipesTabBarView:1'),
          child: Container(
            color: Colors.green,
            child: Container(
              // height: 400,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: recipeList.isNotEmpty
                  ? ListView(
                      primary: true,
                      padding: const EdgeInsets.all(0),
                      children: [...getAllTiles()],
                    )
                  : Center(
                      child: Card(
                          elevation: 20,
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Wrap(children: [
                                Text(
                                  AppLocalizations.of(context).prettyEmptyHere,
                                  style: TextStyle(fontSize: 26),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .createRecipeToAdd,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Center(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _showRecipeCreateDialog();
                                        },
                                        child: Text(AppLocalizations.of(context)
                                            .createARecipe)))
                              ])))),
            ),
          ))
    ]);
  }

  List<Widget> getAllTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < recipeList.length; i++) {
      myTiles.add(
        Dismissible(
          // https://stackoverflow.com/a/65751311/11751609
          key: UniqueKey(),
          background: Container(
              color: Colors.red,
              child: Icon(
                Icons.delete,
                size: 256,
              )),
          child: PrivateRecipeTileComponent(
              privateRecipe: recipeList[i], apiToken: apiToken),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            bool withdrawDeletion = false;
            PrivateRecipe deletedItem;
            setState(() {
              deletedItem = recipeList.removeAt(i);
            });
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text(
                        "${AppLocalizations.of(context).deletedRecipe} \"${deletedItem.name}\""),
                    action: SnackBarAction(
                        label: AppLocalizations.of(context).undo,
                        onPressed: () => {
                              withdrawDeletion = true,
                              setState(
                                () => recipeList.insert(i, deletedItem),
                              )
                            }),
                  ),
                )
                .closed
                .then((value) => {
                      if (!withdrawDeletion)
                        RecipeController.deletePrivateRecipe(deletedItem.id)
                            .then(
                                (value) => {
                                      // remove also from box
                                      privateRecipeService
                                          .clearPrivateRecipe(deletedItem)
                                    },
                                onError: (error) => {
                                      // if deletion failed we assume recipe still exists
                                      setState(
                                        () => recipeList.insert(i, deletedItem),
                                      ),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${AppLocalizations.of(context).recipeDeletionError}"),
                                        ),
                                      )
                                    })
                    });
          },
        ),
      );
    }
    return myTiles;
  }

  Future<void> refreshTriggered() async {
    return loadRecipes(reload: true);
  }

  Future<void> likedRecipesRefreshTriggered() async {
    return reloadLikedRecipesFromBox();
  }

  Future<void> _signOut() async {
    signOut(context);
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
        (privateRecipe) async => {
              if (privateRecipe != null)
                {
                  await privateRecipeService
                      .addOrUpdatePrivateRecipe(privateRecipe),
                  _openEditRecipeScreen(privateRecipe)
                }
            },
        onError: (error) => {print("Error in recipes " + error)});
  }

  Future<void> _openEditRecipeScreen(PrivateRecipe privateRecipe) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeEditPage(privateRecipe.id)));
    print("after navigate to recipeEditPage called");
    await reloadRecipesFromBox();
    print("reload after navigate to recipeEditPage");
  }

  @override
  bool get wantKeepAlive => true;
}
