import 'package:cookable_flutter/core/data/models.dart';
import 'package:fraction/fraction.dart';

class Utility {
  static String getFormattedAmount(UserFoodProduct userFoodProduct) {
    if (userFoodProduct.quantityUnit.value == QuantityUnit.PICES) {
      return "${_getFormattedFraction(userFoodProduct.amount)} ${userFoodProduct.quantityUnit.toString()}";
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
      case "1/4":
        formattedFraction = "¼";
        break;
      case "1/8":
        formattedFraction = "⅛";
        break;
      default:
        formattedFraction = fractionPart;
    }
    if (whole > 0)
      return "$whole $formattedFraction";
    else
      return "$formattedFraction";
  }
}
