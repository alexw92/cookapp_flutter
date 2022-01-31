import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class FoodProductService {
  final HiveService hiveService = HiveService();

  Future<List<FoodProduct>> getFoodProducts({bool reload = false}) async {
    List<FoodProduct> _foodProductList = [];
    bool exists = await hiveService.exists(boxName: "FoodProducts");
    if (exists && !reload) {
     // Getting FoodProduct from Hive
      _foodProductList = (await hiveService.getBoxElements("FoodProducts"))
          .cast<FoodProduct>();
      return _foodProductList;
    } else {
      var result = await FoodProductController.getFoodProducts();
      _foodProductList.addAll(result);
      if (reload) await hiveService.clearBox(boxName: "FoodProducts");
      var map = Map<int, FoodProduct>.fromIterable(_foodProductList,
          key: (element) => element.id, value: (element)=>element);
      await hiveService.putElements(map, "FoodProducts");
      return _foodProductList;
    }
  }

  clearFoodProducts() async {
    return hiveService.clearBox(boxName: "FoodProducts");
  }

}
