import 'package:collection/src/iterable_extensions.dart';
import 'package:cookable_flutter/core/caching/foodproduct_service.dart';
import 'package:cookable_flutter/core/caching/like_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class RecipeService {
  final HiveService hiveService = HiveService();
  final FoodProductService foodProductService = FoodProductService();
  final LikeService likeService = LikeService();

  Future<List<Recipe>> getFilteredRecipes(
      Diet diet, bool highProteinFilter, bool highCarbFilter,
      {bool reload = false}) async {
    List<Recipe> _recipeList = [];
    bool exists = await hiveService.exists(boxName: "Recipes");
    if (exists && !reload) {
      // Getting Recipe from Hive
      _recipeList =
          (await hiveService.getBoxElements("Recipes")).cast<Recipe>();
      return _recipeList;
    } else {
      var result = await RecipeController.getFilteredRecipes(
          diet, highProteinFilter, highCarbFilter);
      _recipeList.addAll(result);
      if (reload) await hiveService.clearBox(boxName: "Recipes");
      await hiveService.addElementsToBox(_recipeList, "Recipes");
      return _recipeList;
    }
  }

  Future<List<Recipe>> getFilteredRecipesOffline(
      Diet diet, bool highProteinFilter, bool highCarbFilter,
      {bool itemsInStockChanged = false,
      bool nutrientsReCalcRequired = false,
      bool doReload = false}) async {
    List<Recipe> _recipeList = [];
    List<UserFoodProduct> _userOwnedFoodProducts = [];
    List<UserFoodProduct> _missingFoodProducts = [];
    Map<int, UserFoodProduct> _missingFoodProductsMap;
    bool exists = await hiveService.exists(boxName: "Recipes");

    if (!exists || doReload) {
      print("Getting Recipes from Api");
      var result = await RecipeController.getRecipes();
      if (doReload) await hiveService.clearBox(boxName: "Recipes");
      _recipeList.addAll(result);
      var totalRecipeLikes =
          await likeService.getTotalRecipeLikes(reload: doReload);
      var userRecipeLikesList =
          await likeService.getUserRecipeLikes(reload: doReload);
      var totalRecipeLikesMap = Map<int, int>.fromIterable(
          totalRecipeLikes,
          key: (element) => element.recipeId,
          value: (element) => element.likes);
      setRecipeLikes(_recipeList, userRecipeLikesList, totalRecipeLikesMap);

      await hiveService.addElementsToBox(_recipeList, "Recipes");
    }
    if (!exists || itemsInStockChanged || doReload) {
      // Recalculating missing ingredients
      final stopwatch = Stopwatch()..start();
      _recipeList =
          (await hiveService.getBoxElements("Recipes")).cast<Recipe>();
      _userOwnedFoodProducts = (await hiveService.getBoxElements("UserFood"))
          .cast<UserFoodProduct>();
      _missingFoodProducts =
          (await hiveService.getBoxElements("MissingUserFoodPlusShoppingList"))
              .cast<UserFoodProduct>();
      _missingFoodProductsMap = Map<int, UserFoodProduct>.fromIterable(
        _missingFoodProducts,
        key: (item) => item.foodProductId,
        value: (item) => item,
      );

      var _userGroceryIds =
          _userOwnedFoodProducts.map((e) => e.foodProductId).toSet();
      _recipeList.forEach((recipe) {
        var _requiredFoodProducts =
            recipe.ingredients.map((e) => e.foodProductId).toSet();
        var _missingRecipeFoodProductIds = _requiredFoodProducts
            .where((id) => !_userGroceryIds.contains(id))
            .toSet();
        var _missingRecipeFoodProducts = _missingRecipeFoodProductIds
            .map((id) => _missingFoodProductsMap[id])
            .toList();
        recipe.missingUserFoodProducts = _missingRecipeFoodProducts;
      });
      _recipeList.sort((a, b) {
        if (a.missingUserFoodProducts.length < b.missingUserFoodProducts.length)
          return -1;
        else
          return 1;
      });
      await hiveService.clearBox(boxName: "Recipes");
      await hiveService.addElementsToBox(_recipeList, "Recipes");
      print(
          "time for ingredient matching for ${_recipeList.length} recipes was: ${stopwatch.elapsedMilliseconds}");
    }

    if (!exists || nutrientsReCalcRequired || doReload) {
      var foodProducts =
          await foodProductService.getFoodProducts(reload: doReload);
      var foodProductMap = Map<int, FoodProduct>.fromIterable(
        foodProducts,
        key: (item) => item.id,
        value: (item) => item,
      );
      var defaultNutrients = await getDefaultNutrients();
      await setNutrientData(_recipeList, foodProductMap, defaultNutrients);

      _recipeList.sort((a, b) {
        if (a.missingUserFoodProducts.length < b.missingUserFoodProducts.length)
          return -1;
        else
          return 1;
      });
      await hiveService.clearBox(boxName: "Recipes");
      await hiveService.addElementsToBox(_recipeList, "Recipes");
    }

    if (exists &&
        !nutrientsReCalcRequired &&
        !itemsInStockChanged &&
        !doReload) {
      _recipeList =
          (await hiveService.getBoxElements("Recipes")).cast<Recipe>();
    }


    return _recipeList;
  }

  Future<Recipe> getRecipe(int recipeId, {bool reload = false}) async {
    final stopwatch = Stopwatch()..start();
    Recipe recipe;
    if (reload) {
      // Todo load recipe from backend and calc nutrients
      recipe = await RecipeController.getRecipe(recipeId);
      var foodProducts = (await foodProductService.getFoodProducts());
      var foodProductMap = Map<int, FoodProduct>.fromIterable(
        foodProducts,
        key: (item) => item.id,
        value: (item) => item,
      );
      // todo load user like and total likes
      var defaultNutrients = await getDefaultNutrients();
      await setNutrientData([recipe], foodProductMap, defaultNutrients);
      var userRecipeLikes =  await likeService.getUserRecipeLikes();
      await likeService.getTotalRecipeLikes();
    }
    List<Recipe> recipes =
    (await hiveService.getBoxElements("Recipes")).cast<Recipe>();
    recipe = recipes.firstWhere((element) => element.id == recipeId);
    if (recipe == null) {
      print("Recipe id=$recipeId was not in Cache! Loading from api (todo lol)");
    }
    print("time for get recipe was: ${stopwatch.elapsedMilliseconds}");
    return recipe;
  }

  Future<DefaultNutrients> getDefaultNutrients({bool reload = false}) async {
    bool exists = await hiveService.exists(boxName: "DefaultNutrients");
    if (exists && !reload) {
      // Getting DefaultNutrients from Hive");
      return (await hiveService.getBoxElements("DefaultNutrients"))
          .cast<DefaultNutrients>()[0];
    } else {
      var result = await RecipeController.getDefaultNutrients();
      if (reload) await hiveService.clearBox(boxName: "DefaultNutrients");
      await hiveService.addElementsToBox([result], "DefaultNutrients");
      return result;
    }
  }

  void setRecipeLikes(
      List<Recipe> recipes,
      List<UserRecipeLike> userRecipeLikes,
      Map<int, int> totalRecipeLikesList) {
    recipes.forEach((recipe) {
      recipe.likes = totalRecipeLikesList.containsKey(recipe.id)
          ? totalRecipeLikesList[recipe.id]
          : 0;
      var userRecipeLike = userRecipeLikes.firstWhereOrNull(
          (userRecipeLike) => userRecipeLike.recipeId == recipe.id);
      recipe.userLiked = userRecipeLike != null;
    });
  }

  Future<void> setNutrientData(
      List<Recipe> recipes,
      Map<int, FoodProduct> foodProducts,
      DefaultNutrients defaultNutrients) async {
    var now = DateTime.now();

    recipes.forEach((recipe) {
      double fat = 0;
      double carbohydrate = 0;
      double protein = 0;
      double calories = 0;
      double sugar = 0;
      int numPersons = recipe.numberOfPersons == 0 ? 1 : recipe.numberOfPersons;

      recipe.ingredients.forEach((ingredient) {
        var foodProduct = foodProducts[ingredient.foodProductId];
        var gramPerPiece = foodProduct.quantityType.value == QuantityUnit.PIECES
            ? foodProduct.gramPerPiece
            : 1;
        var amount = ingredient.amount;
        double factor = (amount * gramPerPiece) / 100;

        fat += foodProduct.nutrients == null
            ? 0
            : foodProduct.nutrients.fat * factor;
        sugar += foodProduct.nutrients == null
            ? 0
            : foodProduct.nutrients.sugar * factor;
        carbohydrate += foodProduct.nutrients == null
            ? 0
            : foodProduct.nutrients.carbohydrate * factor;
        protein += foodProduct.nutrients == null
            ? 0
            : foodProduct.nutrients.protein * factor;
        calories += foodProduct.nutrients == null
            ? 0
            : foodProduct.nutrients.calories * factor;
      });

      bool isHighProtein = calories == 0
          ? false
          : ((protein * defaultNutrients.caloriesPerGramProtein) / calories) >
              defaultNutrients.caloriesThresholdHighProtein;
      bool isHighCarb = calories == 0
          ? false
          : ((carbohydrate * defaultNutrients.caloriesPerGramCarb) / calories) >
              defaultNutrients.caloriesThresholdHighCarb;

      recipe.nutrients = Nutrients(
          fat: fat / numPersons,
          carbohydrate: carbohydrate / numPersons,
          sugar: sugar / numPersons,
          protein: protein / numPersons,
          calories: (calories / numPersons).round(),
          source: "derived",
          dateOfRetrieval: now,
          isHighProteinRecipe: isHighProtein,
          isHighCarbRecipe: isHighCarb);
    });
  }

  clearDefaultNutrients() async {
    return hiveService.clearBox(boxName: "DefaultNutrients");
  }

  clearPrivateRecipes() async {
    return hiveService.clearBox(boxName: "Recipes");
  }

  addOrUpdateRecipe(Recipe recipe) async {
    return hiveService.addOrUpdateElementInBoxById(recipe, "Recipes");
  }
}
