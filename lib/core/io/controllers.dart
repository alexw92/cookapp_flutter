import 'dart:convert';
import 'dart:io';

import 'package:cookable_flutter/core/data/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'io-config.dart';

// todo: logic to get fresh fb token should be part of token store

class RecipeController {


  static Future<List<Recipe>> getRecipes() async {
    // get token from firebase

    var user = FirebaseAuth.instance.currentUser;
    String token = await user.getIdToken();
    var tokenStore = IOConfig.tokenStore;
    // save token in token store
    tokenStore.putToken(user.uid, token);
    // get token from token store
    String storedToken = await tokenStore.getToken(user.uid);
    var response = await http.get(
        Uri.parse("http://192.168.2.102:8080/recipes"),
        headers: {"Authorization": "Bearer $storedToken"}).timeout(Duration(seconds: 3));

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
    var user = FirebaseAuth.instance.currentUser;
    String token = await user.getIdToken();
    var tokenStore = IOConfig.tokenStore;
    // save token in token store
    tokenStore.putToken(user.uid, token);
    // get token from token store
    String storedToken = await tokenStore.getToken(user.uid);

    var response =
        await http.get(Uri.parse("http://192.168.2.102:8080/foodProducts")).timeout(Duration(seconds: 3));

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
