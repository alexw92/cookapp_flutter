import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class RecipeService {
  final HiveService hiveService = HiveService();

  Future<List<Recipe>> getFilteredRecipes(
      Diet diet, bool highProteinFilter, bool highCarbFilter,
      {bool reload = false}) async {
    List<Recipe> _recipeList = [];
    print("Entered get Data()");
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

  Future<DefaultNutrients> getDefaultNutrients({bool reload = false}) async {
    print("Entered get Data()");
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
