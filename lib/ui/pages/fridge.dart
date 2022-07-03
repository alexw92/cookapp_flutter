import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/core/caching/foodproduct_service.dart';
import 'package:cookable_flutter/core/caching/userfood_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/signin_signout.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/request-ingredient-dialog.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
import 'package:cookable_flutter/ui/pages/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToggleFridgeWidget extends StatefulWidget {
  int pageIndex = 0;

  ToggleFridgeWidget({Key key}) : super(key: key);

  @override
  CheckBoxListTileState createState() => new CheckBoxListTileState();
}

class CheckBoxListTileState extends State<ToggleFridgeWidget>
    with SingleTickerProviderStateMixin {
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelFruits = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelVegetables = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelSpices = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelPantry = [];
  List<GroceryCheckBoxListTileModel> checkBoxListTileModelDairy = [];

  // List<GroceryCheckBoxListTileModel> checkBoxListTileModelMeat = [];
  // List<GroceryCheckBoxListTileModel> checkBoxListTileModelFish = [];
  List<List<GroceryCheckBoxListTileModel>> tileLists = [];
  List<UserFoodProduct> ownedGroceries = [];
  List<UserFoodProduct> missingGroceries = [];
  List<FoodProduct> foodProducts = [];
  int itemsOnShoppingList = 0;
  UserFoodService userFoodService = UserFoodService();
  FoodProductService foodProductService = FoodProductService();
  String apiToken;
  bool loadingFromApi = false;
  bool error = false;
  Future<void> _loadingRecipe;
  List<GroceryCheckBoxListTileModel> groceries;
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _loadingRecipe,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                  backgroundColor: Colors.black87,
                  appBar: AppBar(
                    backgroundColor: Colors.teal,
                    title: Text(
                      AppLocalizations.of(context).fridge,
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      InkWell(
                        onTap: _openClickAddIngredient,
                        child: Container(
                          width: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: Colors.white,
                                  ),
                                  //   Text("text", overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _openShoppingList,
                        child: Container(
                          width: 72,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.shoppingCart,
                                    color: Colors.white,
                                  ),
                                  //   Text("text", overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ],
                          ),
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
                              child:
                                  Text(AppLocalizations.of(context).settings),
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
                    color: Colors.white,
                    backgroundColor: Colors.green,
                  )));
            default:
              if (!snapshot.hasError)
                return Scaffold(
                    backgroundColor: Colors.black87,
                    appBar: AppBar(
                      backgroundColor: Colors.teal,
                      title: Text(AppLocalizations.of(context).fridge,
                          style: TextStyle(color: Colors.white)),
                      actions: [
                        InkWell(
                          onTap: _openClickAddIngredient,
                          child: Container(
                            width: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(
                                      FontAwesomeIcons.plus,
                                      color: Colors.white,
                                    ),
                                    //   Text("text", overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _openShoppingList,
                          child: Container(
                            width: 72,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(
                                      FontAwesomeIcons.shoppingCart,
                                      color: Colors.white,
                                    ),
                                    //   Text("text", overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                itemsOnShoppingList > 0
                                    ? Positioned(
                                        top: 4,
                                        right: 2,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "$itemsOnShoppingList",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
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
                                child:
                                    Text(AppLocalizations.of(context).settings),
                                value: 0),
                            PopupMenuItem(
                                child:
                                    Text(AppLocalizations.of(context).logout),
                                value: 1)
                          ],
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    body: Scaffold(
                        backgroundColor: Colors.black54,
                        appBar: AppBar(
                          backgroundColor: Colors.teal,
                          toolbarHeight: 0,
                          bottom: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabs: [
                              Tab(
                                  text:
                                      AppLocalizations.of(context).tab_fruits),
                              Tab(
                                  text: AppLocalizations.of(context)
                                      .tab_vegetables),
                              Tab(
                                  text:
                                      AppLocalizations.of(context).tab_spices),
                              Tab(
                                  text:
                                      AppLocalizations.of(context).tab_pantry),
                              Tab(text: AppLocalizations.of(context).tab_dairy),
                              // Tab(text: AppLocalizations.of(context).tab_meat),
                              // Tab(text: AppLocalizations.of(context).tab_fish),
                            ],
                          ),
                        ),
                        body: getTabBarView()));
              else
                return Scaffold(
                    backgroundColor: Colors.black87,
                    appBar: AppBar(
                      title: Text(AppLocalizations.of(context).fridge),
                      backgroundColor: Colors.teal,
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
                                child:
                                    Text(AppLocalizations.of(context).settings),
                                value: 0),
                            PopupMenuItem(
                                child:
                                    Text(AppLocalizations.of(context).logout),
                                value: 1)
                          ],
                          icon: Icon(
                            Icons.settings,
                          ),
                        )
                      ],
                    ),
                    body: Scaffold(
                        backgroundColor: Colors.black87,
                        appBar: AppBar(
                          toolbarHeight: 0,
                          backgroundColor: Colors.teal,
                          bottom: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabs: [
                              Tab(
                                  text:
                                      AppLocalizations.of(context).tab_fruits),
                              Tab(
                                  text: AppLocalizations.of(context)
                                      .tab_vegetables),
                              Tab(
                                  text:
                                      AppLocalizations.of(context).tab_spices),
                              Tab(
                                  text:
                                      AppLocalizations.of(context).tab_pantry),
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
                                    child: Text(AppLocalizations.of(context)
                                        .somethingWentWrong),
                                  ),
                                  ElevatedButton(
                                      onPressed: refreshTriggered,
                                      child: Text(AppLocalizations.of(context)
                                          .tryAgain))
                                ],
                              )),
                        ))));
          }
        });
  }

  TabBarView getTabBarView() {
    return TabBarView(controller: _tabController, children: [
      ...List.generate(
          tileLists.length,
          (categoryIndex) => RefreshIndicator(
                key: new PageStorageKey<String>(
                    'FridgeTabBarView:$categoryIndex'),
                onRefresh: refreshTriggered,
                child: new Container(
                    child: new ListView.builder(
                        itemCount: tileLists[categoryIndex].length,
                        padding: EdgeInsets.all(10),
                        itemBuilder: (BuildContext context, int index) {
                          var item = tileLists[categoryIndex][index];
                          return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: item.isCheck
                                    ? Colors.black87
                                    : Colors.black87,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                    color: item.isOnShoppingList
                                        ? Colors.yellow
                                        : item.isCheck
                                            ? Colors.green
                                            : Colors.red,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0), // Shadow position
                                  ),
                                ],
                              ),
                              child: Row(children: [
                                new Flexible(
                                  child: new SwitchListTile(
                                      activeColor: Colors.green,
                                      inactiveThumbColor: item.isOnShoppingList
                                          ? Colors.yellow
                                          : Colors.red,
                                      inactiveTrackColor: item.isOnShoppingList
                                          ? Color(0xFFACAA00)
                                          : Color(0xFFAA3300),
                                      dense: true,
                                      title: new Text(
                                        item.title,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                            color: Colors.white),
                                      ),
                                      value: item.isCheck,
                                      secondary: item.isLoading
                                          ? CircularProgressIndicator(
                                              value: null,
                                              color: item.isOnShoppingList
                                                  ? Colors.yellow
                                                  : item.isCheck
                                                      ? Colors.green
                                                      : Colors.red,
                                              backgroundColor: Colors.white,
                                            )
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              child: Image(
                                                  image: CachedNetworkImageProvider(
                                                      "${item.img}",
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
                                      FontAwesomeIcons.cartPlus,
                                      color: item.isOnShoppingList
                                          ? Colors.yellow
                                          : Colors.white,
                                      size: 36,
                                    ),
                                    onTap: () {
                                      itemChange(categoryIndex, null, index,
                                          !item.isOnShoppingList);
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

  Future refreshTriggered() {
    print("refresh triggered");
    _loadingRecipe = loadFoodProducts(reload: true);
    return _loadingRecipe;
  }

  Future<void> loadFoodProducts({reload = false}) async {
    try {
      foodProducts = await foodProductService.getFoodProducts(reload: reload);
      ownedGroceries = await userFoodService.getUserFood(false, reload: reload);
      missingGroceries =
          await userFoodService.getUserFood(true, reload: reload);
    } catch (err) {
      print(err);
    }
    setState(() {
      itemsOnShoppingList =
          missingGroceries.where((element) => element.onShoppingList).length;
    });
    apiToken = await TokenStore().getToken();
    groceries = getGroceries();
    setState(() {
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
      // this.checkBoxListTileModelMeat.clear();
      // this.checkBoxListTileModelMeat.addAll(groceries
      //     .where((element) => element.foodCategory.name.contains("meat"))
      //     .toList());
      // this.checkBoxListTileModelFish.clear();
      // this.checkBoxListTileModelFish.addAll(groceries
      //     .where((element) => element.foodCategory.name.contains("fish"))
      //     .toList());
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
      // checkBoxListTileModelMeat,
      // checkBoxListTileModelFish
    ]);
    _loadingRecipe = loadFoodProducts();
    _tabController = new TabController(
        length: 5, initialIndex: _getInitialIndex(), vsync: this);
    _tabController.addListener(() {
      print("New Index ${_tabController.index}");
      PageStorage.of(context).writeState(context, _tabController.index,
          identifier: ValueKey("fridge_tab_key"));
    });
    setState(() {});
  }

  int _getInitialIndex() {
    int initialIndex = PageStorage.of(context)
            .readState(context, identifier: ValueKey("fridge_tab_key")) ??
        0;
    print("Initial Index $initialIndex");
    return initialIndex;
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
        await userFoodService.addBoxValue(true, item);
        await userFoodService.removeBoxValue(false, item);
        // changing grocery stock requires reloading of recipes
        NeedsRecipeUpdateState().recipesUpdateNeeded = true;
      } else {
        item = missingGroceries
            .firstWhereOrNull((item) => item.foodProductId == groceryId);
        item.onShoppingList = true;
        await userFoodService.addBoxValue(true, item);
        NeedsRecipeUpdateState().recipesUpdateNeeded = true;
        // item was missing before
        // item was on shopping List before -> cant happen i think
      }
      // update shopping list number
      setState(() {
        itemsOnShoppingList =
            missingGroceries.where((element) => element.onShoppingList).length;
      });
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
        await userFoodService.addBoxValue(true, item);
        // update shopping list number
        setState(() {
          itemsOnShoppingList = missingGroceries
              .where((element) => element.onShoppingList)
              .length;
        });
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
      await userFoodService.removeBoxValue(true, item);
      await userFoodService.addBoxValue(false, item);
    } else if (setTo == false) {
      var item = ownedGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      // if item was on shopping list before
      if (item.onShoppingList) {
        item.onShoppingList = false;
      }
      ownedGroceries.remove(item);
      missingGroceries.add(item);
      await userFoodService.addBoxValue(true, item);
      await userFoodService.removeBoxValue(false, item);
      // update shopping list number
      setState(() {
        itemsOnShoppingList =
            missingGroceries.where((element) => element.onShoppingList).length;
      });
    }
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
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  Future<void> _openShoppingList() async {
    // remove snackBar because it would overlap with next screen
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShoppingListPage()));
    this.missingGroceries = await userFoodService.getUserFood(true);
    this.ownedGroceries = await userFoodService.getUserFood(false);
    // update shopping list number
    setState(() {
      itemsOnShoppingList =
          missingGroceries.where((element) => element.onShoppingList).length;
    });
    groceries.clear();
    groceries.addAll(getGroceries());
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
    // this.checkBoxListTileModelMeat.clear();
    // this.checkBoxListTileModelMeat.addAll(groceries
    //     .where((element) => element.foodCategory.name.contains("meat"))
    //     .toList());
    // this.checkBoxListTileModelFish.clear();
    // this.checkBoxListTileModelFish.addAll(groceries
    //     .where((element) => element.foodCategory.name.contains("fish"))
    //     .toList());
    setState(() {});
  }

  void _openClickAddIngredient() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new RequestIngredientDialog();
        });
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
