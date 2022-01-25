import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 9)
class ReducedUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String displayName;
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
  final Nutrients nutrients;
  @HiveField(10)
  final int numberMissingIngredients;

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
      this.nutrients,
      this.numberMissingIngredients});

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
        diet: Diet.values[recipeJson['dietIdentifier'] as int],
        prepTimeMinutes: recipeJson['prepTimeMinutes'],
        nutrients: Nutrients.fromJson(recipeJson['nutrientsData']),
        numberMissingIngredients: recipeJson['numberMissingIngredients']);
  }

  String toString() {
    return "id=$id, name=$name, ingredients=${ingredients.length} ";
  }
}

@HiveType(typeId: 8)
class PrivateRecipe {
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
        diet: Diet.values[recipeJson['dietIdentifier'] as int],
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

  DefaultNutrients(
      {this.id,
      this.recDailyFat,
      this.recDailySaturatedFat,
      this.recDailyCarbohydrate,
      this.recDailySugar,
      this.recDailyProtein,
      this.recDailyCalories,
      this.source});

  factory DefaultNutrients.fromJson(Map<String, dynamic> json) {
    return DefaultNutrients(
        id: json['id'],
        recDailyFat: json['recDailyFat'],
        recDailySaturatedFat: json['recDailySaturatedFat'],
        recDailyCarbohydrate: json['recDailyCarbohydrate'],
        recDailySugar: json['recDailySugar'],
        recDailyProtein: json['recDailyProtein'],
        recDailyCalories: json['recDailyCalories'],
        source: json['source']);
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

class FoodProduct {
  final int id;
  final String name;
  final String description;
  final QuantityUnit quantityType;
  final int foodCategoryId;
  final String foodCategory;
  final String imgSrc;
  final Nutrients nutrients;

  FoodProduct(
      {this.id,
      this.name,
      this.description,
      this.quantityType,
      this.foodCategoryId,
      this.foodCategory,
      this.imgSrc,
      this.nutrients});

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    return FoodProduct(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        quantityType: QuantityUnit.fromInt(json['quantityUnit']),
        foodCategoryId: json['foodCategoryId'],
        foodCategory: json['foodCategory'],
        imgSrc: json['img_src'],
        nutrients: Nutrients.fromJson(json['nutrients']));
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

  String toString(){
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
  PESCATARIAN,
  @HiveField(2)
  VEGETARIAN,
  @HiveField(3)
  NORMAL
}

enum NutritionType { CALORIES, CARBOHYDRATE, FAT, PROTEIN, SUGAR }

class UserDataEdit {
  final String displayName;

  UserDataEdit({this.displayName});

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
      };
}
