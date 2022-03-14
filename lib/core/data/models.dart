import 'package:hive/hive.dart';

part 'models.g.dart';

Diet parseDiet(int dietId) {
  var diet = Diet.VEGAN;
  switch (dietId) {
    case 0:
      diet = Diet.VEGAN;
      break;
    case 2:
      diet = Diet.VEGETARIAN;
      break;
  }
  return diet;
}

PublishRecipeRequestStatus parsePublishRecipeRequestStatus(int statusValue) {
  var status = PublishRecipeRequestStatus.NOT_REQUESTED;
  switch (statusValue) {
    case 0:
      status = PublishRecipeRequestStatus.PENDING;
      break;
    case 1:
      status = PublishRecipeRequestStatus.APPROVED;
      break;
    case 2:
      status = PublishRecipeRequestStatus.DENIED;
      break;
    case 3:
      status = PublishRecipeRequestStatus.NOT_REQUESTED;
      break;
  }
  return status;
}

@HiveType(typeId: 9)
class ReducedUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String displayName;
  @HiveField(2)
  final String providerPhoto;
  @HiveField(3)
  final String fbUploadedPhoto;

  ReducedUser(
      {this.id, this.displayName, this.providerPhoto, this.fbUploadedPhoto});

  factory ReducedUser.fromJson(Map<String, dynamic> userJson) {
    return ReducedUser(
        id: userJson['id'],
        displayName: userJson['displayName'],
        providerPhoto: userJson['providerPhoto'],
        fbUploadedPhoto: userJson['fbUploadedPhoto']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'providerPhoto': providerPhoto,
      'fbUploadedPhoto': fbUploadedPhoto,
    };
  }

  String toString() {
    return "id=$id, displayName=$displayName, providerPhoto=$providerPhoto, fbUploadedPhoto=$fbUploadedPhoto  ";
  }
}

@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String imgSrc;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final ReducedUser uploadedBy;
  @HiveField(4)
  final List<RecipeInstruction> instructions;
  @HiveField(5)
  final List<Ingredient> ingredients;
  @HiveField(6)
  final int numberOfPersons;
  @HiveField(7)
  final Diet diet;
  @HiveField(8)
  final int prepTimeMinutes;
  @HiveField(9)
  Nutrients nutrients;
  @HiveField(10)
  List<UserFoodProduct> missingUserFoodProducts = [];
  @HiveField(11)
  bool userLiked;
  @HiveField(12)
  int likes;

  Recipe(
      {this.id,
      this.imgSrc,
      this.name,
      this.uploadedBy,
      this.instructions,
      this.ingredients,
      this.numberOfPersons,
      this.diet,
      this.prepTimeMinutes,
      this.nutrients});

  factory Recipe.fromJson(Map<String, dynamic> recipeJson) {
    return Recipe(
        id: recipeJson['id'],
        imgSrc: recipeJson['img_src'],
        name: recipeJson['name'],
        uploadedBy: recipeJson['uploadedBy'] == null
            ? null
            : ReducedUser.fromJson(recipeJson['uploadedBy']),
        instructions: (recipeJson['instructions'] as List)
            .map((it) => RecipeInstruction.fromJson(it))
            .toList(),
        ingredients: (recipeJson['ingredients'] as List)
            .map((it) => Ingredient.fromJson(it))
            .toList(),
        numberOfPersons: recipeJson['numberOfPersons'],
        diet: parseDiet(recipeJson['dietIdentifier'] as int),
        prepTimeMinutes: recipeJson['prepTimeMinutes'],
        nutrients: Nutrients.fromJson(recipeJson['nutrientsData']));
  }

  String toString() {
    return "id=$id, name=$name, ingredients=${ingredients.length} likes=$likes";
  }
}

@HiveType(typeId: 12)
class TotalRecipeLikes {
  @HiveField(0)
  final int recipeId;
  @HiveField(1)
  final int likes;

  TotalRecipeLikes({this.recipeId, this.likes});

  factory TotalRecipeLikes.fromJson(Map<String, dynamic> totalRecipeLikesJson) {
    return TotalRecipeLikes(
        recipeId: totalRecipeLikesJson['recipeId'],
        likes: totalRecipeLikesJson['likes']);
  }

  String toString() {
    return "recipeId=$recipeId, likes=$likes";
  }
}

@HiveType(typeId: 13)
class UserRecipeLike {
  @HiveField(0)
  final int recipeId;
  @HiveField(1)
  final String userId;

