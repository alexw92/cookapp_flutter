import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class PrivateRecipeService {
  final HiveService hiveService = HiveService();

  String _text = "";

  String get text => _text;

  Future<List<PrivateRecipe>> getPrivateRecipes({bool reload = false}) async {
    List<PrivateRecipe> _recipeList = [];
    print("Entered get Data()");
    _text = "Fetching data";
    bool exists = await hiveService.exists(boxName: "PrivateRecipes");
    if (exists && !reload) {
      _text = "Fetching from hive";
      print("Getting data from Hive");
      _recipeList = (await hiveService.getBoxElements("PrivateRecipes"))
          .cast<PrivateRecipe>();
      return _recipeList;
    } else {
      _text = "Fetching from hive";
      print("Getting data from Api");
      var result = await RecipeController.getPrivateRecipes();
      _recipeList.addAll(result);
      _text = "Caching data";
      if (reload) await hiveService.clearBox(boxName: "PrivateRecipes");
      await hiveService.addBox(_recipeList, "PrivateRecipes");
      return _recipeList;
    }
  }

  clearPrivateRecipes() async {
    return hiveService.clearBox(boxName: "PrivateRecipes");
  }

  addOrUpdatePrivateRecipe(PrivateRecipe privateRecipe) async {
    await hiveService.addBox([privateRecipe], "PrivateRecipes");
  }
}
