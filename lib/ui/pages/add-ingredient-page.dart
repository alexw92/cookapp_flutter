import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddIngredientPage extends StatefulWidget {
  AddIngredientPage({Key key}) : super(key: key);

  @override
  _AddIngredientPageState createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  String searchString = "";
  Future<List<FoodProduct>> foodProducts;
  String apiToken;
  List<FoodProduct> foodProductsAdded = [];
  int ingredientAmount;
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  _AddIngredientPageState();

  void initState() {
    super.initState();
    loadToken();
    foodProducts = FoodProductController.getFoodProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).addIngredient)),
        body: Column(
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
                builder: (context, AsyncSnapshot<List<FoodProduct>> snapshot) {
                  if (snapshot.hasData) {
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
                                  backgroundImage: CachedNetworkImageProvider(
                                      "${snapshot.data[index].imgSrc}",
                                      headers: {
                                        "Authorization": "Bearer $apiToken",
                                        "Access-Control-Allow-Headers":
                                            "Access-Control-Allow-Origin, Accept"
                                      },
                                      imageRenderMethodForWeb:
                                          ImageRenderMethodForWeb.HttpGet),
                                  radius: 30,
                                ),
                                title: Text('${snapshot.data[index].name}'),
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
                      separatorBuilder: (BuildContext context, int index) {
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
            showIngredientUIIfSelected()
          ],
        ));
  }

  void loadToken() async {
    apiToken = await TokenStore().getToken();
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
                    Text(foodProduct.name, style: TextStyle(fontSize: 20)),
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
                               if(num.tryParse(v) == null){
                                 return AppLocalizations.of(context).invalidAmount;
                               }
                              else {
                                return null;}
                              },
                        )),
                  ],
                )),
                Column(children: [
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context).okay),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        ingredientAmount = num.parse(amountController.value.text);
                        print("added "+ingredientAmount.toString()+" " + foodProduct.name);
                        addIngredientAndNavigateBack(foodProduct, ingredientAmount);
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context).cancel),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      setState(() {
                        foodProductsAdded.clear();
                      });
                    },
                  )
                ])
              ])));
    } else
      return Container();
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
      amount: amount
    );
    Navigator.pop(context, ingredient);
  }
}
