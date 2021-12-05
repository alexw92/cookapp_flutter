import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/ingredient-tile.component.dart';
import 'package:cookable_flutter/ui/components/nutrient-tile.component.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivateRecipeDetailsPage extends StatefulWidget {
  final int recipeId;

  PrivateRecipeDetailsPage(this.recipeId, {Key key}) : super(key: key);

  @override
  _PrivateRecipeDetailsPageState createState() =>
      _PrivateRecipeDetailsPageState();
}

class _PrivateRecipeDetailsPageState extends State<PrivateRecipeDetailsPage> {
  PrivateRecipe recipe;
  String apiToken;
  int dailyCalories;
  double dailyCarbohydrate;
  double dailyProtein;
  double dailyFat;
  int numberOfPersonsTmp;
  List<Ingredient> ingredientsTmp;

  _PrivateRecipeDetailsPageState();

  void loadRecipe() async {
    apiToken = await TokenStore().getToken();
    var prefs = await SharedPreferences.getInstance();
    dailyCalories = prefs.getInt('dailyCalories');
    dailyCarbohydrate = prefs.getDouble('dailyCarbohydrate');
    dailyProtein = prefs.getDouble('dailyProtein');
    dailyFat = prefs.getDouble('dailyFat');
    this.recipe = await RecipeController.getPrivateRecipe(this.widget.recipeId);
    var ingredientsCopy = copyIngredients(recipe.ingredients);
    setState(() {
      numberOfPersonsTmp = recipe.numberOfPersons;
      ingredientsTmp = ingredientsCopy;
    });
  }

  // Todo fix bug: scale pieces to 0.5 0.25 etc -> fractions, check android proj
  void increaseNumberOfPersons() {
    if (numberOfPersonsTmp == 20) return;
    setState(() {
      numberOfPersonsTmp = numberOfPersonsTmp + 1;
      for (int i = 0; i < recipe.ingredients.length; i++) {
        var ingredient = recipe.ingredients[i];
        var ingredientCpy = ingredientsTmp[i];
        ingredientCpy.amount =
            ((ingredient.amount / recipe.numberOfPersons) * numberOfPersonsTmp);
      }
    });
  }

  void decreaseNumberOfPersons() {
    if (numberOfPersonsTmp == 1) return;
    setState(() {
      numberOfPersonsTmp = numberOfPersonsTmp - 1;
      for (int i = 0; i < recipe.ingredients.length; i++) {
        var ingredient = recipe.ingredients[i];
        var ingredientCpy = ingredientsTmp[i];
        ingredientCpy.amount =
            ((ingredient.amount / recipe.numberOfPersons) * numberOfPersonsTmp);
      }
    });
  }

