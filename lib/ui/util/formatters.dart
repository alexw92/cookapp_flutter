import 'package:cookable_flutter/core/data/models.dart';
import 'package:fraction/fraction.dart';

class Utility {
  static String getFormattedAmount(UserFoodProduct userFoodProduct) {
    if (userFoodProduct.quantityUnit.value == QuantityUnit.PICES) {
      return "${_getFormattedFraction(userFoodProduct.amount)} ${userFoodProduct.quantityUnit.toString()}";
    } else if (userFoodProduct.quantityUnit.value == QuantityUnit.MILLILITER ||
        userFoodProduct.quantityUnit.value == QuantityUnit.GRAM) {
      return "${toWholeNumberStringIfPossible(userFoodProduct.amount)} ${userFoodProduct.quantityUnit.toString()}";
    } else
      return "${userFoodProduct.amount} ${userFoodProduct.quantityUnit.toString()}";
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

  static String toWholeNumberStringIfPossible(num value) {
    if (value.isInt) return (value).round().toString();
    return (value).toString();
  }
}

extension on num {
  bool get isInt => this % 1 == 0;
}
