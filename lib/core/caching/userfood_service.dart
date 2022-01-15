import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class UserFoodService {
  final HiveService hiveService = HiveService();

  String _text = "";

  String get text => _text;

  Future<List<UserFoodProduct>> getUserFood(bool missingUserFood, {bool reload=false}) async {
    List<UserFoodProduct> _recipeList = [];
    print("Entered get Data()");
    _text = "Fetching data";
    String foodBoxName = missingUserFood?"MissingUserFood":"UserFood";
    bool exists = await hiveService.exists(boxName: foodBoxName);
    if (exists && !reload) {
      _text = "Fetching from hive";
      print("Getting data from Hive");
      _recipeList = (await hiveService.getBoxElements(foodBoxName)).cast<UserFoodProduct>();
      return _recipeList;
    } else {
      _text = "Fetching from hive";
      print("Getting data from Api");
      var result = await UserFoodProductController.getUserFoodProducts(missingUserFood);
      _recipeList.addAll(result);
      _text = "Caching data";
      await hiveService.addBox(_recipeList, foodBoxName);
      return _recipeList;
    }
  }
}
