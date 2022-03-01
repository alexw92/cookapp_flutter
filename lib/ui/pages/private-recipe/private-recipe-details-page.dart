import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/common/constants.dart';
import 'package:cookable_flutter/core/caching/firebase_image_service.dart';
import 'package:cookable_flutter/core/caching/private_recipe_service.dart';
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

class PrivateRecipeDetailsPage extends StatefulWidget {
  final int recipeId;

  PrivateRecipeDetailsPage(this.recipeId, {Key key}) : super(key: key);

  @override
  _PrivateRecipeDetailsPageState createState() =>
      _PrivateRecipeDetailsPageState();
}

class _PrivateRecipeDetailsPageState extends State<PrivateRecipeDetailsPage>
    with SingleTickerProviderStateMixin {
  PrivateRecipe recipe;
  String apiToken;
  RecipeService recipeService = RecipeService();
  PrivateRecipeService privateRecipeService = PrivateRecipeService();
  UserFoodService userFoodService = UserFoodService();
  FirebaseImageService firebaseImageService = FirebaseImageService();
  List<UserFoodProduct> userOwnedFood;
  List<UserFoodProduct> missingUserFoodAndShoppingList;
  DefaultNutrients defaultNutrients;
  int dailyCalories;
  double dailyCarbohydrate;
  double dailyProtein;
  double dailyFat;
  int numberOfPersonsTmp;
  bool defaultImg = false;
  bool showProgressIndicatorImage;
  String recipeImgUrl;
  List<Ingredient> ingredientsTmp;
  Animation<double> animation;
  AnimationController controller;
  List<IngredientTileComponent> myTiles = [];
  int updateIngredientsKey = 1;
  int _toggledGroceryId;
  bool _toggledGroceryNewState;
  bool _toggledGroceryNewStateOnShoppingList = false;

  _PrivateRecipeDetailsPageState();

  void loadRecipe() async {
    apiToken = await TokenStore().getToken();
    defaultNutrients = await recipeService.getDefaultNutrients();
    dailyCalories = defaultNutrients.recDailyCalories;
    dailyCarbohydrate = defaultNutrients.recDailyCarbohydrate;
    dailyProtein = defaultNutrients.recDailyProtein;
    dailyFat = defaultNutrients.recDailyFat;
    userOwnedFood = await userFoodService.getUserFood(false);
    missingUserFoodAndShoppingList = await userFoodService.getUserFood(true);
    this.recipe =
        await privateRecipeService.getPrivateRecipe(this.widget.recipeId);
    await getImageUrl();
    var ingredientsCopy = copyIngredients(recipe.ingredients);
    setState(() {
      numberOfPersonsTmp = recipe.numberOfPersons;
      ingredientsTmp = ingredientsCopy;
      showProgressIndicatorImage = false;
    });
  }

  getImageUrl() async {
    print(recipe.imgSrc);
    if (recipe.imgSrc.contains("food.png")) {
      setState(() {
        defaultImg = true;
      });
      return;
    }
    var imgUrl = await firebaseImageService.getFirebaseImage(recipe.imgSrc);
    setState(() {
      defaultImg = false;
      recipeImgUrl = imgUrl;
    });
  }

  void increaseNumberOfPersons() {
    setState(() {
      controller.forward();
    });
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
    setState(() {
      updateIngredientsKey++;
    });
  }

  void decreaseNumberOfPersons() {
    setState(() {
      controller.forward();
    });
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

  @override
  void initState() {
    super.initState();
    setState(() {
      showProgressIndicatorImage = true;
    });
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
                color: Colors.black54,
                child: SingleChildScrollView(
                    //  padding: EdgeInsets.only(bottom: 15),
                    child: Column(children: [
                  Stack(children: [
                    Container(
                        height: 400,
                        color: Colors.grey,
                        width: double.infinity,
                        child: (showProgressIndicatorImage)
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : FittedBox(
                                fit: BoxFit.fill,
                                child: Image(
                                  // needs --web-renderer html
                                  image: CachedNetworkImageProvider(
                                      (defaultImg)
                                          ? recipe.imgSrc
                                          : recipeImgUrl,
                                      imageRenderMethodForWeb:
                                          ImageRenderMethodForWeb.HttpGet),
                                  // backgroundColor: Colors.transparent,
                                  //  radius: 40,
                                ))),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Column(children: [
                        Wrap(direction: Axis.vertical, children: [
                          Stack(children: [
                            (recipe.uploadedBy.fbUploadedPhoto == null &&
                                    recipe.uploadedBy.providerPhoto == null)
                                ? CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                      size: 74,
                                    ),
                                    radius: 40,
                                  )
                                : CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        (recipe.uploadedBy.fbUploadedPhoto ==
                                                null)
                                            ? recipe.uploadedBy.providerPhoto
                                            : recipe.uploadedBy.fbUploadedPhoto,
                                        imageRenderMethodForWeb:
                                            ImageRenderMethodForWeb.HttpGet),
                                    // backgroundColor: Colors.transparent,
                                    radius: 40,
                                  ),
                          ]),
                          SizedBox(
                              width: 80,
                              child: Text(
                                (recipe.uploadedBy.displayName ??
                                    "anonymousUser"),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                                textAlign: TextAlign.center,
                              ))
                        ])
                      ]),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 8,
                      right: 8,
                      child: Text(this.recipe.name,
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          textAlign: TextAlign.center),
                    )
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
                      getIngredientScalerIfNotEmpty(),
                      SizedBox(
                        height: 5,
                      ),
                      showIngredientsIfNotEmpty()
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
                        showInstructionsIfNotEmpty()
                      ])),
                ]))),
          ));
  }

  List<Widget> getAllIngredientTiles() {
    if (myTiles.isEmpty) {
      for (int i = 0; i < ingredientsTmp.length; i++) {
        var ingredient = ingredientsTmp[i];
        var hasIngredient = userOwnedFood.any(
            (element) => element.foodProductId == ingredient.foodProductId);
        var onShoppingList = missingUserFoodAndShoppingList.any((element) =>
            element.foodProductId == ingredient.foodProductId &&
            element.onShoppingList);
        myTiles.add(IngredientTileComponent(
            ingredient: ingredient,
            apiToken: apiToken,
            userOwns: hasIngredient,
            onShoppingList: onShoppingList == null ? false : onShoppingList,
            onTap: () => {_showMissingIngredientDialog(ingredient)}));
      }
      myTiles.sort((a, b) {
        if (!a.userOwns && b.userOwns) {
          return 1;
        } else if (a.userOwns && !b.userOwns) {
          return -1;
        } else {
          if (!a.onShoppingList && b.onShoppingList)
            return 1;
          else if (a.onShoppingList && !b.onShoppingList) return -1;
          return 0;
        }
      });
    }
    // check if user switched ingredient manually
    else if (_toggledGroceryId != null) {
      var toggledIngredientTile = myTiles.firstWhereOrNull(
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
        child: Icon(Icons.remove, size: 32),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
          backgroundColor:
              MaterialStateProperty.all(Colors.white), // <-- Button color
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
        child: Icon(Icons.add, size: 32),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
          backgroundColor:
              MaterialStateProperty.all(Colors.white), // <-- Button color
        ),
      )
    ]);
  }

  Future<void> _showMissingIngredientDialog(Ingredient ingredient) async {
    // var ownedGroceries = await userFoodService.getUserFood(false);
    // var missingGroceriesAndShoppingList = await userFoodService.getUserFood(true);
    // print(
    //     "items in cache missing: ${missingGroceriesAndShoppingList.where((element) => element.onShoppingList == false).length}");
    // print("items in cache owned: ${ownedGroceries.length}");
    // print(
    //     "items in cache shoppingList: ${missingGroceriesAndShoppingList.where((element) => element.onShoppingList == true).length}");
    // print(
    //     "items in widget missing: ${missingUserFoodAndShoppingList.where((element) => element.onShoppingList == false).length}");
    // print("items in widget owned: ${userOwnedFood.length}");
    // print(
    //     "items in widget shoppingList: ${missingUserFoodAndShoppingList.where((element) => element.onShoppingList == true).length}");
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
    List<UserFoodProduct> missingGroceriesAndShoppingList =
        await userFoodService.getUserFood(true);
    if (setTo == true) {
      var item = missingGroceriesAndShoppingList
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
        missingGroceriesAndShoppingList.remove(item);
        ownedGroceries.add(item);
      }
    } else {
      var item = missingGroceriesAndShoppingList
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
          item = missingGroceriesAndShoppingList
              .firstWhereOrNull((item) => item.foodProductId == groceryId);
          if (item != null) print("But now found in missing food products!");

          //debug end
          return;
        } else {
          ownedGroceries.remove(item);
          missingGroceriesAndShoppingList.add(item);
        }
      }
    }

    userOwnedFood = ownedGroceries;
    missingUserFoodAndShoppingList = missingGroceriesAndShoppingList;
    await userFoodService.updateBoxValues(true, missingUserFoodAndShoppingList);
    await userFoodService.updateBoxValues(false, userOwnedFood);
    _toggledGroceryId = groceryId;
    _toggledGroceryNewState = setTo;
    _toggledGroceryNewStateOnShoppingList = false;
    updateIngredientsKey++;
    // changing grocery stock requires reloading of recipes
    NeedsRecipeUpdateState().recipesUpdateNeeded = true;
    setState(() {});
  }

  toggleIngredientToShoppingList(int groceryId) async {
    List<UserFoodProduct> missingGroceriesAndShoppingList =
        await userFoodService.getUserFood(true);
    missingUserFoodAndShoppingList = missingGroceriesAndShoppingList;
    // item was missing before
    var item = missingGroceriesAndShoppingList
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
      await userFoodService.updateBoxValues(
          true, missingGroceriesAndShoppingList);
      NeedsRecipeUpdateState().recipesUpdateNeeded = true;
      return;
    }
    // item was owned before
    item = userOwnedFood
        .firstWhereOrNull((item) => item.foodProductId == groceryId);
    if (item != null) {
      item.onShoppingList = true;
      userOwnedFood.remove(item);
      missingGroceriesAndShoppingList.add(item);
      await userFoodService.updateBoxValues(
          true, missingGroceriesAndShoppingList);
      await userFoodService.updateBoxValues(false, userOwnedFood);
      _toggledGroceryNewStateOnShoppingList = true;
      _toggledGroceryNewState = false;
      _toggledGroceryId = groceryId;
      updateIngredientsKey++;
      setState(() {});
      // changing grocery stock requires reloading of recipes
      NeedsRecipeUpdateState().recipesUpdateNeeded = true;
    } else {
      print("Error: Item to set on shopping list was not found!");
    }
  }
}