  UserRecipeLike({this.recipeId, this.userId});

  factory UserRecipeLike.fromJson(Map<String, dynamic> userRecipeLikeJson) {
    return UserRecipeLike(
        recipeId: userRecipeLikeJson['recipeId'],
        userId: userRecipeLikeJson['userId']);
  }

  String toString() {
    return "recipeId=$recipeId, userId=$userId";
  }
}

@HiveType(typeId: 8)
class PrivateRecipe {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String imgSrc;
  @HiveField(2)
  String name;
  @HiveField(3)
  final ReducedUser uploadedBy;
  @HiveField(4)
  final List<RecipeInstruction> instructions;
  @HiveField(5)
  final List<Ingredient> ingredients;
  @HiveField(6)
  final Nutrients nutrients;
  @HiveField(7)
  final int numberOfPersons;
  @HiveField(8)
  final Diet diet;
  @HiveField(9)
  final int prepTimeMinutes;
  @HiveField(10)
  final bool isPublishable;

  PrivateRecipe(
      {this.id,
      this.imgSrc,
      this.name,
      this.uploadedBy,
      this.instructions,
      this.ingredients,
      this.nutrients,
      this.numberOfPersons,
      this.diet,
      this.prepTimeMinutes,
      this.isPublishable});

  factory PrivateRecipe.fromJson(Map<String, dynamic> recipeJson) {
    return PrivateRecipe(
        id: recipeJson['id'],
        imgSrc: recipeJson['img_src'],
        name: recipeJson['name'],
        uploadedBy: ReducedUser.fromJson(recipeJson['uploadedBy']),
        instructions: (recipeJson['instructions'] as List)
            .map((it) => RecipeInstruction.fromJson(it))
            .toList(),
        ingredients: (recipeJson['ingredients'] as List)
            .map((it) => Ingredient.fromJson(it))
            .toList(),
        nutrients: Nutrients.fromJson(recipeJson['nutrientsData']),
        numberOfPersons: recipeJson['numberOfPersons'],
        diet: parseDiet(recipeJson['dietIdentifier'] as int),
        prepTimeMinutes: recipeJson['prepTimeMinutes'],
        isPublishable: recipeJson['isPublishable'] as bool);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'img_src': imgSrc,
        'name': name,
        'uploadedBy': uploadedBy.toJson(),
        'instructions': instructions.map((instr) => instr.toJson()).toList(),
        'ingredients': ingredients.map((ingr) => ingr.toJson()).toList(),
        'numberOfPersons': numberOfPersons,
        'dietIdentifier': diet.index,
        'prepTimeMinutes': prepTimeMinutes,
        'isPublishable': isPublishable,
      };

  String toString() {
    return "private-recipe, id=$id, name=$name, ingredients=${ingredients.length}, imgSrc=$imgSrc, uploadedBy=${uploadedBy.toString()} ";
  }
}

class PublishPrivateRecipeRequest {
  final int id;
  final int privateRecipeId;
  final PublishRecipeRequestStatus status;
  final DateTime statusChangedDate;
  final ReducedUser statusChangedByAdmin;

  PublishPrivateRecipeRequest(
      {this.id,
      this.privateRecipeId,
      this.status,
      this.statusChangedDate,
      this.statusChangedByAdmin});

  factory PublishPrivateRecipeRequest.fromJson(Map<String, dynamic> json) {
    print(json);
    return PublishPrivateRecipeRequest(
        id: json['id'],
        privateRecipeId: json['privateRecipeId'] as int,
        status: parsePublishRecipeRequestStatus(json['status'] as int),
        statusChangedDate: DateTime.parse(json['statusChangedDate']),
        statusChangedByAdmin: json['statusChangedByAdmin'] != null
            ? ReducedUser.fromJson(json['statusChangedByAdmin'])
            : null);
  }
}

class PrivateRecipePublishableStatus {
  final PrivateRecipe privateRecipe;
  final int constraintMinIngredients;
  final int constraintMinInstructions;
  final int constraintRecipeNameMaxLength;
  final PublishRecipeRequestStatus status;
  final bool constraintMinIngredientsFulfilled;
  final bool constraintMinInstructionsFulfilled;
  final bool constraintRecipeNameMaxLengthFulfilled;
  final bool constraintHasImageFulfilled;

