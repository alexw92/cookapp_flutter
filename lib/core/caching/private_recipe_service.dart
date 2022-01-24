import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class PrivateRecipeService {
  final HiveService hiveService = HiveService();

  Future<List<PrivateRecipe>> getPrivateRecipes({bool reload = false}) async {
    List<PrivateRecipe> _recipeList = [];
    bool exists = await hiveService.exists(boxName: "PrivateRecipes");
    if (exists && !reload) {
      print("Getting data from Hive");
      _recipeList = (await hiveService.getBoxElements("PrivateRecipes"))
          .cast<PrivateRecipe>();
      return _recipeList;
    } else {
      print("Getting data from Api");
      var result = await RecipeController.getPrivateRecipes();
      _recipeList.addAll(result);
      if (reload) await hiveService.clearBox(boxName: "PrivateRecipes");
      await hiveService.addElementsToBox(_recipeList, "PrivateRecipes");
      return _recipeList;
    }
  }

  clearPrivateRecipes() async {
    return hiveService.clearBox(boxName: "PrivateRecipes");
  }

  addOrUpdatePrivateRecipe(PrivateRecipe privateRecipe) async {
    await hiveService.addOrUpdateElementInBoxById(
        privateRecipe, "PrivateRecipes");
  }

  clearPrivateRecipe(PrivateRecipe deletedItem) {
    hiveService.clearElementFromBoxById(deletedItem, "PrivateRecipes");
  }
}
