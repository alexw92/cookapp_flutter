import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class PrivateRecipeService {
  final HiveService hiveService = HiveService();

  Future<List<PrivateRecipe>> getPrivateRecipes({bool reload = false}) async {
    List<PrivateRecipe> _recipeList = [];
    bool exists = await hiveService.exists(boxName: "PrivateRecipes");
    if (exists && !reload) {
      // Getting PrivateRecipes from Hive
      _recipeList = (await hiveService.getBoxElements("PrivateRecipes"))
          .cast<PrivateRecipe>();
      return _recipeList;
    } else {
      var result = await RecipeController.getPrivateRecipes();
      _recipeList.addAll(result);
      if (reload) await hiveService.clearBox(boxName: "PrivateRecipes");
      var map = Map<int, PrivateRecipe>.fromIterable(_recipeList,
          key: (el) => el.id, value: (el) => el);
      await hiveService.putElements(map, "PrivateRecipes");
      return _recipeList;
    }
  }

  clearPrivateRecipes() async {
    return hiveService.clearBox(boxName: "PrivateRecipes");
  }

  addOrUpdatePrivateRecipe(PrivateRecipe privateRecipe) async {
    await hiveService.putElement(
        privateRecipe.id, privateRecipe, "PrivateRecipes");
  }

  getPrivateRecipe(int recipeId) async {
    PrivateRecipe privateRecipe = (await hiveService.getElement(
        recipeId, "PrivateRecipes")) as PrivateRecipe;
    return privateRecipe;
  }

  clearPrivateRecipe(PrivateRecipe deletedItem) {
    hiveService.clearElement(deletedItem.id, "PrivateRecipes");
  }
}
