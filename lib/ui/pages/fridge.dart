import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/core/caching/userfood_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/signin_signout.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
import 'package:cookable_flutter/ui/pages/shopping_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToggleFridgeWidget extends StatefulWidget {
  ToggleFridgeWidget({Key key}) : super(key: key);

  @override
  CheckBoxListTileState createState() => new CheckBoxListTileState();
}

class CheckBoxListTileState extends State<ToggleFridgeWidget>
    with SingleTickerProviderStateMixin {
  List<GroceryCheckBoxListTileModel> checkBoxListTileModel = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelFruits = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelVegetables = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelSpices = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelPantry = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelDairy = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelMeat = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelFish = [];
  List<List<GroceryCheckBoxListTileModel>> tileLists = [];
  List<UserFoodProduct> ownedGroceries = [];
  List<UserFoodProduct> missingGroceries = [];
  UserFoodService userFoodService = UserFoodService();
  String apiToken;
  bool loading = false;
  bool error = false;
  List<GroceryCheckBoxListTileModel> groceries;
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    if (loading && !error)
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).fridge),
            actions: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.listAlt),
                onPressed: _openShoppingList,
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
    else if (!loading && !error)
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).fridge),
            actions: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.listAlt),
                onPressed: _openShoppingList,
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
                    Tab(text: AppLocalizations.of(context).tab_fruits),
                    Tab(text: AppLocalizations.of(context).tab_vegetables),
                    Tab(text: AppLocalizations.of(context).tab_spices),
                    Tab(text: AppLocalizations.of(context).tab_pantry),
                    Tab(text: AppLocalizations.of(context).tab_dairy),
                    Tab(text: AppLocalizations.of(context).tab_meat),
                    Tab(text: AppLocalizations.of(context).tab_fish),
                  ],
                ),
              ),
              body: getTabBarView()));
    else
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).fridge),
            actions: [
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
                    Tab(text: AppLocalizations.of(context).tab_fruits),
                    Tab(text: AppLocalizations.of(context).tab_vegetables),
                    Tab(text: AppLocalizations.of(context).tab_spices),
                    Tab(text: AppLocalizations.of(context).tab_pantry),
                    Tab(text: AppLocalizations.of(context).tab_dairy),
                    Tab(text: AppLocalizations.of(context).tab_meat),
                    Tab(text: AppLocalizations.of(context).tab_fish),
                  ],
                ),
              ),
              body: Center(
                  child: Container(
                height: 100,
                child: Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                              AppLocalizations.of(context).somethingWentWrong),
                        ),
                        ElevatedButton(
                            onPressed: refreshTriggered,
                            child: Text(AppLocalizations.of(context).tryAgain))
                      ],
                    )),
              ))));
  }

  TabBarView getTabBarView() {
    return TabBarView(controller: _tabController, children: [
      ...List.generate(
          tileLists.length,
          (categoryIndex) => RefreshIndicator(
                onRefresh: refreshTriggered,
                child: new Container(
                    child: new ListView.builder(
                        itemCount: tileLists[categoryIndex].length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                              color: tileLists[categoryIndex][index].isCheck
                                  ? Colors.green
                                  : Colors.grey,
                              child: Row(children: [
                                new Flexible(
                                  child: new SwitchListTile(
                                      activeColor: Colors.black,
                                      dense: true,
                                      title: new Text(
                                        tileLists[categoryIndex][index].title,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      value: (tileLists[categoryIndex])[index]
                                          .isCheck,
                                      secondary:
                                          (tileLists[categoryIndex])[index]
                                                  .isLoading
                                              ? CircularProgressIndicator(
                                                  value: null,
                                                  backgroundColor:
                                                      Colors.orange,
                                                )
                                              : Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Image(
                                                      image: CachedNetworkImageProvider(
                                                          "${(tileLists[categoryIndex])[index].img}",
                                                          imageRenderMethodForWeb:
                                                              ImageRenderMethodForWeb
                                                                  .HttpGet)),
                                                ),
                                      onChanged: (bool val) {
                                        itemChange(
                                            categoryIndex, val, index, null);
                                      }),
                                ),
                                InkWell(
                                    child: FaIcon(
                                      FontAwesomeIcons.listAlt,
                                      color: (tileLists[categoryIndex])[index]
                                              .isOnShoppingList
                                          ? Colors.yellow
                                          : Colors.black,
                                      size: 36,
                                    ),
                                    onTap: () {
                                      itemChange(
                                          categoryIndex,
                                          null,
                                          index,
                                          !(tileLists[categoryIndex])[index]
                                              .isOnShoppingList);
                                    }),
                                SizedBox(
                                  width: 10,
                                  height: 60,
                                )
                              ]));
                        })),
              )),
    ]);
  }

  Future<void> refreshTriggered() async {
    print("refresh triggered");
    return loadFoodProducts(reload: true);
  }

  void loadFoodProducts({reload = false}) async {
    setState(() {
      loading = true;
      error = false;
    });
    try {
      ownedGroceries = await userFoodService.getUserFood(false, reload: reload);
      missingGroceries =
          await userFoodService.getUserFood(true, reload: reload);
    } catch (err) {
      print(err);
      setState(() {
        this.loading = false;
        this.error = true;
      });
    }
    apiToken = await TokenStore().getToken();
    groceries = getGroceries();
    setState(() {
      this.checkBoxListTileModel = groceries;
      this.checkBoxListTileModelFruits.clear();
      this.checkBoxListTileModelFruits.addAll(groceries
          .where((element) => element.foodCategory.name.contains("fruits"))
          .toList());
      this.checkBoxListTileModelVegetables.clear();
      this.checkBoxListTileModelVegetables.addAll(groceries
          .where((element) => element.foodCategory.name.contains("vegetables"))
          .toList());
      this.checkBoxListTileModelSpices.clear();
      this.checkBoxListTileModelSpices.addAll(groceries
          .where((element) => element.foodCategory.name.contains("spices"))
          .toList());
      this.checkBoxListTileModelPantry.clear();
      this.checkBoxListTileModelPantry.addAll(groceries
          .where((element) => element.foodCategory.name.contains("pantry"))
          .toList());
      this.checkBoxListTileModelDairy.clear();
      this.checkBoxListTileModelDairy.addAll(groceries
          .where((element) => element.foodCategory.name.contains("dairy"))
          .toList());
      this.checkBoxListTileModelMeat.clear();
      this.checkBoxListTileModelMeat.addAll(groceries
          .where((element) => element.foodCategory.name.contains("meat"))
          .toList());
      this.checkBoxListTileModelFish.clear();
      this.checkBoxListTileModelFish.addAll(groceries
          .where((element) => element.foodCategory.name.contains("fish"))
          .toList());
      loading = false;
    });
  }

  List<GroceryCheckBoxListTileModel> getGroceries() {
    var groceryListTiles = this
        .ownedGroceries
        .map((grocery) => GroceryCheckBoxListTileModel(
            groceryId: grocery.foodProductId,
            foodCategory: grocery.foodCategory,
            img: grocery.imgSrc,
            isCheck: true,
            isOnShoppingList: false,
            title: grocery.name,
            isLoading: false))
        .toList();
    var sortedMissingGroceries = this
        .missingGroceries
        .map((grocery) => GroceryCheckBoxListTileModel(
            groceryId: grocery.foodProductId,
            foodCategory: grocery.foodCategory,
            img: grocery.imgSrc,
            isCheck: false,
            isOnShoppingList: grocery.onShoppingList,
            title: grocery.name,
            isLoading: false))
        .toList();
    sortedMissingGroceries.sort((a, b) {
      if (a.isOnShoppingList)
        return -1;
      else
        return 1;
    });

    groceryListTiles.addAll(sortedMissingGroceries);
    return groceryListTiles;
  }

  @override
  void initState() {
    super.initState();
    tileLists.addAll([
      checkBoxListTileModelFruits,
      checkBoxListTileModelVegetables,
      checkBoxListTileModelSpices,
      checkBoxListTileModelPantry,
      checkBoxListTileModelDairy,
      checkBoxListTileModelMeat,
      checkBoxListTileModelFish
    ]);

    loadFoodProducts();
    _tabController = new TabController(length: 7, vsync: this);
  }

  Future<void> toggleItem(
      int groceryId, bool setTo, bool onShoppingList) async {
    if (onShoppingList == true) {
      // item was in stock before
      var item = ownedGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      if (item != null) {
        item.onShoppingList = true;
        ownedGroceries.remove(item);
        missingGroceries.add(item);
        await userFoodService.updateBoxValues(true, missingGroceries);
        await userFoodService.updateBoxValues(false, ownedGroceries);
        // changing grocery stock requires reloading of recipes
        NeedsRecipeUpdateState().recipesUpdateNeeded = true;
      } else {
        item = missingGroceries
            .firstWhereOrNull((item) => item.foodProductId == groceryId);
        item.onShoppingList = true;
        await userFoodService.updateBoxValues(true, missingGroceries);
        NeedsRecipeUpdateState().recipesUpdateNeeded = true;
        // item was missing before
        // item was on shopping List before -> cant happen i think
      }
      // show snackBar if added to shopping list
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${AppLocalizations.of(context).addedToShoppingList} ${item.name}"),
        ),
      );
      return;
    } else if (onShoppingList == false) {
      // item was in stock before
      var item = ownedGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      if (item != null) {
        print(
            "Error: item requested to be removed from shopping list but was owned!");
        return;
      } else {
        var item = missingGroceries
            .firstWhereOrNull((item) => item.foodProductId == groceryId);
        if (item == null) {
          print("Error: severe error, item was in neither of the lists!");
          return;
        }
        item.onShoppingList = false;
        await userFoodService.updateBoxValues(true, missingGroceries);
        NeedsRecipeUpdateState().recipesUpdateNeeded = true;
        // item was missing before
        // item was not on shopping List before -> cant happen i think
        return;
      }
    }
    // set from not owned to owned
    if (setTo == true) {
      var item = missingGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      // item was on shopping list before
      if (item.onShoppingList) {
        item.onShoppingList = false;
      }
      missingGroceries.remove(item);
      ownedGroceries.add(item);
    } else if (setTo == false) {
      var item = ownedGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      // if item was on shopping list before
      if (item.onShoppingList) {
        item.onShoppingList = false;
      }
      ownedGroceries.remove(item);
      missingGroceries.add(item);
    }
    await userFoodService.updateBoxValues(true, missingGroceries);
    await userFoodService.updateBoxValues(false, ownedGroceries);
    // changing grocery stock requires reloading of recipes
    NeedsRecipeUpdateState().recipesUpdateNeeded = true;
  }

  void updateUserFoodState(
      GroceryCheckBoxListTileModel tileModel, bool val, bool onShoppingList) {
    if (val != null && onShoppingList != null ||
        val == null && onShoppingList == null) {
      print("Error: either val or on shoppingList must be null but not both!");
      setState(() {
        tileModel.isLoading = false;
      });
      return;
    }
    if (val == true && onShoppingList == true) {
      print(
          "Error: impossible state, item cant be in stock and on shopping list!");
      setState(() {
        tileModel.isLoading = false;
      });
      return;
    }
    UserFoodProductController.toggleUserFoodProduct(
            tileModel.groceryId, val, onShoppingList)
        .then((value) => setState(() {
              tileModel.isCheck = val == null ? false : val;
              tileModel.isOnShoppingList =
                  onShoppingList == null ? false : onShoppingList;
              tileModel.isLoading = false;
              toggleItem(tileModel.groceryId, val, onShoppingList);
            }));
  }

  void itemChange(int categoryIndex, bool val, int index, bool onShoppingList) {
    var tileModel = (tileLists[categoryIndex])[index];
    setState(() {
      tileModel.isLoading = true;
    });
    updateUserFoodState(tileModel, val, onShoppingList);
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

  Future<void> _openShoppingList() async {
    print('shopping list');
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShoppingListPage()));
    print('shopping list completed');
  }
}

class GroceryCheckBoxListTileModel {
  int groceryId;
  FoodCategory foodCategory;
  String img;
  String title;
  bool isCheck;
  bool isLoading;
  bool isOnShoppingList;

  GroceryCheckBoxListTileModel(
      {this.groceryId,
      this.foodCategory,
      this.img,
      this.title,
      this.isCheck,
      this.isLoading,
      this.isOnShoppingList});
}
