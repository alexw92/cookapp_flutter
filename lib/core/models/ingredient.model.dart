//import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

@immutable
class Ingredient {
  String id;
  String imagePath;
  String title;
  double quantity;
  String unit;

  Ingredient(this.id, this.imagePath, this.title, this.quantity, this.unit);

  @override
  String toString() {
    return 'Ingredient{id:$id,imagePath: $imagePath, title: $title, quantity: $quantity, unit:$unit}';
  }

  Ingredient.fromJson(Map jsonMap) {
    id = jsonMap['id'];
    imagePath = jsonMap['imagePath'];
    title = jsonMap['title'];
    quantity = jsonMap['quantity'];
    unit = jsonMap['unit'];
  }

  Map<Object, dynamic> toMap() {
    Map map = <Object, dynamic>{
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'quantity': quantity,
      'unit': unit
    };

    return map;
  }
}
