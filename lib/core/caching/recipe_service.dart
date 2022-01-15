import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class RecipeService {
  final HiveService hiveService = HiveService();


  String _text = "";

  String get text => _text;

  Future<List<Recipe>> getFilteredRecipes(Diet diet, bool highProteinFilter, bool highCarbFilter, {bool reload=false}) async {
    List<Recipe> _recipeList = [];
    print("Entered get Data()");
    _text = "Fetching data";
    bool exists = await hiveService.exists(boxName: "Recipes");
    if (exists && !reload) {
      _text = "Fetching from hive";
      print("Getting data from Hive");
      _recipeList = (await hiveService.getBoxElements("Recipes")).cast<Recipe>();
      return _recipeList;
    } else {
      _text = "Fetching from hive";
      print("Getting data from Api");
      var result = await RecipeController.getFilteredRecipes(
          diet, highProteinFilter, highCarbFilter);
      _recipeList.addAll(result);
      _text = "Caching data";
      if(reload)
        await hiveService.clearBox(boxName: "Recipes");
      await hiveService.addBox(_recipeList, "Recipes");
      return _recipeList;
    }
  }
}
