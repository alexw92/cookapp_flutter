import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class LikeService {
  final HiveService hiveService = HiveService();

  Future<List<TotalRecipeLikes>> getTotalRecipeLikes(
      {bool reload = false}) async {
    List<TotalRecipeLikes> _totalRecipeLikesList = [];
    bool exists = await hiveService.exists(boxName: "TotalRecipeLikes");
    if (exists && !reload) {
      // Getting TotalRecipeLikes from Hive
      _totalRecipeLikesList =
          (await hiveService.getBoxElements("TotalRecipeLikes"))
              .cast<TotalRecipeLikes>();
      return _totalRecipeLikesList;
    } else {
      var result = await RecipeController.getTotalRecipeLikes();
      _totalRecipeLikesList.addAll(result);
      if (reload) await hiveService.clearBox(boxName: "TotalRecipeLikes");
      await hiveService.addElementsToBox(
          _totalRecipeLikesList, "TotalRecipeLikes");
      return _totalRecipeLikesList;
    }
  }

  clearTotalRecipeLikes() async {
    return hiveService.clearBox(boxName: "TotalRecipeLikes");
  }

  Future<List<UserRecipeLike>> getUserRecipeLikes({bool reload = false}) async {
    List<UserRecipeLike> _userRecipeLikes = [];
    bool exists = await hiveService.exists(boxName: "UserRecipeLikes");
    if (exists && !reload) {
      // Getting UserRecipeLikes from Hive
      _userRecipeLikes = (await hiveService.getBoxElements("UserRecipeLikes"))
          .cast<UserRecipeLike>();
      return _userRecipeLikes;
    } else {
      print("Getting UserRecipeLikes from Api");
      var result = await RecipeController.getUserRecipeLikes();
      _userRecipeLikes.addAll(result);
      if (reload) await hiveService.clearBox(boxName: "UserRecipeLikes");
      await hiveService.addElementsToBox(_userRecipeLikes, "UserRecipeLikes");
      return _userRecipeLikes;
    }
  }

  clearUserRecipeLikes() async {
    return hiveService.clearBox(boxName: "UserRecipeLikes");
  }
}
