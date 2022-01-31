import 'package:hive/hive.dart';

class HiveService {
  exists({String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addElementsToBox<T>(List<T> items, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    for (var item in items) {
      openBox.add(item);
    }
  }

  Future<void> putElement(dynamic key, dynamic value, String boxName) async {
    final openBox = await Hive.openBox(boxName);
    return openBox.put(key, value);
  }

  Future<dynamic> getElement(dynamic key, String boxName) async {
    final openBox = await Hive.openBox(boxName);
    return openBox.get(key);
  }

  Future<Map<dynamic, dynamic>> getMap(String boxName) async {
    final openBox = await Hive.openBox(boxName);
    return openBox.toMap();
  }

  Future<void> putElements(Map entries, String boxName) async {
    final openBox = await Hive.openBox(boxName);
    return openBox.putAll(entries);
  }

  dynamic clearElement(dynamic key, String boxName) async {
    final openBox = await Hive.openBox(boxName);
    return await openBox.delete(key);
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

  addOrUpdateElementInBoxById(dynamic item, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    var isInBox = openBox.values.any((element) => element.id == item.id);
    if (!isInBox)
      return openBox.add(item);
    else {
      var index = -1;
      for (int i = 0; i < openBox.length; i++) {
        index = i;
        if (openBox.getAt(i).id == item.id) {
          break;
        }
      }
      await openBox.deleteAt(index);
      return openBox.add(item);
    }
  }

  void clearElementFromBoxById(dynamic item, String boxName) async {
    final openBox = await Hive.openBox(boxName);
    var index = -1;
    for (int i = 0; i < openBox.length; i++) {
      index = i;
      if (openBox.getAt(i).id == item.id) {
        break;
      }
    }
    await openBox.deleteAt(index);
  }

}
