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
