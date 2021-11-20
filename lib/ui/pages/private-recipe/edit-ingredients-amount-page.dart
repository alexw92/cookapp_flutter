import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditIngredientsAmountPage extends StatefulWidget {
  EditIngredientsAmountPage({Key key, this.ingredients}) : super(key: key);

  List<Ingredient> ingredients;

  @override
  _EditIngredientsAmountPageState createState() =>
      _EditIngredientsAmountPageState(ingredients);
}

class _EditIngredientsAmountPageState extends State<EditIngredientsAmountPage> {
  final List<Ingredient> ingredients;
  String apiToken;
  List<FoodProduct> foodProductsAdded = [];
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  _EditIngredientsAmountPageState(this.ingredients);

  void initState() {
    super.initState();
    loadToken();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).ingredients)),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Flexible(
              child: (ingredients.length != 0)
                  ? Center(
                      child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: ingredients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getIngredientAmountTile(index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ))
                  : (ingredients.length == 0)
                      ? Center(child: Text('Something went wrong :('))
                      : Center(child: CircularProgressIndicator()),
              // Our existing list code
            ),
            showIngredientUIIfSelected()
          ],
        ));
  }

  void loadToken() async {
    apiToken = await TokenStore().getToken();
  }

  Widget getIngredientAmountTile(int index) {
    return Card(
        elevation: 10,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider("${ingredients[index].imgSrc}",
                    headers: {
                      "Authorization": "Bearer $apiToken",
                      "Access-Control-Allow-Headers":
                          "Access-Control-Allow-Origin, Accept"
                    },
                    imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
            radius: 38,
          ),
          Column(
            children: [
              Text(ingredients[index].name, style: TextStyle(fontSize: 26)),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => decreaseAmount(ingredients[index]),
                    child: Icon(Icons.remove),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.all(8)), // <-- Button color,
                    ),
                  ),
                  SizedBox(
                      width: 100,
                      child: TextFormField(
                        key: Key(ingredients[index].amount.toString()),
                        textAlign: TextAlign.center,
                        initialValue: ingredients[index].amount.toString(),
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText:
                                '${AppLocalizations.of(context).amount} (${ingredients[index].quantityType.toString()})',
                            suffixText:
                                ingredients[index].quantityType.toString(),
                            errorMaxLines: 1),
                        maxLength: 5,
                        maxLines: 1,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                      )),
                  ElevatedButton(
                    onPressed: () => increaseAmount(ingredients[index]),
                    child: Icon(Icons.add),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.all(8)), // <-- Button color,
                    ),
                  )
                ],
              )
            ],
          )
        ]));
  }

  Widget showIngredientUIIfSelected() {
    if (foodProductsAdded.isNotEmpty) {
      var foodProduct = foodProductsAdded.first;
      return Form(
          key: _formKey,
          child: Card(
              //  height: 100,
              color: Colors.white,
              elevation: 25,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(width: 20),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      "${foodProduct.imgSrc}",
                      headers: {
                        "Authorization": "Bearer $apiToken",
                        "Access-Control-Allow-Headers":
                            "Access-Control-Allow-Origin, Accept"
                      },
                      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
                  radius: 40,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      foodProduct.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: amountController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText:
                                  '${AppLocalizations.of(context).amount} (${foodProduct.quantityType.toString()})',
                              suffixText: foodProduct.quantityType.toString(),
                              errorMaxLines: 1),
                          maxLength: 6,
                          maxLines: 1,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          // inputFormatters: <TextInputFormatter>[
                          //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          // ],
                          validator: (v) {
                            if (num.tryParse(v) == null) {
                              return AppLocalizations.of(context).invalidAmount;
                            } else {
                              return null;
                            }
                          },
                        )),
                  ],
                )),
              ])));
    } else
      return Container();
  }

  void decreaseAmount(Ingredient ingredient) {
    if (ingredient.quantityType.value ==
        QuantityUnit.PIECES) if (ingredient.amount >= 1)
      setState(() {
        ingredient.amount = ingredient.amount - 1;
      });
    else
      setState(() {
        ingredient.amount = 0;
      });
    else if (ingredient.amount >= 10)
      setState(() {
        ingredient.amount = ingredient.amount - 10;
      });
    else
      setState(() {
        ingredient.amount = 0;
      });
  }

  void increaseAmount(Ingredient ingredient) {
    if (ingredient.quantityType.value == QuantityUnit.PIECES)
      setState(() {
        ingredient.amount = ingredient.amount + 1;
      });
    else
      setState(() {
        ingredient.amount = ingredient.amount + 10;
      });
  }

  void addIngredientAndNavigateBack(FoodProduct foodProduct, int amount) {
    print('leave add ingredient');
    Ingredient ingredient = Ingredient(
        id: 0,
        name: foodProduct.name,
        quantityType: foodProduct.quantityType,
        imgSrc: foodProduct.imgSrc,
        foodProductId: foodProduct.id,
        recipeId: 0,
        amount: amount);
    Navigator.pop(context, ingredient);
  }
}
