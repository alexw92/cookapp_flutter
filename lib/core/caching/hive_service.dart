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

  getBoxElements<T>(String boxName) async {
    List<T> boxList = [];

    final openBox = await Hive.openBox(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }

}