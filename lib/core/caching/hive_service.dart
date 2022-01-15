import 'package:hive/hive.dart';

class HiveService {

  exists({String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBox<T>(List<T> items, String boxName) async {
    print("adding box");
    final openBox = await Hive.openBox(boxName);

    for (var item in items) {
      openBox.add(item);
    }
  }

  clearBox({String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    return openBox.clear();
  }

  getBoxElements(String boxName) async {
    List boxList = [];

    final openBox = await Hive.openBox(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }

}