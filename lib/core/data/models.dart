class Recipe {
  final int id;
  final String imgSrc;
  final String name;
  final String uploadedBy;
  final List<RecipeInstruction> instructions;
  final List<Ingredient> ingredients;

  Recipe(
      {this.id,
      this.imgSrc,
      this.name,
      this.uploadedBy,
      this.instructions,
      this.ingredients});

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
            .toList());
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

class Ingredient {
  final int id;
  final String name;
  final int amount;
  final int recipeId;
  final int foodProductId;

  Ingredient({
    this.id,
    this.name,
    this.amount,
    this.recipeId,
    this.foodProductId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        id: json['id'],
        name: json['name'],
        amount: json['amount'],
        recipeId: json['recipeId'],
        foodProductId: json['foodProductId']);
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

  UserFoodProduct(
      {this.foodProductId,
        this.name,
        this.amount,
        this.description,
        this.quantityUnit,
        this.imgSrc,
        this.nutrients});

  factory UserFoodProduct.fromJson(Map<String, dynamic> json) {
    return UserFoodProduct(
        foodProductId: json['foodProductId'],
        name: json['name'],
        amount: json['amount'],
        description: json['description'],
        quantityUnit: QuantityUnit.fromInt(json['quantityUnit']),
        imgSrc: json['img_src'],
        nutrients: Nutrients.fromJson(json['nutrients']));
  }
}

class QuantityUnit {
  static const MILLILITER = 1;
  static const GRAM = 2;
  static const PICES = 3;

  static get values => [MILLILITER, GRAM, PICES];
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
      case PICES:
        result = QuantityUnit(PICES);
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
      case PICES:
        result = "pc";
        break;
      default:
        result = null;
    }
    return result;
  }

  const QuantityUnit(this.value);
}

class Nutrients {
  final int id;
  final double fat;
  final double carbohydrate;
  final double sugar;
  final double protein;
  final double calories;
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
    if (json==null)
      return null;
    return Nutrients(
        id: json['id'],
        fat: json['fat'],
        carbohydrate: json['carbohydrate'],
        sugar: json['sugar'],
        protein: json['protein'],
        calories: json['calories'],
        source: json['source'],
        dateOfRetrieval: json['dateOfRetrieval']);
  }
}