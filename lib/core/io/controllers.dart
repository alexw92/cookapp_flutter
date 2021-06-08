import 'dart:io';
import 'dart:convert';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:http/http.dart' as http;

class RecipeController {
  static Future<List<Recipe>> getRecipes() async {
    var response =
        await http.get(Uri.parse("http://192.168.2.102:8080/recipes"));

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      //  print(response);
    }

    print("lol");
    var list = json.decode(response.body) as List;
    List<Recipe> recipes = list.map((it) => Recipe.fromJson(it)).toList();
    print("List contains ${list.length} recipes.");
    return recipes;
  }
}
