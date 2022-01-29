import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class RecipeService {
  final HiveService hiveService = HiveService();

  Future<List<Recipe>> getFilteredRecipes(
      Diet diet, bool highProteinFilter, bool highCarbFilter,
      {bool reload = false}) async {
    List<Recipe> _recipeList = [];
    bool exists = await hiveService.exists(boxName: "Recipes");
    if (exists && !reload) {
      print("Getting data from Hive");
      _recipeList =
          (await hiveService.getBoxElements("Recipes")).cast<Recipe>();
      return _recipeList;
    } else {
      print("Getting data from Api");
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
      {itemsInStockChanged = false}) async {
    final stopwatch = Stopwatch()..start();
    List<Recipe> _recipeList = [];
    List<UserFoodProduct> _userOwnedFoodProducts = [];
    List<UserFoodProduct> _missingFoodProducts = [];
    Map<int, UserFoodProduct> _missingFoodProductsMap;
    bool exists = await hiveService.exists(boxName: "Recipes");

    if (!exists) {
      print("Getting data from Api");
      var result = await RecipeController.getFilteredRecipes(
          diet, highProteinFilter, highCarbFilter);
      _recipeList.addAll(result);
      await hiveService.addElementsToBox(_recipeList, "Recipes");
    }
    if (!exists || itemsInStockChanged) {
      print("Recalculating missing ingredients");

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
        var _missingRecipeFoodProductIds =
            _requiredFoodProducts.where((id) => !_userGroceryIds.contains(id)).toSet();
        var _missingRecipeFoodProducts = _missingRecipeFoodProductIds
            .map(
                (id) => _missingFoodProductsMap[id]
        ).toList();
        recipe.missingUserFoodProducts = _missingRecipeFoodProducts;
      });
      await hiveService.clearBox(boxName: "Recipes");
      await hiveService.addElementsToBox(_recipeList, "Recipes");
    } else {
      _recipeList =
          (await hiveService.getBoxElements("Recipes")).cast<Recipe>();
    }
    print("time for ingredient matching for ${_recipeList.length} recipes was: ${stopwatch.elapsedMilliseconds}");
    return _recipeList;
  }

  Future<DefaultNutrients> getDefaultNutrients({bool reload = false}) async {
    bool exists = await hiveService.exists(boxName: "DefaultNutrients");
    if (exists && !reload) {
      print("Getting data from Hive");
      return (await hiveService.getBoxElements("DefaultNutrients"))
          .cast<DefaultNutrients>()[0];
    } else {
      print("Getting data from Api");
      var result = await RecipeController.getDefaultNutrients();
      if (reload) await hiveService.clearBox(boxName: "DefaultNutrients");
      await hiveService.addElementsToBox([result], "DefaultNutrients");
      return result;
    }
  }

  clearDefaultNutrients() async {
    return hiveService.clearBox(boxName: "DefaultNutrients");
  }

  clearPrivateRecipes() async {
    return hiveService.clearBox(boxName: "Recipes");
  }
}
