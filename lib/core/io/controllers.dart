import 'dart:convert';
import 'dart:io';

import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class RecipeController {

  static Future<List<Recipe>> getRecipes() async {
    // todo this is just for testing, needs to be refactored
    // get token from firebase
    final tokenStore = TokenStore();
    var user = FirebaseAuth.instance.currentUser;
    String token = await user.getIdToken();
    // save token in token store
    tokenStore.putToken(user.uid, token);
    // get token from token store
    String storedToken = await tokenStore.getToken(user.uid);
    var response =
        await http.get(Uri.parse("http://192.168.2.102:8080/recipes"),headers: {"Authorization": "Bearer $storedToken"});

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(response.body) as List;
      List<Recipe> recipes = list.map((it) => Recipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception("Error retrieving recipes, Code: ${response.statusCode} Message: ${response.body} ");
  }
}

class FoodProductController {
  static Future<List<FoodProduct>> getFoodProducts() async {
    var response =
        await http.get(Uri.parse("http://192.168.2.102:8080/foodProducts"));

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(response.body) as List;
      List<FoodProduct> foodProducts =
      list.map((it) => FoodProduct.fromJson(it)).toList();
      return foodProducts;
    }

    throw Exception("Error retrieving foodProducts, Code: ${response.statusCode} Message: ${response.body} ");
  }
}
