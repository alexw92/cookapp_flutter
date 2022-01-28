import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/caching/userfood_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShoppingListPage extends StatefulWidget {
  ShoppingListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final UserFoodService userFoodService = UserFoodService();
  bool loading = false;
  bool error = false;
  String apiToken;
  List<ShoppingListTileModel> tiles = [];
  List<UserFoodProduct> missingGroceries = [];

  @override
  void initState() {
    super.initState();
    loadFoodProducts();
  }

  Future<void> refreshTriggered() async {
    print("refresh triggered");
    return loadFoodProducts(reload: true);
  }

  @override
  Widget build(BuildContext context) {
    if (loading && !error)
      return Scaffold(
          appBar:
              AppBar(title: Text(AppLocalizations.of(context).shoppingList)),
          body: Center(
              child: CircularProgressIndicator(
            value: null,
            backgroundColor: Colors.green,
          )));
    else if (!loading && !error)
      return Scaffold(
          appBar:
              AppBar(title: Text(AppLocalizations.of(context).shoppingList)),
          body: RefreshIndicator(
              onRefresh: refreshTriggered,
              child: tiles.isNotEmpty
                  ? ListView.builder(
                      itemCount: tiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                            color: Colors.grey,
                            child: Row(children: [
                              new Flexible(
                                child: new SwitchListTile(
                                    activeColor: Colors.black,
                                    dense: true,
                                    title: new Text(
                                      tiles[index].title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5),
                                    ),
                                    value: true,
                                    secondary: tiles[index].isLoading
                                        ? CircularProgressIndicator(
                                            value: null,
                                            backgroundColor: Colors.orange,
                                          )
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            child: Image(
                                                image: CachedNetworkImageProvider(
                                                    tiles[index].img,
                                                    imageRenderMethodForWeb:
                                                        ImageRenderMethodForWeb
                                                            .HttpGet)),
                                          ),
                                    onChanged: (bool val) {}),
                              ),
                              InkWell(
                                  child: FaIcon(
                                    FontAwesomeIcons.listAlt,
                                    color: Colors.yellow,
                                    size: 36,
                                  ),
                                  onTap: () {}),
                              SizedBox(
                                width: 10,
                                height: 60,
                              )
                            ]));
                      })
                  : Center(
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Wrap(children: [
                                Text(
                                  AppLocalizations.of(context).prettyEmptyHere,
                                  style: TextStyle(fontSize: 26),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .itemsAddedToShoppingListAreHere,
                                  style: TextStyle(fontSize: 16),
                                )
                              ]))))));
    else
      return Scaffold(
          appBar:
              AppBar(title: Text(AppLocalizations.of(context).shoppingList)),
          body: Center(
              child: Container(
            height: 100,
            child: Card(
                elevation: 10,
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

  void loadFoodProducts({reload = false}) async {
    setState(() {
      loading = true;
      error = false;
    });
    try {
      missingGroceries =
          (await userFoodService.getUserFood(true, reload: reload))
              .where((element) => element.onShoppingList)
              .toList();
    } catch (err) {
      print(err);
      setState(() {
        this.loading = false;
        this.error = true;
      });
    }
    apiToken = await TokenStore().getToken();
    tiles = getGroceries();
    setState(() {
      loading = false;
    });
  }

  List<ShoppingListTileModel> getGroceries() {
    var groceries = this
        .missingGroceries
        .map((grocery) => ShoppingListTileModel(
            groceryId: grocery.foodProductId,
            foodCategory: grocery.foodCategory,
            img: grocery.imgSrc,
            title: grocery.name,
            isLoading: false))
        .toList();

    return groceries;
  }
}

class ShoppingListTileModel {
  int groceryId;
  FoodCategory foodCategory;
  String img;
  String title;
  bool isLoading;

  ShoppingListTileModel(
      {this.groceryId,
      this.foodCategory,
      this.img,
      this.title,
      this.isLoading});
}
