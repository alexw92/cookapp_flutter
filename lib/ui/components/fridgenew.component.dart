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

class CheckBoxListTileState extends State<ToggleFridgeWidget> {
  List<GroceryCheckBoxListTileModel> checkBoxListTileModel = [];
  List<UserFoodProduct> ownedGroceries = [];
  List<UserFoodProduct> missingGroceries = [];
  String apiToken;
  bool loading = false;
  List<GroceryCheckBoxListTileModel> groceries;

  @override
  Widget build(BuildContext context) {
    if (loading)
      return CircularProgressIndicator(
        value: null,
        backgroundColor: Colors.green,
      );
    else
      return new Container(
        child: new ListView.builder(
            itemCount: checkBoxListTileModel.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                color: checkBoxListTileModel[index].isCheck
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
                            checkBoxListTileModel[index].title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                          ),
                          value: checkBoxListTileModel[index].isCheck,
                          secondary: checkBoxListTileModel[index].isLoading
                              ? CircularProgressIndicator(
                                  value: null,
                                  backgroundColor: Colors.orange,
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  child: Image(
                                      image: CachedNetworkImageProvider(
                                          "${checkBoxListTileModel[index].img}",
                                          imageRenderMethodForWeb:
                                              ImageRenderMethodForWeb.HttpGet)),
                                ),
                          onChanged: (bool val) {
                            itemChange(val, index);
                          }),
                    ],
                  ),
                ),
              );
            }),
      );
  }

  void loadFoodProducts() async {
    loading = true;
    try {
      ownedGroceries =
      await UserFoodProductController.getUserFoodProducts(false);
      missingGroceries =
      await UserFoodProductController.getUserFoodProducts(true);
    }
    catch(err){
      loading = false;
    }
    apiToken = await TokenStore().getToken();
    groceries = getGroceries();
    setState(() {
      this.checkBoxListTileModel = groceries;
      loading = false;
    });
  }

  List<GroceryCheckBoxListTileModel> getGroceries() {
    var groceryListTiles = this
        .ownedGroceries
        .map((grocery) => GroceryCheckBoxListTileModel(
            groceryId: grocery.foodProductId,
            img: grocery.imgSrc,
            isCheck: true,
            title: grocery.name,
            isLoading: false))
        .toList();
    groceryListTiles.addAll(this
        .missingGroceries
        .map((grocery) => GroceryCheckBoxListTileModel(
            groceryId: grocery.foodProductId,
            img: grocery.imgSrc,
            isCheck: false,
            title: grocery.name,
            isLoading: false))
        .toList());
    return groceryListTiles;
    // for (int i = 0; i < this.groceryList.length; i++) {
    //   myTiles.add(
    //     FridgeTileComponent(
    //         userFoodProduct: userFoodProductList[i],
    //         apiToken: apiToken
    //     ),
    //   );
    // }
    // return <GroceryCheckBoxListTileModel>[
    //
    //   GroceryCheckBoxListTileModel(
    //       groceryId: 1,
    //       img: 'assets/images/android_img.png',
    //       title: "Android",
    //       isCheck: true),
    //   GroceryCheckBoxListTileModel(
    //       groceryId: 2,
    //       img: 'assets/images/flutter.jpeg',
    //       title: "Flutter",
    //       isCheck: false),
    //   GroceryCheckBoxListTileModel(
    //       groceryId: 3,
    //       img: 'assets/images/ios_img.webp',
    //       title: "IOS",
    //       isCheck: false),
    //   GroceryCheckBoxListTileModel(
    //       groceryId: 4,
    //       img: 'assets/images/php_img.png',
    //       title: "PHP",
    //       isCheck: false),
    //   GroceryCheckBoxListTileModel(
    //       groceryId: 5,
    //       img: 'assets/images/node_img.png',
    //       title: "Node",
    //       isCheck: false),
    // ];
  }

  @override
  void initState() {
    super.initState();
    loadFoodProducts();
  }

  void itemChange(bool val, int index) {
    var tileModel = checkBoxListTileModel[index];
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
  String img;
  String title;
  bool isCheck;
  bool isLoading;

  GroceryCheckBoxListTileModel(
      {this.groceryId, this.img, this.title, this.isCheck, this.isLoading});
}
