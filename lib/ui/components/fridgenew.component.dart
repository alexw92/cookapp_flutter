import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    else
      return Scaffold(
          appBar: AppBar(
            toolbarHeight: 52,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Fruits"),
                Tab(text: "Vegetables"),
                Tab(text: "Spices")
              ],
            ),
          ),
          body: TabBarView(
              controller: _tabController,
              children: [
                new Container(
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
                                      checkBoxListTileModelFruits[index].title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5),
                                    ),
                                    value: checkBoxListTileModelFruits[index].isCheck,
                                    secondary:
                                    checkBoxListTileModelFruits[index].isLoading
                                        ? CircularProgressIndicator(
                                      value: null,
                                      backgroundColor: Colors.orange,
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
                      }),
                ),
                new Container(
                  child: new ListView.builder(
                      itemCount: checkBoxListTileModelVegetables.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                          color: checkBoxListTileModelVegetables[index].isCheck
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
                                      checkBoxListTileModelVegetables[index].title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5),
                                    ),
                                    value: checkBoxListTileModelVegetables[index].isCheck,
                                    secondary:
                                    checkBoxListTileModelVegetables[index].isLoading
                                        ? CircularProgressIndicator(
                                      value: null,
                                      backgroundColor: Colors.orange,
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
                      }),
                ),
            new Container(
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
                                  checkBoxListTileModelSpices[index].title,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5),
                                ),
                                value: checkBoxListTileModelSpices[index].isCheck,
                                secondary:
                                checkBoxListTileModelSpices[index].isLoading
                                        ? CircularProgressIndicator(
                                            value: null,
                                            backgroundColor: Colors.orange,
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
                  }),
            )
          ]));
  }

  void loadFoodProducts() async {
    loading = true;
    try {
      ownedGroceries =
          await UserFoodProductController.getUserFoodProducts(false);
      missingGroceries =
          await UserFoodProductController.getUserFoodProducts(true);
    } catch (err) {
      loading = false;
    }
    apiToken = await TokenStore().getToken();
    groceries = getGroceries();
    setState(() {
      this.checkBoxListTileModel = groceries;
      print(groceries);
      this.checkBoxListTileModelFruits = groceries.where((element) => element.foodCategory.name.contains("fruits")).toList();
      this.checkBoxListTileModelVegetables = groceries.where((element) => element.foodCategory.name.contains("vegetables")).toList();
      this.checkBoxListTileModelSpices = groceries.where((element) => element.foodCategory.name.contains("spices")).toList();
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
    _tabController = new TabController(length: 3, vsync: this);
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
}

class GroceryCheckBoxListTileModel {
  int groceryId;
  FoodCategory foodCategory;
  String img;
  String title;
  bool isCheck;
  bool isLoading;

  GroceryCheckBoxListTileModel(
      {this.groceryId, this.foodCategory, this.img, this.title, this.isCheck, this.isLoading});
}