  PrivateRecipePublishableStatus(
      {this.privateRecipe,
      this.constraintMinIngredients,
      this.constraintMinInstructions,
      this.constraintRecipeNameMaxLength,
      this.constraintMinIngredientsFulfilled,
      this.constraintMinInstructionsFulfilled,
      this.constraintRecipeNameMaxLengthFulfilled,
      this.constraintHasImageFulfilled,
      this.status});

  bool constraintsFulfilled() {
    return constraintHasImageFulfilled &&
        constraintMinIngredientsFulfilled &&
        constraintMinInstructionsFulfilled &&
        constraintRecipeNameMaxLengthFulfilled;
  }

  factory PrivateRecipePublishableStatus.fromJson(Map<String, dynamic> json) {
    return PrivateRecipePublishableStatus(
        privateRecipe: PrivateRecipe.fromJson(json['privateRecipeData']),
        constraintMinIngredients: json['constraintMinIngredients'],
        constraintMinInstructions: json['constraintMinInstructions'],
        constraintRecipeNameMaxLength: json['constraintRecipeNameMaxLength'],
        status: parsePublishRecipeRequestStatus(json['status'] as int),
        constraintMinIngredientsFulfilled:
            json['constraintMinIngredientsFulfilled'] as bool,
        constraintMinInstructionsFulfilled:
            json['constraintMinInstructionsFulfilled'] as bool,
        constraintRecipeNameMaxLengthFulfilled:
            json['constraintRecipeNameMaxLengthFulfilled'] as bool,
        constraintHasImageFulfilled:
            json['constraintHasImageFulfilled'] as bool);
  }

  Map<String, dynamic> toJson() => {
        'privateRecipe': privateRecipe.toJson(),
        'constraintMinIngredients': constraintMinIngredients,
        'constraintMinInstructions': constraintMinInstructions,
        'constraintRecipeNameMaxLength': constraintRecipeNameMaxLength,
        'status': status.index
      };
}

// val id: Long,
// val img_src: String?,
// val name: String,
// val instructions: List<RecipeInstructionData>,
// val ingredients: List<IngredientData>,
// val uploadedBy: String,
// val numberOfPersons: Int,
// val dietIdentifier: DietIdentifier,
// val nutrientsData: NutrientsData?,
// val publishedRecipe: RecipeData?,
// var prepTimeMinutes: Int,
// val isPublishable: Boolean

class RecipeDetails {
  final int id;
  final String imgSrc;
  final String name;
  final String uploadedBy;
  final List<RecipeInstruction> instructions;
  final List<Ingredient> ingredients;
  final int numberOfPersons;
  final Nutrients nutrients;
  final Diet diet;
  final int prepTimeMinutes;
  bool userLiked;
  int likes;

  RecipeDetails(
      {this.id,
      this.imgSrc,
      this.name,
      this.uploadedBy,
      this.instructions,
      this.ingredients,
      this.numberOfPersons,
      this.nutrients,
      this.diet,
      this.prepTimeMinutes,
      this.userLiked,
      this.likes});

  factory RecipeDetails.fromJson(Map<String, dynamic> recipeJson) {
    return RecipeDetails(
        id: recipeJson['id'],
        imgSrc: recipeJson['img_src'],
        name: recipeJson['name'],
        uploadedBy: recipeJson['uploadedBy'],
        instructions: (recipeJson['instructions'] as List)
            .map((it) => RecipeInstruction.fromJson(it))
            .toList(),
        ingredients: (recipeJson['ingredients'] as List)
            .map((it) => Ingredient.fromJson(it))
            .toList(),
        nutrients: Nutrients.fromJson(recipeJson['nutrientsData']),
        numberOfPersons: recipeJson['numberOfPersons'],
        diet: Diet.values[recipeJson['dietIdentifier'] as int],
        prepTimeMinutes: recipeJson['prepTimeMinutes'],
        userLiked: recipeJson['userLiked'],
        likes: recipeJson['likes']);
  }
}

@HiveType(typeId: 1)
class RecipeInstruction {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int recipeId;
  @HiveField(2)
  int step;
  @HiveField(3)
  final String instructionsText;

  RecipeInstruction({this.id, this.recipeId, this.step, this.instructionsText});

