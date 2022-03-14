import 'dart:convert';
import 'dart:io';

import 'package:cookable_flutter/common/LangState.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'io-config.dart';

class RecipeController {
  static Future<DefaultNutrients> getDefaultNutrients() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/constants/defaultNutrients");
    print(
        'getDefaultNutrients api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      DefaultNutrients defaultNutrients =
          DefaultNutrients.fromJson(response.data);
      return defaultNutrients;
    }
  }

  static Future<int> toggleRecipeLike(int recipeId) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    var response = await dio
        .post("/likes/recipes/$recipeId")
        .timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var updatedRecipeLikes = response.data as int;
      return updatedRecipeLikes;
    }

    throw Exception(
        "Error toggling like recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<List<UserRecipeLike>> getUserRecipeLikes() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    var response =
        await dio.get("/likes/recipes/user").timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = response.data as List;
      List<UserRecipeLike> userRecipeLikes =
          list.map((it) => UserRecipeLike.fromJson(it)).toList();
      return userRecipeLikes;
    }

    throw Exception(
        "Error getting user recipe likes, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<List<TotalRecipeLikes>> getTotalRecipeLikes() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    var response =
        await dio.get("/likes/recipes").timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = response.data as List;
      List<TotalRecipeLikes> totalRecipeLikesList =
          list.map((it) => TotalRecipeLikes.fromJson(it)).toList();
      return totalRecipeLikesList;
    }

    throw Exception(
        "Error getting user recipe likes, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<List<Recipe>> getRecipes() async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    var response = await dio.get("/recipes/all?langCode=$langCode");

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = response.data as List;
      List<Recipe> recipes = list.map((it) => Recipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<List<Recipe>> getFilteredRecipes(
      Diet diet, bool highProteinFilter, bool highCarbFilter) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    var queryParameters = {
      'langCode': langCode,
      'dietIdentifier': diet.index.toString(),
      'highProteinOnly': highProteinFilter.toString(),
      'highCarbOnly': highCarbFilter.toString()
    };
    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/recipes", queryParameters: queryParameters);
    print(
        'getFilteredRecipes api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = response.data as List;
      List<Recipe> recipes = list.map((it) => Recipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<Recipe> getRecipe(int id) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/recipes/$id?langCode=$langCode");
    print('getRecipe api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = response.data;
      Recipe recipe = Recipe.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error requesting recipes, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<PrivateRecipe> getPrivateRecipe(int id) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/privaterecipes/$id?langCode=$langCode");
    print(
        'getPrivateRecipe api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = response.data;
      PrivateRecipe recipe = PrivateRecipe.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error requesting private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<PrivateRecipePublishableStatus> getPrivateRecipePublishable(
      int id) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response =
        await dio.get("/privaterecipes/$id/publishable?langCode=$langCode");
    print(
        'getPrivateRecipePublishable api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = response.data;
      PrivateRecipePublishableStatus publishableStatus =
          PrivateRecipePublishableStatus.fromJson(recipeJson);
      return publishableStatus;
    }

    throw Exception(
        "Error requesting publish status of private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<PublishPrivateRecipeRequest> publishPrivateRecipe(
      int id) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response =
        await dio.post("/privaterecipes/$id/publish?langCode=$langCode");
    print(
        'publish private recipe api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = response.data;
      PublishPrivateRecipeRequest publishRequest =
          PublishPrivateRecipeRequest.fromJson(recipeJson);
      return publishRequest;
    }

    throw Exception(
        "Error requesting publish status of private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<void> cancelPublishPrivateRecipe(
      int id) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response =
    await dio.post("/privaterecipes/$id/publish/cancel?langCode=$langCode");
    print(
        'cancel publish private recipe api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = response.data;
      return;
    }

    throw Exception(
        "Error cancelling publish request of private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<void> deletePrivateRecipe(int id) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.delete("/privaterecipes/$id");
    print(
        'deletePrivateRecipe api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      return;
    }

    throw Exception(
        "Error deleting private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<List<PrivateRecipe>> getPrivateRecipes() async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/privaterecipes/all?langCode=$langCode");
    print(
        'getPrivateRecipes api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = response.data as List;
      List<PrivateRecipe> recipes =
          list.map((it) => PrivateRecipe.fromJson(it)).toList();
      return recipes;
    }

    throw Exception(
        "Error requesting private recipes, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<PrivateRecipe> createPrivateRecipe(String recipeName) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    var body = json.encode({"name": recipeName});
    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    var response = await dio
        .post("/privaterecipes/add", data: body)
        .timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = response.data;
      PrivateRecipe recipe = PrivateRecipe.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error creating private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  // @PutMapping
  // fun updatePrivateRecipe(@RequestBody privateRecipeData: PrivateRecipeData): PrivateRecipeData

  static Future<PrivateRecipe> updatePrivateRecipe(
      PrivateRecipe privateRecipe) async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    var body = json.encode(privateRecipe.toJson());

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio
        .put("/privaterecipes?langCode=$langCode", data: body)
        .timeout(IOConfig.timeoutDuration);
    print(
        'updatePrivateRecipe api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var recipeJson = response.data;
      PrivateRecipe recipe = PrivateRecipe.fromJson(recipeJson);
      return recipe;
    }

    throw Exception(
        "Error updating private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

  // todo implement
  static Future<void> updatePrivateRecipeImage(
      PrivateRecipe privateRecipe, File image) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    String mimeType = mime(image.path);
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimee, type))
    });

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 10000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          "Content-Type": "multipart/form-data"
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio
        .post("/storage/privaterecipe/${privateRecipe.id}/image",
            data: formData)
        .timeout(IOConfig.timeoutDuration);
    print(
        'updatePrivateImg api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      return;
    }

    throw Exception(
        "Error updating private recipe image, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<void> changePrivateRecipeName(
      int privateRecipeId, String recipeName) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();
    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    var response = await dio.put("/privaterecipes/$privateRecipeId/name",
        queryParameters: {
          "name": recipeName
        }).timeout(IOConfig.timeoutDuration);

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      return;
    }

    throw Exception(
        "Error creating private recipe, Code: ${response.statusCode} Message: ${response.data} ");
  }

//   public updateRecipeImage(file: any, id: number): Observable<void>  {
//   const queryParamsList: { name: string, value: string }[] = [];
//   queryParamsList.push({name: 'file', value: file});
//   let params = new FormData();
//   for (const queryParam of queryParamsList) {
//   params.append(queryParam.name, queryParam.value);
//   }
//   return this.httpService.post<void>('/storage/recipe/' + id + '/image',params);
// }
}

class UserController {
  static Future<ReducedUser> getUser() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/user");
    print('getUser api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      ReducedUser reducedUser = ReducedUser.fromJson(response.data);
      return reducedUser;
    }

    throw Exception(
        "Error requesting user, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<ReducedUser> updateUserData(UserDataEdit userDataEdit) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });
    var body = json.encode(userDataEdit.toJson());
    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.put("/user", data: body);
    print(
        'updateUserData api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      ReducedUser reducedUser = ReducedUser.fromJson(response.data);
      return reducedUser;
    }

    throw Exception(
        "Error requesting user, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<void> updateProfileImage(File image) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    String mimeType = mime(image.path);
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimee, type))
    });

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 10000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          "Content-Type": "multipart/form-data"
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio
        .post("/storage/user/image", data: formData)
        .timeout(IOConfig.timeoutDuration);
    print(
        'updateProfileImage api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      return;
    }
    throw Exception(
        "Error updating private recipe image, Code: ${response.statusCode} Message: ${response.data} ");
  }

