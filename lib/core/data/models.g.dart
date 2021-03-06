// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReducedUserAdapter extends TypeAdapter<ReducedUser> {
  @override
  final int typeId = 9;

  @override
  ReducedUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReducedUser(
      id: fields[0] as String,
      displayName: fields[1] as String,
      providerPhoto: fields[2] as String,
      fbUploadedPhoto: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReducedUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.providerPhoto)
      ..writeByte(3)
      ..write(obj.fbUploadedPhoto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReducedUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      id: fields[0] as int,
      imgSrc: fields[1] as String,
      name: fields[2] as String,
      uploadedBy: fields[3] as ReducedUser,
      instructions: (fields[4] as List)?.cast<RecipeInstruction>(),
      ingredients: (fields[5] as List)?.cast<Ingredient>(),
      numberOfPersons: fields[6] as int,
      diet: fields[7] as Diet,
      prepTimeMinutes: fields[8] as int,
      nutrients: fields[9] as Nutrients,
    )
      ..missingUserFoodProducts = (fields[10] as List)?.cast<UserFoodProduct>()
      ..userLiked = fields[11] as bool
      ..likes = fields[12] as int;
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imgSrc)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.uploadedBy)
      ..writeByte(4)
      ..write(obj.instructions)
      ..writeByte(5)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.numberOfPersons)
      ..writeByte(7)
      ..write(obj.diet)
      ..writeByte(8)
      ..write(obj.prepTimeMinutes)
      ..writeByte(9)
      ..write(obj.nutrients)
      ..writeByte(10)
      ..write(obj.missingUserFoodProducts)
      ..writeByte(11)
      ..write(obj.userLiked)
      ..writeByte(12)
      ..write(obj.likes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TotalRecipeLikesAdapter extends TypeAdapter<TotalRecipeLikes> {
  @override
  final int typeId = 12;

  @override
  TotalRecipeLikes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TotalRecipeLikes(
      recipeId: fields[0] as int,
      likes: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TotalRecipeLikes obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.recipeId)
      ..writeByte(1)
      ..write(obj.likes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TotalRecipeLikesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRecipeLikeAdapter extends TypeAdapter<UserRecipeLike> {
  @override
  final int typeId = 13;

  @override
  UserRecipeLike read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRecipeLike(
      recipeId: fields[0] as int,
      userId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserRecipeLike obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.recipeId)
      ..writeByte(1)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRecipeLikeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrivateRecipeAdapter extends TypeAdapter<PrivateRecipe> {
  @override
  final int typeId = 8;

  @override
  PrivateRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrivateRecipe(
      id: fields[0] as int,
      imgSrc: fields[1] as String,
      name: fields[2] as String,
      uploadedBy: fields[3] as ReducedUser,
      instructions: (fields[4] as List)?.cast<RecipeInstruction>(),
      ingredients: (fields[5] as List)?.cast<Ingredient>(),
      nutrients: fields[6] as Nutrients,
      numberOfPersons: fields[7] as int,
      diet: fields[8] as Diet,
      prepTimeMinutes: fields[9] as int,
      isPublishable: fields[10] as bool,
      created: fields[11] as DateTime,
      lastChange: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PrivateRecipe obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imgSrc)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.uploadedBy)
      ..writeByte(4)
      ..write(obj.instructions)
      ..writeByte(5)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.nutrients)
      ..writeByte(7)
      ..write(obj.numberOfPersons)
      ..writeByte(8)
      ..write(obj.diet)
      ..writeByte(9)
      ..write(obj.prepTimeMinutes)
      ..writeByte(10)
      ..write(obj.isPublishable)
      ..writeByte(11)
      ..write(obj.created)
      ..writeByte(12)
      ..write(obj.lastChange);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrivateRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipeInstructionAdapter extends TypeAdapter<RecipeInstruction> {
  @override
  final int typeId = 1;

  @override
  RecipeInstruction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeInstruction(
      id: fields[0] as int,
      recipeId: fields[1] as int,
      step: fields[2] as int,
      instructionsText: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeInstruction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recipeId)
      ..writeByte(2)
      ..write(obj.step)
      ..writeByte(3)
      ..write(obj.instructionsText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeInstructionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DefaultNutrientsAdapter extends TypeAdapter<DefaultNutrients> {
  @override
  final int typeId = 10;

  @override
  DefaultNutrients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DefaultNutrients(
      id: fields[0] as int,
      recDailyFat: fields[1] as double,
      recDailySaturatedFat: fields[2] as double,
      recDailyCarbohydrate: fields[3] as double,
      recDailySugar: fields[4] as double,
      recDailyProtein: fields[5] as double,
      recDailyCalories: fields[6] as int,
      source: fields[7] as String,
      caloriesPerGramCarb: fields[8] as int,
      caloriesPerGramFat: fields[9] as int,
      caloriesPerGramProtein: fields[10] as int,
      caloriesThresholdHighCarb: fields[11] as double,
      caloriesThresholdHighProtein: fields[12] as double,
      changed: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DefaultNutrients obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recDailyFat)
      ..writeByte(2)
      ..write(obj.recDailySaturatedFat)
      ..writeByte(3)
      ..write(obj.recDailyCarbohydrate)
      ..writeByte(4)
      ..write(obj.recDailySugar)
      ..writeByte(5)
      ..write(obj.recDailyProtein)
      ..writeByte(6)
      ..write(obj.recDailyCalories)
      ..writeByte(7)
      ..write(obj.source)
      ..writeByte(8)
      ..write(obj.caloriesPerGramCarb)
      ..writeByte(9)
      ..write(obj.caloriesPerGramFat)
      ..writeByte(10)
      ..write(obj.caloriesPerGramProtein)
      ..writeByte(11)
      ..write(obj.caloriesThresholdHighCarb)
      ..writeByte(12)
      ..write(obj.caloriesThresholdHighProtein)
      ..writeByte(13)
      ..write(obj.changed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultNutrientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IngredientAdapter extends TypeAdapter<Ingredient> {
  @override
  final int typeId = 2;

  @override
  Ingredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ingredient(
      id: fields[0] as int,
      name: fields[1] as String,
      amount: fields[2] as double,
      recipeId: fields[3] as int,
      foodProductId: fields[4] as int,
      imgSrc: fields[5] as String,
      quantityType: fields[6] as QuantityUnit,
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.recipeId)
      ..writeByte(4)
      ..write(obj.foodProductId)
      ..writeByte(5)
      ..write(obj.imgSrc)
      ..writeByte(6)
      ..write(obj.quantityType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodProductAdapter extends TypeAdapter<FoodProduct> {
  @override
  final int typeId = 11;

  @override
  FoodProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodProduct(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      quantityType: fields[3] as QuantityUnit,
      gramPerPiece: fields[4] as int,
      foodCategoryId: fields[5] as int,
      foodCategory: fields[6] as String,
      imgSrc: fields[7] as String,
      nutrients: fields[8] as Nutrients,
      inStockIsIgnored: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FoodProduct obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.quantityType)
      ..writeByte(4)
      ..write(obj.gramPerPiece)
      ..writeByte(5)
      ..write(obj.foodCategoryId)
      ..writeByte(6)
      ..write(obj.foodCategory)
      ..writeByte(7)
      ..write(obj.imgSrc)
      ..writeByte(8)
      ..write(obj.nutrients)
      ..writeByte(9)
      ..write(obj.inStockIsIgnored);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserFoodProductAdapter extends TypeAdapter<UserFoodProduct> {
  @override
  final int typeId = 6;

  @override
  UserFoodProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserFoodProduct(
      foodProductId: fields[0] as int,
      name: fields[1] as String,
      amount: fields[2] as double,
      description: fields[3] as String,
      quantityUnit: fields[4] as QuantityUnit,
      imgSrc: fields[5] as String,
      nutrients: fields[6] as Nutrients,
      foodCategory: fields[7] as FoodCategory,
      onShoppingList: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserFoodProduct obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.foodProductId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.quantityUnit)
      ..writeByte(5)
      ..write(obj.imgSrc)
      ..writeByte(6)
      ..write(obj.nutrients)
      ..writeByte(7)
      ..write(obj.foodCategory)
      ..writeByte(8)
      ..write(obj.onShoppingList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserFoodProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuantityUnitAdapter extends TypeAdapter<QuantityUnit> {
  @override
  final int typeId = 3;

  @override
  QuantityUnit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuantityUnit(
      fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, QuantityUnit obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuantityUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodCategoryAdapter extends TypeAdapter<FoodCategory> {
  @override
  final int typeId = 7;

  @override
  FoodCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodCategory(
      id: fields[0] as int,
      name: fields[1] as String,
      iconURL: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FoodCategory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NutrientsAdapter extends TypeAdapter<Nutrients> {
  @override
  final int typeId = 5;

  @override
  Nutrients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nutrients(
      id: fields[0] as int,
      fat: fields[1] as double,
      carbohydrate: fields[2] as double,
      sugar: fields[3] as double,
      protein: fields[4] as double,
      calories: fields[5] as int,
      source: fields[6] as String,
      dateOfRetrieval: fields[7] as DateTime,
      isHighProteinRecipe: fields[8] as bool,
      isHighCarbRecipe: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Nutrients obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fat)
      ..writeByte(2)
      ..write(obj.carbohydrate)
      ..writeByte(3)
      ..write(obj.sugar)
      ..writeByte(4)
      ..write(obj.protein)
      ..writeByte(5)
      ..write(obj.calories)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.dateOfRetrieval)
      ..writeByte(8)
      ..write(obj.isHighProteinRecipe)
      ..writeByte(9)
      ..write(obj.isHighCarbRecipe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutrientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DietAdapter extends TypeAdapter<Diet> {
  @override
  final int typeId = 4;

  @override
  Diet read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Diet.VEGAN;
      case 1:
        return Diet.VEGETARIAN;
      case 2:
        return Diet.PESCATARIAN;
      case 3:
        return Diet.NORMAL;
      default:
        return Diet.VEGAN;
    }
  }

  @override
  void write(BinaryWriter writer, Diet obj) {
    switch (obj) {
      case Diet.VEGAN:
        writer.writeByte(0);
        break;
      case Diet.VEGETARIAN:
        writer.writeByte(1);
        break;
      case Diet.PESCATARIAN:
        writer.writeByte(2);
        break;
      case Diet.NORMAL:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
