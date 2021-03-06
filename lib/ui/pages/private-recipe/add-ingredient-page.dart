import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/caching/foodproduct_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/request-ingredient-dialog.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'edit-ingredients-amount-page.dart';

class AddIngredientPage extends StatefulWidget {
  PrivateRecipe privateRecipe;

  AddIngredientPage({Key key, this.privateRecipe}) : super(key: key);

  @override
  _AddIngredientPageState createState() =>
      _AddIngredientPageState(privateRecipe);
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  String searchString = "";
  FoodProductService foodProductService = FoodProductService();
  Future<List<FoodProduct>> foodProducts;
  String apiToken;
  List<FoodProduct> foodProductsAdded = [];

  PrivateRecipe privateRecipe;

  _AddIngredientPageState(this.privateRecipe);

  void initState() {
    super.initState();
    loadToken();
    foodProducts = loadFoodProductsAndDeleteAlreadyAddedOnes();
    setState(() {});
  }

  Future<List<FoodProduct>> loadFoodProductsAndDeleteAlreadyAddedOnes(
      {reload = false}) async {
    return foodProductService.getFoodProducts(reload: reload).then((foodProds) {
      privateRecipe.ingredients.forEach((ingredient) {
        FoodProduct alreadyAddedFoodProduct = foodProds
            .firstWhere((foodProd) => foodProd.id == ingredient.foodProductId);
        foodProds.remove(alreadyAddedFoodProduct);
      });
      return foodProds;
    });
  }

  Future refreshTriggered() async {
    setState(() {
      foodProducts = loadFoodProductsAndDeleteAlreadyAddedOnes(reload: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).addIngredient,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
        ),
        body: RefreshIndicator(
            onRefresh: refreshTriggered,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchString = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).searchIngredient,
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder(
                    builder:
                        (context, AsyncSnapshot<List<FoodProduct>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data
                            .where((foodProduct) => foodProduct.name
                                .toLowerCase()
                                .contains(searchString))
                            .isEmpty)
                          return Center(
                              child: Card(
                                  elevation: 10,
                                  child: Container(
                                      height: 100,
                                      margin: EdgeInsets.all(10),
                                      child: Column(children: [
                                        Text(
                                            AppLocalizations.of(context)
                                                .ingredientNotFoundQuestionMark,
                                            style: TextStyle(fontSize: 20)),
                                        Text(AppLocalizations.of(context)
                                            .sendProposalToAddIt),
                                        ElevatedButton(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .requestIngredient,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal),
                                          onPressed: () => {
                                            showRequestIngredientDialog(searchString)
                                          },
                                        )
                                      ]))));
                        else
                          return Center(
                              child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return snapshot.data[index].name
                                      .toLowerCase()
                                      .contains(searchString)
                                  ? CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      secondary: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                "${snapshot.data[index].imgSrc}",
                                                headers: {
                                                  "Authorization":
                                                      "Bearer $apiToken",
                                                  "Access-Control-Allow-Headers":
                                                      "Access-Control-Allow-Origin, Accept"
                                                },
                                                imageRenderMethodForWeb:
                                                    ImageRenderMethodForWeb
                                                        .HttpGet),
                                        radius: 30,
                                      ),
                                      title:
                                          Text('${snapshot.data[index].name}'),
                                      subtitle: Text(
                                          '${AppLocalizations.of(context).foodCategory}: '
                                          '${Utility.getTranslatedFoodCategory(context, snapshot.data[index].foodCategory)}'),
                                      value: foodProductsAdded
                                          .contains(snapshot.data[index]),
                                      onChanged: (bool value) {
                                        if (value)
                                          setState(() {
                                            foodProductsAdded
                                                .add(snapshot.data[index]);
                                          });
                                        else {
                                          setState(() {
                                            foodProductsAdded
                                                .remove(snapshot.data[index]);
                                          });
                                        }
                                      },
                                    )
                                  : Container();
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return snapshot.data[index].name
                                      .toLowerCase()
                                      .contains(searchString)
                                  ? Divider()
                                  : Container();
                            },
                          ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong :('));
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                    future: foodProducts,
                    // Our existing list code
                  ),
                ),
                showContinueButtonIfSelected()
              ],
            )));
  }

  void loadToken() async {
    apiToken = await TokenStore().getToken();
  }

  Widget showContinueButtonIfSelected() {
    if (foodProductsAdded.isNotEmpty) {
      return Card(
          //  height: 100,
          color: Colors.white,
          elevation: 25,
          child: Center(
              child: ElevatedButton(
                  child: Text(AppLocalizations.of(context).okay, style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    addIngredientsAndNavigateToEditAmounts(foodProductsAdded);
                  })));
    } else
      return Container();
  }

  Future<void> addIngredientsAndNavigateToEditAmounts(
      List<FoodProduct> foodProducts) async {
    print('leave add ingredients');
    List<Ingredient> ingredients = foodProducts
        .map((foodProduct) => Ingredient(
            id: 0,
            name: foodProduct.name,
            quantityType: foodProduct.quantityType,
            imgSrc: foodProduct.imgSrc,
            foodProductId: foodProduct.id,
            recipeId: privateRecipe.id,
            amount: 0))
        .toList();
    privateRecipe.ingredients.addAll(ingredients);
    privateRecipe = await RecipeController.updatePrivateRecipe(privateRecipe);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditIngredientsAmountPage(
                privateRecipe: privateRecipe, routedFromAddIngredient: true)));
  }

  showRequestIngredientDialog(String ingredientName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return new RequestIngredientDialog(ingredientName: ingredientName);
    });
  }
}