//
}

class FoodProductController {
  static Future<List<FoodProduct>> getFoodProducts() async {
    var langCode = LangState().currentLang;
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/foodProducts?langCode=$langCode");
    print(
        'getFoodProducts api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = response.data as List;
      List<FoodProduct> foodProducts =
          list.map((it) => FoodProduct.fromJson(it)).toList();
      return foodProducts;
    }

    throw Exception(
        "Error requesting food products, Code: ${response.statusCode} Message: ${response.data} ");
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

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });

    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.get("/userFood$endpoint?langCode=$langCode");
    print(
        'getUserFoodProducts $endpoint api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      var list = response.data as List;
      List<UserFoodProduct> userFoodProducts =
          list.map((it) => UserFoodProduct.fromJson(it)).toList();
      return userFoodProducts;
    }

    throw Exception(
        "Error requesting user food products, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<void> toggleUserFoodProduct(
      int foodProductId, bool addFoodProduct, bool toShoppingList) async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });
    var isAddedParam = addFoodProduct == null
        ? ""
        : addFoodProduct == true
            ? "&isAdded=true"
            : "&isAdded=false";
    var toShoppingListParam = toShoppingList == null
        ? ""
        : toShoppingList == true
            ? "&toShoppingList=true"
            : "&toShoppingList=false";
    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.post(
        "/userFood/update?foodProductId=$foodProductId$isAddedParam$toShoppingListParam");
    print(
        'toggleUserFoodProduct api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      return;
    }

    throw Exception(
        "Error toggling user food product, Code: ${response.statusCode} Message: ${response.data} ");
  }

  static Future<void> clearShoppingList() async {
    // get token from token store
    var tokenStore = IOConfig.tokenStore;
    String storedToken = await tokenStore.getToken();

    BaseOptions options = new BaseOptions(
        baseUrl: IOConfig.apiUrl,
        connectTimeout: 3000, //10 seconds
        receiveTimeout: 10000,
        headers: {
          "Authorization": "Bearer $storedToken",
          'Content-Type': 'application/json',
        });
    Dio dio = new Dio(options);
    final stopwatch = Stopwatch()..start();
    var response = await dio.post("/userFood/clearShoppingList");
    print(
        'clear shopping list api req executed in ${stopwatch.elapsed.inMilliseconds}');

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      return;
    }

    throw Exception(
        "Error clearing shopping list, Code: ${response.statusCode} Message: ${response.data} ");
  }
}
