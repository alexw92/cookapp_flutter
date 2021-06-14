import 'dart:convert';
import 'dart:io';

import 'package:cookable_flutter/core/data/models.dart';
import 'package:http/http.dart' as http;

import 'io-config.dart';

class RecipeController {
  static Future<List<Recipe>> getRecipes() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response = await http
        .get(Uri.parse("http://192.168.2.102:8080/recipes"), headers: {
      "Authorization": "Bearer $storedToken"
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(response.body) as List;
      List<Recipe> recipes = list.map((it) => Recipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.body} ");
  }
}

class FoodProductController {
  static Future<List<FoodProduct>> getFoodProducts() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response = await http
        .get(Uri.parse("http://192.168.2.102:8080/foodProducts"), headers: {
      "Authorization": "Bearer $storedToken"
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(response.body) as List;
      List<FoodProduct> foodProducts =
          list.map((it) => FoodProduct.fromJson(it)).toList();
      return foodProducts;
    }

    throw Exception(
        "Error requesting food products, Code: ${response.statusCode} Message: ${response.body} ");
  }
}
