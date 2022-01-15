import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class RecipeService {
  final HiveService hiveService = HiveService();

  List<dynamic> _recipeList = [];

  List<dynamic> get animeList => _recipeList;
  String _text = "";

  String get text => _text;

  getFilteredRecipes(Diet diet, bool highProteinFilter, bool highCarbFilter) async {
    print("Entered get Data()");
    _text = "Fetching data";
    bool exists = await hiveService.exists(boxName: "Recipes");
    if (exists) {
      _text = "Fetching from hive";
      print("Getting data from Hive");
      _recipeList = await hiveService.getBoxElements("Recipes");
    } else {
      _text = "Fetching from hive";
      print("Getting data from Api");
      var result = await RecipeController.getFilteredRecipes(
          diet, highProteinFilter, highCarbFilter);
      _recipeList.addAll(result);
      _text = "Caching data";
      await hiveService.addBox(_recipeList, "Recipes");
    }
  }
}
