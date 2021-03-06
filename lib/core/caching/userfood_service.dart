import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class UserFoodService {
  final HiveService hiveService = HiveService();

  Future<List<UserFoodProduct>> getUserFood(bool missingUserFood,
      {bool reload = false}) async {
    List<UserFoodProduct> _recipeList = [];
    String foodBoxName =
        missingUserFood ? "MissingUserFoodPlusShoppingList" : "UserFood";
    bool exists = await hiveService.exists(boxName: foodBoxName);
    if (exists && !reload) {
      // Getting UserFoodProduct from Hive
      _recipeList = (await hiveService.getBoxElements(foodBoxName))
          .cast<UserFoodProduct>();
      return _recipeList;
    } else {
      var result =
          await UserFoodProductController.getUserFoodProducts(missingUserFood);
      _recipeList.addAll(result);
      if (reload) await hiveService.clearBox(boxName: foodBoxName);
      var map = Map<int, UserFoodProduct>.fromIterable(_recipeList,
          key: (el) => el.foodProductId, value: (el) => el);
      await hiveService.putElements(map, foodBoxName);
      return _recipeList;
    }
  }

  Future<UserFoodProduct> getUserFoodById(bool missingUserFood, int groceryId) {
    String foodBoxName =
        missingUserFood ? "MissingUserFoodPlusShoppingList" : "UserFood";
    return hiveService.getElement(groceryId, foodBoxName);
  }

  Future<void> addBoxValue(bool missingUserFood, UserFoodProduct foodProduct) async {
    String foodBoxName =
    missingUserFood ? "MissingUserFoodPlusShoppingList" : "UserFood";
    await hiveService.putElement(foodProduct.foodProductId, foodProduct, foodBoxName);
  }

  Future<UserFoodProduct> removeBoxValue(bool missingUserFood, UserFoodProduct foodProduct) async {
    String foodBoxName =
    missingUserFood ? "MissingUserFoodPlusShoppingList" : "UserFood";
    var userFoodProduct = await hiveService.clearElement(foodProduct.foodProductId, foodBoxName);
    return userFoodProduct as UserFoodProduct;
  }

  updateBoxValues(
      bool missingUserFood, List<UserFoodProduct> foodProducts) async {
    String foodBoxName =
        missingUserFood ? "MissingUserFoodPlusShoppingList" : "UserFood";
    await hiveService.clearBox(boxName: foodBoxName);
    var map = Map<int, UserFoodProduct>.fromIterable(foodProducts,
        key: (el) => el.foodProductId, value: (el) => el);
    await hiveService.putElements(map, foodBoxName);
  }

  clearUserFood() async {
    await hiveService.clearBox(boxName: "MissingUserFoodPlusShoppingList");
    return hiveService.clearBox(boxName: "UserFood");
  }
}
