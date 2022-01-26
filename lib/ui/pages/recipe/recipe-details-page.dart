import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/common/constants.dart';
import 'package:cookable_flutter/core/caching/recipe_service.dart';
import 'package:cookable_flutter/core/caching/userfood_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/ingredient-tile.component.dart';
import 'package:cookable_flutter/ui/components/nutrient-tile.component.dart';
import 'package:cookable_flutter/ui/pages/recipe/recipe-missing-ingredient-dialog.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:like_button/like_button.dart';

class RecipesDetailsPage extends StatefulWidget {
  final int recipeId;

  RecipesDetailsPage(this.recipeId, {Key key}) : super(key: key);

  @override
  _RecipesDetailsPageState createState() => _RecipesDetailsPageState();
}

class _RecipesDetailsPageState extends State<RecipesDetailsPage>
    with SingleTickerProviderStateMixin {
  RecipeDetails recipe;
  RecipeService recipeService = RecipeService();
  UserFoodService userFoodService = UserFoodService();
  List<UserFoodProduct> userOwnedFood;
  List<UserFoodProduct> missingUserFood;
  List<UserFoodProduct> groceriesOnShoppingList;
  DefaultNutrients defaultNutrients;
  String apiToken;
  int dailyCalories;
  double dailyCarbohydrate;
  double dailyProtein;
  double dailyFat;
  int numberOfPersonsTmp;
  Animation<double> animation;
  AnimationController controller;
  List<Ingredient> ingredientsTmp;
  int updateIngredientsKey = 1;

  // internal list to keep ingredient display order after initial sorting
  List<IngredientTileComponent> _myIngredientTiles = [];
  int _toggledGroceryId;
  bool _toggledGroceryNewState;
  bool _toggledGroceryNewStateOnShoppingList = false;

  _RecipesDetailsPageState();

  void loadRecipe() async {
    // recipe = await RecipeController.getRecipe();
    apiToken = await TokenStore().getToken();
    defaultNutrients = await recipeService.getDefaultNutrients();
    dailyCalories = defaultNutrients.recDailyCalories;
    dailyCarbohydrate = defaultNutrients.recDailyCarbohydrate;
    dailyProtein = defaultNutrients.recDailyProtein;
    dailyFat = defaultNutrients.recDailyFat;
    userOwnedFood = await userFoodService.getUserFood(false);
    // this loading is just to initially fill the hive box, can be removed if it was done before already
    missingUserFood = await userFoodService.getUserFood(true);
    groceriesOnShoppingList = [];
    this.recipe = await RecipeController.getRecipe(this.widget.recipeId);
    var ingredientsCopy = copyIngredients(recipe.ingredients);
    setState(() {
      numberOfPersonsTmp = recipe.numberOfPersons;
      ingredientsTmp = ingredientsCopy;
    });
  }

  void increaseNumberOfPersons() {
    if (numberOfPersonsTmp == 20) return;
    setState(() {
      controller.forward();
      numberOfPersonsTmp = numberOfPersonsTmp + 1;
    });
    for (int i = 0; i < recipe.ingredients.length; i++) {
      var ingredient = recipe.ingredients[i];
      var ingredientCpy = ingredientsTmp[i];
      ingredientCpy.amount =
          ((ingredient.amount / recipe.numberOfPersons) * numberOfPersonsTmp);
    }
    setState(() {
      updateIngredientsKey++;
    });
  }

  void decreaseNumberOfPersons() {
    if (numberOfPersonsTmp == 1) return;
    setState(() {
      controller.forward();
      numberOfPersonsTmp = numberOfPersonsTmp - 1;
    });
    for (int i = 0; i < recipe.ingredients.length; i++) {
      var ingredient = recipe.ingredients[i];
      var ingredientCpy = ingredientsTmp[i];
      ingredientCpy.amount =
          ((ingredient.amount / recipe.numberOfPersons) * numberOfPersonsTmp);
    }
    setState(() {
      updateIngredientsKey++;
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

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    final int likes = await RecipeController.toggleRecipeLike(recipe.id);
    setState(() {
      recipe.userLiked = !recipe.userLiked;
      recipe.likes = likes;
    });

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  @override
  void initState() {
    super.initState();
    loadRecipe();
    controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    animation = Tween<double>(begin: 40, end: 50).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("anim status completed");
        controller.reverse();
      }
    });
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
                color: Colors.black54,
                child: SingleChildScrollView(
                    //  padding: EdgeInsets.only(bottom: 15),
                    child: Column(children: [
                  Stack(children: [
                    Container(
                        height: 400,
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
                        child: Row(
                          children: [
                            Text(this.recipe.name,
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                                textAlign: TextAlign.center),
                            LikeButton(
                              size: 40,
                              circleColor: CircleColor(
                                  start: Color(0xffdd6666),
                                  end: Color(0xffff3600)),
                              likeCount: recipe.likes,
                              isLiked: recipe.userLiked,
                              onTap: onLikeButtonTapped,
                              likeBuilder: (bool isLiked) {
                                return isLiked
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 40,
                                      )
                                    : Icon(
                                        Icons.favorite_outline_sharp,
                                        color: Colors.grey,
                                        size: 40,
                                      );
                              },
                              countBuilder:
                                  (int count, bool isLiked, String text) {
                                var color =
                                    isLiked ? Colors.white : Colors.grey;
                                Widget result;
                                if (count == 0) {
                                  result = Text(
                                    "love",
                                    style: TextStyle(color: color),
                                  );
                                } else
                                  result = Text(
                                    text,
                                    style: TextStyle(color: color),
                                  );
                                return result;
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ))
                  ]),
                  Container(
                    color: Colors.black54,
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
                                      color: Colors.black54,
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
                                      color: Colors.black54,
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
                    color: Colors.black54,
                    width: double.infinity,
                    child: Column(children: [
                      Text(
                        AppLocalizations.of(context).ingredients,
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                decreaseNumberOfPersons();
                              },
                              child: Icon(
                                Icons.remove,
                                size: 32,
                              ),
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(CircleBorder()),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // <-- Button color
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                                height: 50,
                                width: numberOfPersonsTmp >= 10 ? 60 : 30,
                                child: Text(numberOfPersonsTmp.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: animation.value,
                                      color: Colors.white,
                                    ))),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                increaseNumberOfPersons();
                              },
                              child: Icon(
                                Icons.add,
                                size: 32,
                              ),
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(CircleBorder()),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // <-- Button color
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      showIngredientsIfNotEmpty(),
                    ]),
                  ),
                  Container(
                      color: Colors.black54,
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
                      color: Colors.black54,
                      width: double.infinity,
                      child: Column(children: [
                        Text(
                          AppLocalizations.of(context).howToCook,
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 0, right: 0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: recipe.instructions.length,
                                itemBuilder: (context, index) {
                                  final instruction =
                                      recipe.instructions[index];
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
                                }))
                      ])),
                ]))),
          ));
  }

  Widget showIngredientsIfNotEmpty() {
    if (recipe.ingredients.length != 0) {
      List<Widget> tiles = getAllIngredientTiles();
      return Column(
        key: ValueKey(updateIngredientsKey),
        children: <Widget>[
          for (int i = 0; i <= tiles.length / 3; i++)
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (i * 3 + 0 < tiles.length) ? tiles[i * 3 + 0] : Container(),
                (i * 3 + 1 < tiles.length)
                    ? tiles[i * 3 + 1]
                    : Container(
                        width: 92,
                      ),
                (i * 3 + 2 < tiles.length)
                    ? tiles[i * 3 + 2]
                    : Container(
                        width: 92,
                      )
              ],
            )
        ],
      );
    } else
      return Text(
        AppLocalizations.of(context).emptyIngredients,
        style: TextStyle(color: Colors.white),
      );
  }

  List<Widget> getAllIngredientTiles() {
    if (_myIngredientTiles.isEmpty) {
      for (int i = 0; i < ingredientsTmp.length; i++) {
        var ingredient = ingredientsTmp[i];
        var hasIngredient = userOwnedFood.any(
            (element) => element.foodProductId == ingredient.foodProductId);
        var onShoppingList = missingUserFood.any((element) =>
            element.foodProductId == ingredient.foodProductId &&
            element.onShoppingList);
        _myIngredientTiles.add(IngredientTileComponent(
            ingredient: ingredient,
            apiToken: apiToken,
            userOwns: hasIngredient,
            onShoppingList: onShoppingList == null ? false : onShoppingList,
            onTap: () => {_showMissingIngredientDialog(ingredient)}));
      }
      _myIngredientTiles.sort((a, b) {
        if (b.userOwns) {
          return 1;
        }
        return -1;
      });
    }
    // check if user switched ingredient manually
    else if (_toggledGroceryId != null) {
      var toggledIngredientTile = _myIngredientTiles.firstWhereOrNull(
          (element) => element.ingredient.foodProductId == _toggledGroceryId);
      if (toggledIngredientTile == null)
        print("Error: $_toggledGroceryId not found in IngredientTiles!");
      else {
        toggledIngredientTile.userOwns = _toggledGroceryNewState;
        toggledIngredientTile.onShoppingList =
            _toggledGroceryNewStateOnShoppingList;
      }
      // reset
      _toggledGroceryId = null;
    }
    return _myIngredientTiles;
  }

  List<Widget> getNutrientTiles() {
    List<Widget> myTiles = [];
    myTiles.addAll([
      NutrientTileComponent(
        nutrientName: AppLocalizations.of(context).calories,
        nutrientAmount: recipe.nutrients.calories.toDouble(),
        dailyRecAmount: dailyCalories.toDouble(),
        nutritionType: NutritionType.CALORIES,
        textColor: Colors.white,
      ),
      NutrientTileComponent(
        nutrientName: AppLocalizations.of(context).fat,
        nutrientAmount: recipe.nutrients.fat,
        dailyRecAmount: dailyFat,
        nutritionType: NutritionType.FAT,
        textColor: Colors.white,
      ),
      NutrientTileComponent(
        nutrientName: AppLocalizations.of(context).carbs,
        nutrientAmount: recipe.nutrients.carbohydrate,
        dailyRecAmount: dailyCarbohydrate,
        nutritionType: NutritionType.CARBOHYDRATE,
        textColor: Colors.white,
      ),
      NutrientTileComponent(
        nutrientName: AppLocalizations.of(context).protein,
        nutrientAmount: recipe.nutrients.protein,
        dailyRecAmount: dailyProtein,
        nutritionType: NutritionType.PROTEIN,
        textColor: Colors.white,
      )
    ]);

    return myTiles;
  }

  Future<void> _showMissingIngredientDialog(Ingredient ingredient) async {
    var ownedGroceries = await userFoodService.getUserFood(false);
    var missingGroceries = await userFoodService.getUserFood(true);
    print("items in cache: ${ownedGroceries.length+missingGroceries.length}");
    print("items in widget memory: ${userOwnedFood.length+missingUserFood.length}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new MissingIngredientDialog(ingredient: ingredient);
      },
    ).then(
        (res) async => {
              if (res == Constants.UserHasIngredient)
                {
                  UserFoodProductController.toggleUserFoodProduct(
                          ingredient.foodProductId, true, null)
                      .then((value) => {
                            // update hive box and ui
                            toggleIngredientState(
                                ingredient.foodProductId, true),
                          })
                }
              else if (res == Constants.UserLacksIngredient)
                {
                  UserFoodProductController.toggleUserFoodProduct(
                          ingredient.foodProductId, false, null)
                      .then((value) => {
                            toggleIngredientState(
                                ingredient.foodProductId, false),
                          }),
                }
              else if (res ==
                  Constants
                      .UserLacksIngredientAndWantsToAddToList) // add to shopping list
                {
                  UserFoodProductController.toggleUserFoodProduct(
                          ingredient.foodProductId, null, true)
                      .then((value) => toggleIngredientToShoppingList(
                          ingredient.foodProductId)),
                }
              else
                {
                  // Dialog was closed, do nothing!
                }
            },
        onError: (error) =>
            {print("Error in missingIngredientDialog " + error)});
  }

  Future<void> toggleIngredientState(int groceryId, bool setTo) async {
    List<UserFoodProduct> ownedGroceries =
        await userFoodService.getUserFood(false);
    List<UserFoodProduct> missingGroceries =
        await userFoodService.getUserFood(true);
    if (setTo == true) {
      var item = missingGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      var itemOwned = ownedGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      // check if item had the same state before
      if (itemOwned != null) {
        if (itemOwned.onShoppingList) {
          print("Error: Item owned was on shopping list!");
        }
        print("Item set to owned which was already owned. Nothing to do");
        return;
      }
      if (item == null) {
        print("ERROR: $groceryId not found in missingGroceries");
        return;
      } else {
        item.onShoppingList = false;
        missingGroceries.remove(item);
        ownedGroceries.add(item);
      }
    } else {
      var item = missingGroceries
          .firstWhereOrNull((item) => item.foodProductId == groceryId);
      // check if item had the same state before
      if (item != null) {
        if (item.onShoppingList == false) {
          print("Item was missing is set to missing, nothing todo.");
          return;
        } // item was in shopping list -> remove it
        else {
          setState(() {
            item.onShoppingList = false;
          });
        }
      } else {
        // item was not in missing list
        item = ownedGroceries
            .firstWhereOrNull((item) => item.foodProductId == groceryId);
        if (item == null) {
          print("ERROR: $groceryId not found in ownedGroceries!");
          //debug
          item = missingGroceries
        .firstWhereOrNull((item) => item.foodProductId == groceryId);
          if(item!=null)
            print("But now found in missing food products!");

          //debug end
          return;
        } else {
          ownedGroceries.remove(item);
          missingGroceries.add(item);
        }
      }
    }
    setState(() {
      _toggledGroceryId = groceryId;
      _toggledGroceryNewState = setTo;
      _toggledGroceryNewStateOnShoppingList = false;
      userOwnedFood = ownedGroceries;
      missingUserFood = missingGroceries;
      updateIngredientsKey++;
    });
    userFoodService.updateBoxValues(true, missingGroceries);
    userFoodService.updateBoxValues(false, ownedGroceries);
    // changing grocery stock requires reloading of recipes
    NeedsRecipeUpdateState().recipesUpdateNeeded = true;
  }

  toggleIngredientToShoppingList(int groceryId) async {
    List<UserFoodProduct> missingGroceries =
        await userFoodService.getUserFood(true);
    // item was missing before
    var item = missingGroceries
        .firstWhereOrNull((item) => item.foodProductId == groceryId);
    if (item != null) {
      //check if it was on shopping list before
      if (item.onShoppingList) {
        print("was on shopping list before, nothing to do");
        return;
      }
      setState(() {
        item.onShoppingList = true;
        _toggledGroceryNewStateOnShoppingList = true;
        _toggledGroceryNewState = false;
        _toggledGroceryId = groceryId;
        updateIngredientsKey++;
      });
      userFoodService.updateBoxValues(true, missingGroceries);
      NeedsRecipeUpdateState().recipesUpdateNeeded = true;
      return;
    }
    // item was owned before
    item = userOwnedFood
        .firstWhereOrNull((item) => item.foodProductId == groceryId);
    if (item != null) {
      userOwnedFood.remove(item);
      userOwnedFood.add(item);
      userFoodService.updateBoxValues(true, missingGroceries);
      userFoodService.updateBoxValues(false, userOwnedFood);
      setState(() {
        item.onShoppingList = true;
        _toggledGroceryNewStateOnShoppingList = true;
        _toggledGroceryNewState = false;
        _toggledGroceryId = groceryId;
        updateIngredientsKey++;
      });
      // changing grocery stock requires reloading of recipes
      NeedsRecipeUpdateState().recipesUpdateNeeded = true;
    } else {
      print("Error: Item to set on shopping list was not found!");
    }
  }
}
