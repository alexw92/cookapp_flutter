import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class UserFoodService {
  final HiveService hiveService = HiveService();

  Future<List<UserFoodProduct>> getUserFood(bool missingUserFood,
      {bool reload = false}) async {
    List<UserFoodProduct> _recipeList = [];
    String foodBoxName = missingUserFood ? "MissingUserFood" : "UserFood";
    bool exists = await hiveService.exists(boxName: foodBoxName);
    if (exists && !reload) {
      print("Getting data from Hive");
      _recipeList = (await hiveService.getBoxElements(foodBoxName))
          .cast<UserFoodProduct>();
      return _recipeList;
    } else {
      print("Getting data from Api");
      var result =
          await UserFoodProductController.getUserFoodProducts(missingUserFood);
      _recipeList.addAll(result);
      if (reload) await hiveService.clearBox(boxName: foodBoxName);
      await hiveService.addElementsToBox(_recipeList, foodBoxName);
      return _recipeList;
    }
  }

  updateBoxValues(
      bool missingUserFood, List<UserFoodProduct> foodProducts) async {
    String foodBoxName = missingUserFood ? "MissingUserFood" : "UserFood";
    await hiveService.clearBox(boxName: foodBoxName);
    await hiveService.addElementsToBox(foodProducts, foodBoxName);
  }

  clearUserFood() async {
    await hiveService.clearBox(boxName: "MissingUserFood");
    return hiveService.clearBox(boxName: "UserFood");
  }
}
