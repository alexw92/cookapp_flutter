import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/pages/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_screen.dart';

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
  List<UserFoodProduct> ownedGroceries = [];
  List<UserFoodProduct> missingGroceries = [];
  String apiToken;
  bool loading = false;
  List<GroceryCheckBoxListTileModel> groceries;
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    if (loading)
      return CircularProgressIndicator(
        value: null,
        backgroundColor: Colors.green,
      );
    else // AppLocalizations.of(context).settings
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
              body: TabBarView(controller: _tabController, children: [
                RefreshIndicator(
                  onRefresh: refreshTriggered,
                  child: new Container(
                      child: new ListView.builder(
                          itemCount: checkBoxListTileModelFruits.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              color: checkBoxListTileModelFruits[index].isCheck
                                  ? Colors.green
                                  : Colors.grey,
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new SwitchListTile(
                                        activeColor: Colors.black,
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          checkBoxListTileModelFruits[index]
                                              .title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value:
                                            checkBoxListTileModelFruits[index]
                                                .isCheck,
                                        secondary:
                                            checkBoxListTileModelFruits[index]
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
                                                            "${checkBoxListTileModelFruits[index].img}",
                                                            imageRenderMethodForWeb:
                                                                ImageRenderMethodForWeb
                                                                    .HttpGet)),
                                                  ),
                                        onChanged: (bool val) {
                                          itemChangeFruits(val, index);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                RefreshIndicator(
                  onRefresh: refreshTriggered,
                  child: new Container(
                      child: new ListView.builder(
                          itemCount: checkBoxListTileModelVegetables.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              color:
                                  checkBoxListTileModelVegetables[index].isCheck
                                      ? Colors.green
                                      : Colors.grey,
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new SwitchListTile(
                                        activeColor: Colors.black,
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          checkBoxListTileModelVegetables[index]
                                              .title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value: checkBoxListTileModelVegetables[
                                                index]
                                            .isCheck,
                                        secondary:
                                            checkBoxListTileModelVegetables[
                                                        index]
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
                                                            "${checkBoxListTileModelVegetables[index].img}",
                                                            imageRenderMethodForWeb:
                                                                ImageRenderMethodForWeb
                                                                    .HttpGet)),
                                                  ),
                                        onChanged: (bool val) {
                                          itemChangeVegetables(val, index);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                RefreshIndicator(
                  onRefresh: refreshTriggered,
                  child: new Container(
                      child: new ListView.builder(
                          itemCount: checkBoxListTileModelSpices.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              color: checkBoxListTileModelSpices[index].isCheck
                                  ? Colors.green
                                  : Colors.grey,
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new SwitchListTile(
                                        activeColor: Colors.black,
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          checkBoxListTileModelSpices[index]
                                              .title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value:
                                            checkBoxListTileModelSpices[index]
                                                .isCheck,
                                        secondary:
                                            checkBoxListTileModelSpices[index]
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
                                                            "${checkBoxListTileModelSpices[index].img}",
                                                            imageRenderMethodForWeb:
                                                                ImageRenderMethodForWeb
                                                                    .HttpGet)),
                                                  ),
                                        onChanged: (bool val) {
                                          itemChangeSpices(val, index);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                RefreshIndicator(
                  onRefresh: refreshTriggered,
                  child: new Container(
                      child: new ListView.builder(
                          itemCount: checkBoxListTileModelPantry.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              color: checkBoxListTileModelPantry[index].isCheck
                                  ? Colors.green
                                  : Colors.grey,
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new SwitchListTile(
                                        activeColor: Colors.black,
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          checkBoxListTileModelPantry[index]
                                              .title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value:
                                            checkBoxListTileModelPantry[index]
                                                .isCheck,
                                        secondary:
                                            checkBoxListTileModelPantry[index]
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
                                                            "${checkBoxListTileModelPantry[index].img}",
                                                            imageRenderMethodForWeb:
                                                                ImageRenderMethodForWeb
                                                                    .HttpGet)),
                                                  ),
                                        onChanged: (bool val) {
                                          itemChangePantry(val, index);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                RefreshIndicator(
                  onRefresh: refreshTriggered,
                  child: new Container(
                      child: new ListView.builder(
                          itemCount: checkBoxListTileModelDairy.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              color: checkBoxListTileModelDairy[index].isCheck
                                  ? Colors.green
                                  : Colors.grey,
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new SwitchListTile(
                                        activeColor: Colors.black,
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          checkBoxListTileModelDairy[index]
                                              .title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value: checkBoxListTileModelDairy[index]
                                            .isCheck,
                                        secondary:
                                            checkBoxListTileModelDairy[index]
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
                                                            "${checkBoxListTileModelDairy[index].img}",
                                                            imageRenderMethodForWeb:
                                                                ImageRenderMethodForWeb
                                                                    .HttpGet)),
                                                  ),
                                        onChanged: (bool val) {
                                          itemChangeDairy(val, index);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                RefreshIndicator(
                  onRefresh: refreshTriggered,
                  child: new Container(
                      child: new ListView.builder(
                          itemCount: checkBoxListTileModelMeat.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              color: checkBoxListTileModelMeat[index].isCheck
                                  ? Colors.green
                                  : Colors.grey,
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new SwitchListTile(
                                        activeColor: Colors.black,
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          checkBoxListTileModelMeat[index]
                                              .title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value: checkBoxListTileModelMeat[index]
                                            .isCheck,
                                        secondary:
                                            checkBoxListTileModelMeat[index]
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
                                                            "${checkBoxListTileModelMeat[index].img}",
                                                            imageRenderMethodForWeb:
                                                                ImageRenderMethodForWeb
                                                                    .HttpGet)),
                                                  ),
                                        onChanged: (bool val) {
                                          itemChangeMeat(val, index);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
                RefreshIndicator(
                  onRefresh: refreshTriggered,
                  child: new Container(
                      child: new ListView.builder(
                          itemCount: checkBoxListTileModelFish.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              color: checkBoxListTileModelFish[index].isCheck
                                  ? Colors.green
                                  : Colors.grey,
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new SwitchListTile(
                                        activeColor: Colors.black,
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          checkBoxListTileModelFish[index]
                                              .title,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value: checkBoxListTileModelFish[index]
                                            .isCheck,
                                        secondary:
                                            checkBoxListTileModelFish[index]
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
                                                            "${checkBoxListTileModelFish[index].img}",
                                                            imageRenderMethodForWeb:
                                                                ImageRenderMethodForWeb
                                                                    .HttpGet)),
                                                  ),
                                        onChanged: (bool val) {
                                          itemChangeFish(val, index);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          })),
                )
              ])));
  }

  Future<void> refreshTriggered() async {
    print("refresh triggered");
    return loadFoodProducts();
  }

  void loadFoodProducts() async {
    loading = true;
    try {
      ownedGroceries =
          await UserFoodProductController.getUserFoodProducts(false);
      missingGroceries =
          await UserFoodProductController.getUserFoodProducts(true);
    } catch (err) {
      print(err);
      loading = false;
    }
    apiToken = await TokenStore().getToken();
    groceries = getGroceries();
    setState(() {
      this.checkBoxListTileModel = groceries;
      this.checkBoxListTileModelFruits = groceries
          .where((element) => element.foodCategory.name.contains("fruits"))
          .toList();
      this.checkBoxListTileModelVegetables = groceries
          .where((element) => element.foodCategory.name.contains("vegetables"))
          .toList();
      this.checkBoxListTileModelSpices = groceries
          .where((element) => element.foodCategory.name.contains("spices"))
          .toList();
      this.checkBoxListTileModelPantry = groceries
          .where((element) => element.foodCategory.name.contains("pantry"))
          .toList();
      this.checkBoxListTileModelDairy = groceries
          .where((element) => element.foodCategory.name.contains("dairy"))
          .toList();
      this.checkBoxListTileModelMeat = groceries
          .where((element) => element.foodCategory.name.contains("meat"))
          .toList();
      this.checkBoxListTileModelFish = groceries
          .where((element) => element.foodCategory.name.contains("fish"))
          .toList();
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
            title: grocery.name,
            isLoading: false))
        .toList();
    groceryListTiles.addAll(this
        .missingGroceries
        .map((grocery) => GroceryCheckBoxListTileModel(
            groceryId: grocery.foodProductId,
            foodCategory: grocery.foodCategory,
            img: grocery.imgSrc,
            isCheck: false,
            title: grocery.name,
            isLoading: false))
        .toList());
    return groceryListTiles;
  }

  @override
  void initState() {
    super.initState();
    loadFoodProducts();
    _tabController = new TabController(length: 7, vsync: this);
  }

  void itemChangeFruits(bool val, int index) {
    var tileModel = checkBoxListTileModelFruits[index];
    setState(() {
      tileModel.isLoading = true;
    });
    UserFoodProductController.toogleUserFoodProduct(tileModel.groceryId, val)
        .then((value) => setState(() {
              tileModel.isCheck = val;
              tileModel.isLoading = false;
            }));
  }

  void itemChangeVegetables(bool val, int index) {
    var tileModel = checkBoxListTileModelVegetables[index];
    setState(() {
      tileModel.isLoading = true;
    });
    UserFoodProductController.toogleUserFoodProduct(tileModel.groceryId, val)
        .then((value) => setState(() {
              tileModel.isCheck = val;
              tileModel.isLoading = false;
            }));
  }

  void itemChangeSpices(bool val, int index) {
    var tileModel = checkBoxListTileModelSpices[index];
    setState(() {
      tileModel.isLoading = true;
    });
    UserFoodProductController.toogleUserFoodProduct(tileModel.groceryId, val)
        .then((value) => setState(() {
              tileModel.isCheck = val;
              tileModel.isLoading = false;
            }));
  }

  void itemChangePantry(bool val, int index) {
    var tileModel = checkBoxListTileModelPantry[index];
    setState(() {
      tileModel.isLoading = true;
    });
    UserFoodProductController.toogleUserFoodProduct(tileModel.groceryId, val)
        .then((value) => setState(() {
              tileModel.isCheck = val;
              tileModel.isLoading = false;
            }));
  }

  void itemChangeDairy(bool val, int index) {
    var tileModel = checkBoxListTileModelDairy[index];
    setState(() {
      tileModel.isLoading = true;
    });
    UserFoodProductController.toogleUserFoodProduct(tileModel.groceryId, val)
        .then((value) => setState(() {
              tileModel.isCheck = val;
              tileModel.isLoading = false;
            }));
  }

  void itemChangeMeat(bool val, int index) {
    var tileModel = checkBoxListTileModelMeat[index];
    setState(() {
      tileModel.isLoading = true;
    });
    UserFoodProductController.toogleUserFoodProduct(tileModel.groceryId, val)
        .then((value) => setState(() {
              tileModel.isCheck = val;
              tileModel.isLoading = false;
            }));
  }

  void itemChangeFish(bool val, int index) {
    var tileModel = checkBoxListTileModelFish[index];
    setState(() {
      tileModel.isLoading = true;
    });
    UserFoodProductController.toogleUserFoodProduct(tileModel.groceryId, val)
        .then((value) => setState(() {
              tileModel.isCheck = val;
              tileModel.isLoading = false;
            }));
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
}

class GroceryCheckBoxListTileModel {
  int groceryId;
  FoodCategory foodCategory;
  String img;
  String title;
  bool isCheck;
  bool isLoading;

  GroceryCheckBoxListTileModel(
      {this.groceryId,
      this.foodCategory,
      this.img,
      this.title,
      this.isCheck,
      this.isLoading});
}