  factory RecipeInstruction.fromJson(Map<String, dynamic> json) {
    return RecipeInstruction(
        id: json['id'],
        recipeId: json['recipeId'],
        step: json['step'],
        instructionsText: json['instructionsText']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "recipeId": recipeId,
        "step": step,
        "instructionsText": instructionsText
      };
}

@HiveType(typeId: 10)
class DefaultNutrients {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final double recDailyFat;
  @HiveField(2)
  final double recDailySaturatedFat;
  @HiveField(3)
  final double recDailyCarbohydrate;
  @HiveField(4)
  final double recDailySugar;
  @HiveField(5)
  final double recDailyProtein;
  @HiveField(6)
  final int recDailyCalories;
  @HiveField(7)
  final String source;
  @HiveField(8)
  final int caloriesPerGramCarb;
  @HiveField(9)
  final int caloriesPerGramFat;
  @HiveField(10)
  final int caloriesPerGramProtein;
  @HiveField(11)
  final double caloriesThresholdHighCarb;
  @HiveField(12)
  final double caloriesThresholdHighProtein;
  @HiveField(13)
  final DateTime changed;

  DefaultNutrients(
      {this.id,
      this.recDailyFat,
      this.recDailySaturatedFat,
      this.recDailyCarbohydrate,
      this.recDailySugar,
      this.recDailyProtein,
      this.recDailyCalories,
      this.source,
      this.caloriesPerGramCarb,
      this.caloriesPerGramFat,
      this.caloriesPerGramProtein,
      this.caloriesThresholdHighCarb,
      this.caloriesThresholdHighProtein,
      this.changed});

  factory DefaultNutrients.fromJson(Map<String, dynamic> json) {
    return DefaultNutrients(
        id: json['id'],
        recDailyFat: json['recDailyFat'],
        recDailySaturatedFat: json['recDailySaturatedFat'],
        recDailyCarbohydrate: json['recDailyCarbohydrate'],
        recDailySugar: json['recDailySugar'],
        recDailyProtein: json['recDailyProtein'],
        recDailyCalories: json['recDailyCalories'],
        source: json['source'],
        caloriesPerGramCarb: json['caloriesPerGramCarb'],
        caloriesPerGramFat: json['caloriesPerGramFat'],
        caloriesPerGramProtein: json['caloriesPerGramProtein'],
        caloriesThresholdHighCarb: json['caloriesThresholdHighCarb'],
        caloriesThresholdHighProtein: json['caloriesThresholdHighProtein'],
        changed: DateTime.parse(json['changed']));
  }
}

@HiveType(typeId: 2)
class Ingredient {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  double amount;
  @HiveField(3)
  final int recipeId;
  @HiveField(4)
  final int foodProductId;
  @HiveField(5)
  final String imgSrc;
  @HiveField(6)
  final QuantityUnit quantityType;

  Ingredient(
      {this.id,
      this.name,
      this.amount,
      this.recipeId,
      this.foodProductId,
      this.imgSrc,
      this.quantityType});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      recipeId: json['recipeId'],
      foodProductId: json['foodProductId'],
      imgSrc: json['img_src'],
      quantityType: QuantityUnit.fromInt(json['quantityType']),
    );
  }

  Ingredient clone() {
    return Ingredient(
        id: this.id,
        name: this.name,
        amount: this.amount,
        recipeId: this.recipeId,
        foodProductId: this.foodProductId,
        imgSrc: this.imgSrc,
        quantityType: this.quantityType);
  }

  String toString() {
    return "Ingredient: $name, amount=$amount";
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "recipeId": recipeId,
        "foodProductId": foodProductId,
        "imgSrc": imgSrc,
        "quantityType": quantityType.value,
      };
}

@HiveType(typeId: 11)
class FoodProduct {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final QuantityUnit quantityType;
  @HiveField(4)
  final int gramPerPiece;
  @HiveField(5)
  final int foodCategoryId;
  @HiveField(6)
  final String foodCategory;
  @HiveField(7)
  final String imgSrc;
  @HiveField(8)
  final Nutrients nutrients;
  @HiveField(9)
  final bool inStockIsIgnored;

  FoodProduct(
      {this.id,
      this.name,
      this.description,
      this.quantityType,
      this.gramPerPiece,
      this.foodCategoryId,
      this.foodCategory,
      this.imgSrc,
      this.nutrients,
      this.inStockIsIgnored});

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    return FoodProduct(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        quantityType: QuantityUnit.fromInt(json['quantityUnit']),
        gramPerPiece: json['gramPerPiece'],
        foodCategoryId: json['foodCategoryId'],
        foodCategory: json['foodCategory'],
        imgSrc: json['img_src'],
        nutrients: Nutrients.fromJson(json['nutrientsData']),
        inStockIsIgnored: json['inStockIsIgnored']);
  }
}

