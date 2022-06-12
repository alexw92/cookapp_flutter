import 'package:flutter/material.dart';

class Constants {
  static const String HOME_PAGE = 'home_page';
  static const String FRIDGE_PAGE = '/fridge_page';
  static const String FAVOURITE_RECIPES_PAGE = '/favourite_recipes_page';

  static const String DEFAULT_RECIPE_IMG = "food.png";

  static const int UserHasIngredient = 0;
  static const int UserLacksIngredient = 1;
  static const int UserLacksIngredientAndWantsToAddToList = 2;

  static const List<Color> neutralColors1 = [
    Color(0xff988792),
    Color(0xffb2a596),
    Color(0xffc1ad77),
    Color(0xffa5a37e),
    Color(0xff9ba4a8)
  ];
  static const List<Color> neutralColors2 = [
    Color(0xffada3a4),
    Color(0xffc5b8ba),
    Color(0xffd5c28b),
    Color(0xffbbbd90),
    Color(0xffb2bbc5)
  ];
  static const List<Color> neutralColors3 = [
    Color(0xffd1c3be),
    Color(0xffd9d0ba),
    Color(0xffeadbab),
    Color(0xffcdccab),
    Color(0xffc4cfd8)
  ];

  static const List<Color> badgeColors = [
    Color(0xff093145),
    Color(0xff107896),
    Color(0xff829356),
    Color(0xffbca136),
    Color(0xffc2571a),
    Color(0xff9a2617),

    Color(0xff0c374d),
    Color(0xff1287a8),
    Color(0xff93a661),
    Color(0xffd3b53d),
    Color(0xffda621e),
    Color(0xffad2a1a),
  ];
}
