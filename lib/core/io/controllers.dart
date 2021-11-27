import 'dart:convert';
import 'dart:io';

import 'package:cookable_flutter/common/LangState.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:http/http.dart' as http;

import 'io-config.dart';

class RecipeController {

  // public getDefaultNutrients(): Observable<DefaultNutrients>  {
  // return this.httpService.get('/constants/defaultNutrients', {responseType: 'text'}).pipe(map(res => JSON.parse(res)));
  // }
  static Future<DefaultNutrients> getDefaultNutrients() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response =
    await http.get(Uri.parse("${IOConfig.apiUrl}/constants/defaultNutrients"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      DefaultNutrients defaultNutrients =  DefaultNutrients.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      return defaultNutrients;
    }
  }

  static Future<List<Recipe>> getRecipes() async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response =
        await http.get(Uri.parse("${IOConfig.apiUrl}/recipes/all?langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(utf8.decode(response.bodyBytes)) as List;
      List<Recipe> recipes = list.map((it) => Recipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.body} ");
  }

  static Future<List<Recipe>> getFilteredRecipes(Diet diet, bool highProteinFilter, bool highCarbFilter) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    Uri queryParams  = Uri(queryParameters: {
      'dietIdentifier': diet.index.toString(),
      'highProteinOnly': highProteinFilter.toString(),
      'highCarbOnly': highCarbFilter.toString()});
    var response =
    await http.get(Uri.parse("${IOConfig.apiUrl}/recipes?"+queryParams.query+"&langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json'
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(utf8.decode(response.bodyBytes)) as List;
      List<Recipe> recipes = list.map((it) => Recipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.body} ");
  }


  static Future<RecipeDetails> getRecipe(int id) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response =
    await http.get(Uri.parse("${IOConfig.apiUrl}/recipes/$id?langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = json.decode(utf8.decode(response.bodyBytes));
      RecipeDetails recipe = RecipeDetails.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.body} ");
  }

  static Future<PrivateRecipe> getPrivateRecipe(int id) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response =
    await http.get(Uri.parse("${IOConfig.apiUrl}/privaterecipes/$id?langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = json.decode(utf8.decode(response.bodyBytes));
      PrivateRecipe recipe = PrivateRecipe.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.body} ");
  }

  static Future<List<PrivateRecipe>> getPrivateRecipes() async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response =
    await http.get(Uri.parse("${IOConfig.apiUrl}/privaterecipes/all?langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(utf8.decode(response.bodyBytes)) as List;
      List<PrivateRecipe> recipes = list.map((it) => PrivateRecipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception(
        "Error requesting private recipes, Code: ${response.statusCode} Message: ${response.body} ");
  }

  static Future<PrivateRecipe> createPrivateRecipe(String recipeName) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    var body = json.encode({
      "name": recipeName
    });
    var response =
    await http.post(Uri.parse("${IOConfig.apiUrl}/privaterecipes/add"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }, body: body).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = json.decode(utf8.decode(response.bodyBytes));
      PrivateRecipe recipe = PrivateRecipe.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error creating private recipe, Code: ${response.statusCode} Message: ${response.body} ");
  }

  // @PutMapping
  // fun updatePrivateRecipe(@RequestBody privateRecipeData: PrivateRecipeData): PrivateRecipeData

  static Future<PrivateRecipe> updatePrivateRecipe(PrivateRecipe privateRecipe) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    var body = json.encode(privateRecipe.toJson());
    var response =
    await http.put(Uri.parse("${IOConfig.apiUrl}/privaterecipes?langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }, body: body).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = json.decode(utf8.decode(response.bodyBytes));
      PrivateRecipe recipe = PrivateRecipe.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error updating private recipe, Code: ${response.statusCode} Message: ${response.body} ");
  }
}

class FoodProductController {
  static Future<List<FoodProduct>> getFoodProducts() async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    var response =
        await http.get(Uri.parse("${IOConfig.apiUrl}/foodProducts?langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(utf8.decode(response.bodyBytes)) as List;
      List<FoodProduct> foodProducts =
          list.map((it) => FoodProduct.fromJson(it)).toList();
      return foodProducts;
    }

    throw Exception(
        "Error requesting food products, Code: ${response.statusCode} Message: ${response.body} ");
  }
}

class UserFoodProductController {
  static Future<List<UserFoodProduct>> getUserFoodProducts(
      bool missingFodProducts) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    var endpoint = missingFodProducts ? "/missing" : "";
    var response = await http
        .get(Uri.parse("${IOConfig.apiUrl}/userFood$endpoint?langCode=$langCode"), headers: {
      "Authorization": "Bearer $storedToken",
      'Content-Type': 'application/json',
    }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = json.decode(utf8.decode(response.bodyBytes)) as List;
      List<UserFoodProduct> userFoodProducts =
          list.map((it) => UserFoodProduct.fromJson(it)).toList();
      return userFoodProducts;
    }

    throw Exception(
        "Error requesting user food products, Code: ${response.statusCode} Message: ${response.body} ");
  }

  static Future<void> toogleUserFoodProduct(
      int foodProductId, bool addFoodProduct) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    var response = await http.post(
      Uri.parse(
          "${IOConfig.apiUrl}/userFood/update?foodProductId=$foodProductId&isAdded=$addFoodProduct"),
      headers: {
        "Authorization": "Bearer $storedToken",
        'Content-Type': 'application/json',
      },
    ).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      return;
    }

    throw Exception(
        "Error requesting user food products, Code: ${response.statusCode} Message: ${response.body} ");
  }
}