@HiveType(typeId: 6)
class UserFoodProduct {
  @HiveField(0)
  final int foodProductId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final QuantityUnit quantityUnit;
  @HiveField(5)
  final String imgSrc;
  @HiveField(6)
  final Nutrients nutrients;
  @HiveField(7)
  final FoodCategory foodCategory;
  @HiveField(8)
  bool onShoppingList;

  UserFoodProduct(
      {this.foodProductId,
      this.name,
      this.amount,
      this.description,
      this.quantityUnit,
      this.imgSrc,
      this.nutrients,
      this.foodCategory,
      this.onShoppingList});

  factory UserFoodProduct.fromJson(Map<String, dynamic> json) {
    return UserFoodProduct(
        foodProductId: json['foodProductId'],
        name: json['name'],
        amount: json['amount'],
        description: json['description'],
        quantityUnit: QuantityUnit.fromInt(json['quantityUnit']),
        imgSrc: json['img_src'],
        nutrients: Nutrients.fromJson(json['nutrientsData']),
        foodCategory: FoodCategory.fromJson(json['foodCategoryData']),
        onShoppingList: json['onShoppingList']);
  }

  String toString() {
    return "foodProductId:$foodProductId, name:$name onShoppingList:$onShoppingList";
  }
}

@HiveType(typeId: 3)
class QuantityUnit {
  static const MILLILITER = 0;
  static const GRAM = 1;
  static const PIECES = 2;

  static get values => [MILLILITER, GRAM, PIECES];
  @HiveField(0)
  final int value;

  factory QuantityUnit.fromInt(int quantityType) {
    var result;
    switch (quantityType) {
      case MILLILITER:
        result = QuantityUnit(MILLILITER);
        break;
      case GRAM:
        result = QuantityUnit(GRAM);
        break;
      case PIECES:
        result = QuantityUnit(PIECES);
        break;
      default:
        result = null;
    }
    return result;
  }

  @override
  String toString() {
    var result;
    switch (value) {
      case MILLILITER:
        result = "ml";
        break;
      case GRAM:
        result = "g";
        break;
      case PIECES:
        result = "pc";
        break;
      default:
        result = null;
    }
    return result;
  }

  const QuantityUnit(this.value);
}

@HiveType(typeId: 7)
class FoodCategory {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String iconURL;

  FoodCategory({this.id, this.name, this.iconURL});

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return FoodCategory(
        id: json['id'], name: json['name'], iconURL: json['iconURL']);
  }
}

@HiveType(typeId: 5)
class Nutrients {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final double fat;
  @HiveField(2)
  final double carbohydrate;
  @HiveField(3)
  final double sugar;
  @HiveField(4)
  final double protein;
  @HiveField(5)
  final int calories;
  @HiveField(6)
  final String source;
  @HiveField(7)
  final DateTime dateOfRetrieval;
  @HiveField(8)
  final bool isHighProteinRecipe;
  @HiveField(9)
  final bool isHighCarbRecipe;

  Nutrients(
      {this.id,
      this.fat,
      this.carbohydrate,
      this.sugar,
      this.protein,
      this.calories,
      this.source,
      this.dateOfRetrieval,
      this.isHighProteinRecipe,
      this.isHighCarbRecipe});

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Nutrients(
        id: json['id'],
        fat: json['fat'],
        carbohydrate: json['carbohydrate'],
        sugar: json['sugar'],
        protein: json['protein'],
        calories: json['calories'],
        source: json['source'],
        dateOfRetrieval: DateTime.parse(json['dateOfRetrieval']),
        isHighProteinRecipe: json['isHighProteinRecipe'],
        isHighCarbRecipe: json['isHighCarbRecipe']);
  }
}

@HiveType(typeId: 4)
enum Diet {
  @HiveField(0)
  VEGAN,
  @HiveField(1)
  VEGETARIAN,
  @HiveField(2)
  PESCATARIAN,
  @HiveField(3)
  NORMAL
}

enum PublishRecipeRequestStatus { PENDING, APPROVED, DENIED, NOT_REQUESTED }

enum NutritionType { CALORIES, CARBOHYDRATE, FAT, PROTEIN, SUGAR }

class UserDataEdit {
  final String displayName;

  UserDataEdit({this.displayName});

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
      };
}
