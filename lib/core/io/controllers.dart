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
        .get(Uri.parse("${IOConfig.apiUrl}/recipes"), headers: {
      "Authorization": "Bearer $storedToken",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      'Content-Type': 'application/json',
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
        .get(Uri.parse("${IOConfig.apiUrl}/foodProducts"), headers: {
      "Authorization": "Bearer $storedToken",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      'Content-Type': 'application/json',
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

class UserFoodProductController {
  static Future<List<UserFoodProduct>> getUserFoodProducts() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response = await http
        .get(Uri.parse("${IOConfig.apiUrl}/userFood"), headers: {
      "Authorization": "Bearer $storedToken",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(response.body) as List;
      List<UserFoodProduct> userFoodProducts =
      list.map((it) => UserFoodProduct.fromJson(it)).toList();
      return userFoodProducts;
    }

    throw Exception(
        "Error requesting user food products, Code: ${response.statusCode} Message: ${response.body} ");
  }
}
