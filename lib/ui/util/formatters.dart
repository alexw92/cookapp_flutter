import 'package:cookable_flutter/core/data/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fraction/fraction.dart';

class Utility {
  static String getFormattedAmountFor(UserFoodProduct userFoodProduct) {
    if (userFoodProduct.quantityUnit.value == QuantityUnit.PIECES) {
      return "${_getFormattedFraction(userFoodProduct.amount)} ${userFoodProduct.quantityUnit.toString()}";
    } else if (userFoodProduct.quantityUnit.value == QuantityUnit.MILLILITER ||
        userFoodProduct.quantityUnit.value == QuantityUnit.GRAM) {
      return "${toWholeNumberStringIfPossible(userFoodProduct.amount, true)} ${userFoodProduct.quantityUnit.toString()}";
    } else
      return "${userFoodProduct.amount} ${userFoodProduct.quantityUnit.toString()}";
  }

  static String getFormattedAmountForIngredient(Ingredient ingredient) {
    if (ingredient.quantityType.value == QuantityUnit.PIECES) {
      return "${_getFormattedFraction(ingredient.amount)} ${ingredient.quantityType.toString()}";
    } else if (ingredient.quantityType.value == QuantityUnit.MILLILITER ||
        ingredient.quantityType.value == QuantityUnit.GRAM) {
      return "${toWholeNumberStringIfPossible(ingredient.amount, true)} ${ingredient.quantityType.toString()}";
    } else
      return "${ingredient.amount} ${ingredient.quantityType.toString()}";
  }

  static String getTranslatedDiet(BuildContext context, Diet diet) {
    String retDiet;
    switch (diet) {
      case Diet.NORMAL:
        retDiet = AppLocalizations.of(context).normal;
        break;
      case Diet.VEGETARIAN:
        retDiet = AppLocalizations.of(context).vegetarian;
        break;
      case Diet.VEGAN:
        retDiet = AppLocalizations.of(context).vegan;
        break;
      case Diet.PESCATARIAN:
        retDiet = AppLocalizations.of(context).pescatarian;
        break;
    }
    return retDiet;
  }

  static String getTranslatedNutritionDiet(BuildContext context, NutritionDiet diet) {
    String retDiet;
    switch (diet) {
      case NutritionDiet.HIGH_PROTEIN:
        retDiet = AppLocalizations.of(context).highProtein;
        break;
      case NutritionDiet.HIGH_CARBS:
        retDiet = AppLocalizations.of(context).highCarb;
        break;
    }
    return retDiet;
  }

  static String getTranslatedFoodCategory(
      BuildContext context, String foodCategory) {
    String retCat = AppLocalizations.of(context).unknownFoodCategory;
    foodCategory = foodCategory.toLowerCase();
    if (foodCategory.contains("fruits")) {
      retCat = AppLocalizations.of(context).tab_fruits;
    } else if (foodCategory.contains("vegetables")) {
      retCat = AppLocalizations.of(context).tab_vegetables;
    } else if (foodCategory.contains("spices")) {
      retCat = AppLocalizations.of(context).tab_spices;
    } else if (foodCategory.contains("pantry")) {
      retCat = AppLocalizations.of(context).tab_pantry;
    } else if (foodCategory.contains("dairy")) {
      retCat = AppLocalizations.of(context).tab_dairy;
    } else if (foodCategory.contains("meat")) {
      retCat = AppLocalizations.of(context).tab_meat;
    } else if (foodCategory.contains("fish")) {
      retCat = AppLocalizations.of(context).tab_fish;
    }

    return retCat;
  }

  static Widget getIconForDiet(Diet diet) {
    Widget retIcon;
    switch (diet) {
      case Diet.NORMAL:
        retIcon = Icon(Icons.lunch_dining, color: Colors.red);
        break;
      case Diet.VEGETARIAN:
        retIcon = Icon(Icons.eco_outlined, color: Colors.green);
        break;
      case Diet.VEGAN:
        retIcon = Icon(Icons.eco_outlined, color: Colors.green);
        break;
      case Diet.PESCATARIAN:
        retIcon = Icon(Icons.sailing, color: Colors.blue);
        break;
    }
    return retIcon;
  }

  static Widget getIconForNutritionDiet(NutritionDiet diet) {
    Widget retIcon;
    switch (diet) {//fitness_center directions_bike
      case NutritionDiet.HIGH_PROTEIN:
        retIcon = Icon(Icons.fitness_center, color: Colors.black);
        break;
      case NutritionDiet.HIGH_CARBS:
        retIcon = Icon(Icons.directions_bike, color: Colors.black);
        break;
    }
    return retIcon;
  }

  static String _getFormattedFraction(double amount) {
    String formattedFraction;
    String fractionPart;
    int whole;
    if (amount == 1)
      return "${amount.round()}";
    else if (amount > 1) {
      whole = MixedFraction.fromFraction(Fraction.fromDouble(amount)).whole;
      fractionPart = Fraction.fromDouble(amount - whole).toString();
    } else {
      fractionPart = Fraction.fromDouble(amount).toString();
      whole = 0;
    }
    switch (fractionPart) {
      case "1/2":
        formattedFraction = "½";
        break;
      case "1/3":
        formattedFraction = "⅓";
        break;
      case "2/3":
        formattedFraction = "⅔";
        break;
      case "1/4":
        formattedFraction = "¼";
        break;
      case "3/4":
        formattedFraction = "¾";
        break;
      case "1/5":
        formattedFraction = "⅕";
        break;
      case "2/5":
        formattedFraction = "⅖";
        break;
      case "3/5":
        formattedFraction = "⅗";
        break;
      case "4/5":
        formattedFraction = "⅘";
        break;
      case "1/8":
        formattedFraction = "⅛";
        break;
      case "3/8":
        formattedFraction = "⅜";
        break;
      case "5/8":
        formattedFraction = "⅝";
        break;
      case "7/8":
        formattedFraction = "⅞";
        break;
      case "1/10":
        formattedFraction = "⅒";
        break;
      default:
        formattedFraction = fractionPart;
    }
    if (whole > 0) {
      if (fractionPart == "0") // if fraction part was 0
        return "$whole";
      else
        return "$whole $formattedFraction";
    } else
      return "$formattedFraction";
  }

  static String toWholeNumberStringIfPossible(num value, bool isGramOrMl) {
    if (value.isInt) return (value).round().toString();
    // gram or ml is always rounded
    return value.round().toString();
    return (value).toString();
  }
}

extension on num {
  bool get isInt => this % 1 == 0;
}
