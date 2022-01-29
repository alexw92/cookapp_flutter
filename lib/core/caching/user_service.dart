import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';

import 'hive_service.dart';

class UserService {
  final HiveService hiveService = HiveService();

  Future<ReducedUser> getUser({bool reload = false}) async {
    ReducedUser user;
    bool exists = await hiveService.exists(boxName: "Users");
    if (exists && !reload) {
      print("Getting data from Hive");
      var _userList = (await hiveService.getBoxElements("Users"))
          .cast<ReducedUser>();
      user = _userList[0];
      return user;
    } else {
      print("Getting data from Api");
      var result = await UserController.getUser();
      user = result;
      if (reload) await hiveService.clearBox(boxName: "Users");
      await hiveService.addElementsToBox([user], "Users");
      return user;
    }
  }

  clearUsers() async {
    return hiveService.clearBox(boxName: "Users");
  }

}
