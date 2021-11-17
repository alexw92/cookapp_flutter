class Recipe {
  final int id;
  final String imgSrc;
  final String name;
  final String uploadedBy;
  final List<RecipeInstruction> instructions;
  final List<Ingredient> ingredients;
  final int numberOfPersons;
  final Diet diet;
  final int prepTimeMinutes;


  Recipe(
      {this.id,
      this.imgSrc,
      this.name,
      this.uploadedBy,
      this.instructions,
      this.ingredients,
      this.numberOfPersons,
      this.diet,
      this.prepTimeMinutes});

  factory Recipe.fromJson(Map<String, dynamic> recipeJson) {
    return Recipe(
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
        numberOfPersons: recipeJson['numberOfPersons'],
        diet: Diet.values[recipeJson['dietIdentifier'] as int],
        prepTimeMinutes: recipeJson['prepTimeMinutes']);
  }

  String toString(){
    return "id=$id, name=$name, ingredients=${ingredients.length} ";
  }
}

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
      this.prepTimeMinutes});

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
        prepTimeMinutes: recipeJson['prepTimeMinutes']);
  }
}

class RecipeInstruction {
  final int id;
  final int recipeId;
  final int step;
  final String instructionsText;

  RecipeInstruction({this.id, this.recipeId, this.step, this.instructionsText});

  factory RecipeInstruction.fromJson(Map<String, dynamic> json) {
    return RecipeInstruction(
        id: json['id'],
        recipeId: json['recipeId'],
        step: json['step'],
        instructionsText: json['instructionsText']);
  }
}

class DefaultNutrients {
  final int id;
  final double recDailyFat;
  final double recDailySaturatedFat;
  final double recDailyCarbohydrate;
  final double recDailySugar;
  final double recDailyProtein;
  final int recDailyCalories;
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

class Ingredient {
  final int id;
  final String name;
  int amount;
  final int recipeId;
  final int foodProductId;
  final String imgSrc;
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
}

class FoodProduct {
  final int id;
  final String name;
  final String description;
  final QuantityUnit quantityType;
  final int foodCategoryId;
  final String imgSrc;
  final Nutrients nutrients;

  FoodProduct(
      {this.id,
      this.name,
      this.description,
      this.quantityType,
      this.foodCategoryId,
      this.imgSrc,
      this.nutrients});

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    return FoodProduct(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        quantityType: QuantityUnit.fromInt(json['quantityUnit']),
        foodCategoryId: json['foodCategoryId'],
        imgSrc: json['img_src'],
        nutrients: Nutrients.fromJson(json['nutrients']));
  }
}

class UserFoodProduct {
  final int foodProductId;
  final String name;
  final double amount;
  final String description;
  final QuantityUnit quantityUnit;
  final String imgSrc;
  final Nutrients nutrients;
  final FoodCategory foodCategory;

  UserFoodProduct(
      {this.foodProductId,
      this.name,
      this.amount,
      this.description,
      this.quantityUnit,
      this.imgSrc,
      this.nutrients,
      this.foodCategory});

  factory UserFoodProduct.fromJson(Map<String, dynamic> json) {
    return UserFoodProduct(
        foodProductId: json['foodProductId'],
        name: json['name'],
        amount: json['amount'],
        description: json['description'],
        quantityUnit: QuantityUnit.fromInt(json['quantityUnit']),
        imgSrc: json['img_src'],
        nutrients: Nutrients.fromJson(json['nutrientsData']),
        foodCategory: FoodCategory.fromJson(json['foodCategoryData']));
  }
}

class QuantityUnit {
  static const MILLILITER = 0;
  static const GRAM = 1;
  static const PIECES = 2;

  static get values => [MILLILITER, GRAM, PIECES];
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

class FoodCategory {
  final int id;
  final String name;
  final String iconURL;

  FoodCategory({this.id, this.name, this.iconURL});

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return FoodCategory(
        id: json['id'], name: json['name'], iconURL: json['iconURL']);
  }
}

class Nutrients {
  final int id;
  final double fat;
  final double carbohydrate;
  final double sugar;
  final double protein;
  final int calories;
  final String source;
  final DateTime dateOfRetrieval;

  Nutrients(
      {this.id,
      this.fat,
      this.carbohydrate,
      this.sugar,
      this.protein,
      this.calories,
      this.source,
      this.dateOfRetrieval});

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
        dateOfRetrieval: DateTime.parse(json['dateOfRetrieval']));
  }
}

enum Diet { VEGAN, PESCATARIAN, VEGETARIAN, NORMAL }

enum NutritionType { CALORIES, CARBOHYDRATE, FAT, PROTEIN, SUGAR }