  List<Ingredient> copyIngredients(List<Ingredient> ingredients) {
    List<Ingredient> ingredientCopy = [];
    for (int i = 0; i < ingredients.length; i++) {
      var ingredient = ingredients[i];
      ingredientCopy.add(ingredient.clone());
    }
    return ingredientCopy;
  }

  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return recipe == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [CircularProgressIndicator()])
              ])
        : Scaffold(
            body: SafeArea(
            child: Container(
                height: double.infinity,
                color: Colors.black,
                child: SingleChildScrollView(
                    //  padding: EdgeInsets.only(bottom: 15),
                    child: Column(children: [
                  Stack(children: [
                    Container(
                        height: 400,
                        color: Colors.grey,
                        width: double.infinity,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image(
                              // needs --web-renderer html
                              image: CachedNetworkImageProvider(recipe.imgSrc,
                                  imageRenderMethodForWeb:
                                      ImageRenderMethodForWeb.HttpGet),
                              // backgroundColor: Colors.transparent,
                              //  radius: 40,
                            ))),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Text(this.recipe.name,
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          textAlign: TextAlign.center),
                    )
                  ]),
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Chip(
                                labelPadding: EdgeInsets.all(4.0),
                                avatar: Icon(Icons.access_time),
                                label: Text(
                                  "${recipe.prepTimeMinutes} min",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.white,
                                elevation: 6.0,
                                shadowColor: Colors.grey[60],
                                padding: EdgeInsets.all(8.0),
                              ),
                              Chip(
                                labelPadding: EdgeInsets.all(4.0),
                                avatar: Utility.getIconForDiet(recipe.diet),
                                label: Text(
                                  Utility.getTranslatedDiet(
                                      context, recipe.diet),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.white,
                                elevation: 6.0,
                                shadowColor: Colors.grey[60],
                                padding: EdgeInsets.all(8.0),
                              ),
                              Chip(
                                labelPadding: EdgeInsets.all(4.0),
                                avatar: Icon(Icons.group),
                                label: Text(
                                  recipe.numberOfPersons.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.white,
                                elevation: 6.0,
                                shadowColor: Colors.grey[60],
                                padding: EdgeInsets.all(8.0),
                              )
                            ]),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: Column(children: [
                      Text(
                        AppLocalizations.of(context).ingredients,
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      getIngredientScalerIfNotEmpty(),
                      SizedBox(
                        height: 5,
                      ),
                      showIngredientsIfNotEmpty()
                    ]),
                  ),
                  Container(
                      color: Colors.black,
                      width: double.infinity,
                      child: Column(children: [
                        Text(
                          AppLocalizations.of(context).nutrients,
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 0, right: 0),
                            child: new GridView.count(
                              //     primary: true,
                              //    padding: const EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 4,
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 0,
                              children: [
                                ...getNutrientTiles()
                                //
                              ],
                            ))
                      ])),
                  Container(
                      color: Colors.black,
                      width: double.infinity,
                      child: Column(children: [
                        Text(
                          AppLocalizations.of(context).howToCook,
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                        showInstructionsIfNotEmpty()
                      ])),
                ]))),
          ));
  }

  List<Widget> getAllIngredientTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < ingredientsTmp.length; i++) {
      myTiles.add(
        IngredientTileComponent(
            ingredient: ingredientsTmp[i], apiToken: apiToken),
      );
    }
    return myTiles;
  }

  List<Widget> getNutrientTiles() {
    List<Widget> myTiles = [];
    myTiles.addAll([
      NutrientTileComponent(
          textColor: Colors.white,
          nutrientName: AppLocalizations.of(context).calories,
          nutrientAmount: recipe.nutrients.calories.toDouble(),
          dailyRecAmount: dailyCalories.toDouble(),
          nutritionType: NutritionType.CALORIES),
      NutrientTileComponent(
          textColor: Colors.white,
          nutrientName: AppLocalizations.of(context).fat,
          nutrientAmount: recipe.nutrients.fat,
          dailyRecAmount: dailyFat,
          nutritionType: NutritionType.FAT),
      NutrientTileComponent(
          textColor: Colors.white,
          nutrientName: AppLocalizations.of(context).carbs,
          nutrientAmount: recipe.nutrients.carbohydrate,
          dailyRecAmount: dailyCarbohydrate,
          nutritionType: NutritionType.CARBOHYDRATE),
      NutrientTileComponent(
          textColor: Colors.white,
          nutrientName: AppLocalizations.of(context).protein,
          nutrientAmount: recipe.nutrients.protein,
          dailyRecAmount: dailyProtein,
          nutritionType: NutritionType.PROTEIN)
    ]);

    return myTiles;
  }

  Widget showIngredientsIfNotEmpty() {
    if (recipe.ingredients.length != 0)
      return Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: new GridView.count(
            //     primary: true,
            //    padding: const EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            padding: EdgeInsets.only(left: 10, right: 10),
            crossAxisSpacing: 10,
            children: [
              ...getAllIngredientTiles()
              //
            ],
          ));
    else
      return Text(
        AppLocalizations.of(context).emptyIngredients,
        style: TextStyle(color: Colors.white),
      );
  }

  Widget showInstructionsIfNotEmpty() {
    if (recipe.instructions.length != 0)
      return Container(
          margin: const EdgeInsets.only(left: 0, right: 0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recipe.instructions.length,
              itemBuilder: (context, index) {
                final instruction = recipe.instructions[index];
                return Container(
                    child: Card(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${AppLocalizations.of(context).recipeInstructionStepShort} " +
                            instruction.step.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(instruction.instructionsText)
                    ],
                  ),
                ));
              }));
    else
      return Text(
        AppLocalizations.of(context).emptyInstructions,
        style: TextStyle(color: Colors.white),
      );
  }

  Widget getIngredientScalerIfNotEmpty() {
    if (this.recipe.ingredients.isEmpty) return Container();
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          decreaseNumberOfPersons();
        },
        child: Icon(Icons.remove, size:32),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
          backgroundColor:
              MaterialStateProperty.all(Colors.white), // <-- Button color
        ),
      ),
      SizedBox(width: 10),
      CircleAvatar(
        radius: 30,
        child: Text(numberOfPersonsTmp.toString(),
            style: TextStyle(fontSize: 30, color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          increaseNumberOfPersons();
        },
        child: Icon(Icons.add, size:32),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
          backgroundColor:
              MaterialStateProperty.all(Colors.white), // <-- Button color
        ),
      )
    ]);
  }
}
