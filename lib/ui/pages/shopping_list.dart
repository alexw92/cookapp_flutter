import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:cookable_flutter/core/caching/userfood_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
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
  final animatedListKey = GlobalKey<AnimatedListState>();
  bool busy = false;

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
          backgroundColor: Colors.black87,
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
              child: Container(
                  color: Colors.black87,
                  child: tiles.isNotEmpty
                      ? Column(children: [
                          Flexible(
                              child: AnimatedList(
                                  key: animatedListKey,
                                  initialItemCount: tiles.length,
                                  itemBuilder: (BuildContext context, int index,
                                      animation) {
                                    return buildAnimatedTile(
                                        tiles[index], animation);
                                  })),
                          tiles.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10, top: 10, left: 20, right: 20),
                                  child: Card(
                                      elevation: 20,
                                      child: Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .clearList),
                                                onPressed: _clearList),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ElevatedButton(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .orderGroceries),
                                              onPressed: () =>
                                                  {print("Order groceries")},
                                            )
                                          ])))
                              : Container()
                        ])
                      : Center(
                          child: Container(
                              color: Colors.black87,
                              child: Card(
                                  elevation: 20,
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Wrap(children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .prettyEmptyHere,
                                          style: TextStyle(fontSize: 26),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                              .itemsAddedToShoppingListAreHere,
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ]))))))));
    else
      return Scaffold(
          backgroundColor: Colors.black87,
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
          (await userFoodService.getUserFood(true, reload: reload)).toList();
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
        .where((element) => element.onShoppingList)
        .toList()
        .map((grocery) => ShoppingListTileModel(
            groceryId: grocery.foodProductId,
            foodCategory: grocery.foodCategory,
            img: grocery.imgSrc,
            title: grocery.name,
            isLoading: false))
        .toList();

    return groceries;
  }

  Future<void> _clearList() {
    return UserFoodProductController.clearShoppingList().then(
        (value) => {
              missingGroceries
                  .forEach((element) => element.onShoppingList = false),
              userFoodService
                  .updateBoxValues(true, missingGroceries)
                  .then((res) {
                Navigator.of(context).pop();
                setState(() {});
              }),
            },
        onError: (err) => {
              setState(() {
                this.loading = false;
                this.error = true;
              })
            });
  }

  _removeFromShoppingList(int groceryId, int index, bool addToOwned) async {
    try {
      if(busy)
        return;
      setState(() {
        busy = true;
      });
      if (addToOwned) {
        print("Add $groceryId to owned groceries");
        await UserFoodProductController.toggleUserFoodProduct(
            groceryId, true, null);
        var ownedGroceries = await userFoodService.getUserFood(false);
        var item = this
            .missingGroceries
            .firstWhereOrNull((element) => element.foodProductId == groceryId);
        missingGroceries.remove(item);
        item.onShoppingList = false;
        ownedGroceries.add(item);
        await userFoodService.updateBoxValues(false, ownedGroceries);
        await userFoodService.updateBoxValues(true, missingGroceries);
      } else {
        print("Remove $groceryId from shopping list");
        await UserFoodProductController.toggleUserFoodProduct(
            groceryId, null, false);
        var item = this
            .missingGroceries
            .firstWhereOrNull((element) => element.foodProductId == groceryId);
        item.onShoppingList = false;
        await userFoodService.updateBoxValues(true, missingGroceries);
      }
      var removedItem = tiles.removeAt(index);
      animatedListKey.currentState.removeItem(
          index,
          (context, animation) =>
              buildAnimatedTile(removedItem, animation, isAdded: addToOwned),
          duration: Duration(milliseconds: 200));
      setState(() {
        busy = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        error = true;
      });
    }
  }

  Widget buildAnimatedTile(ShoppingListTileModel model, animation,
      {bool isAdded: true}) {
    final index =
        tiles.indexWhere((element) => element.groceryId == model.groceryId);
    return SlideTransition(
        position: animation.drive(isAdded
            ? Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
            : Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))),
        child: new Card(
            //color: Colors.grey,
            elevation: 20,
            child: Row(children: [
              new Flexible(
                  child: new ListTile(
                // activeColor: Colors.black,
                dense: true,
                title: new Text(
                  model.title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                leading: model.isLoading
                    ? CircularProgressIndicator(
                        value: null,
                        backgroundColor: Colors.orange,
                      )
                    : Container(
                        height: 50,
                        width: 50,
                        child: Image(
                            image: CachedNetworkImageProvider(model.img,
                                imageRenderMethodForWeb:
                                    ImageRenderMethodForWeb.HttpGet)),
                      ),
                //  onChanged: (bool val) {}),

                trailing: Wrap(direction: Axis.horizontal, children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                      onPressed: () => {
                            _removeFromShoppingList(
                                model.groceryId, index, false)
                          },
                      child: const FaIcon(
                        FontAwesomeIcons.times,
                        size: 26,
                        color: Colors.red,
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                      onPressed: () => {
                            _removeFromShoppingList(
                                model.groceryId, index, true)
                          },
                      child: const FaIcon(
                        FontAwesomeIcons.check,
                        size: 26,
                        color: Colors.green,
                      ))
                ]),
              )),
              // todo should be replaced by margin
              SizedBox(
                height: 60,
              )
            ])));
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
