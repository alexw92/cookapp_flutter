import 'dart:math';

import 'package:cookable_flutter/core/data/models.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NutrientTileComponent extends StatefulWidget {
  String nutrientName;
  double nutrientAmount;
  double dailyRecAmount;
  NutritionType nutritionType;
  Color textColor;

  static Color getNutitionColor(NutritionType nutrition) {
    Color retColor;
    switch (nutrition) {
      case NutritionType.CALORIES:
        retColor = Colors.amberAccent;
        break;
      case NutritionType.PROTEIN:
        retColor = Colors.tealAccent;
        break;
      case NutritionType.CARBOHYDRATE:
        retColor = Colors.deepOrangeAccent;
        break;
      case NutritionType.FAT:
        retColor = Colors.cyanAccent;
        break;
    }
    return retColor;
  }

  NutrientTileComponent(
      {Key key,
      this.nutrientName,
      this.nutrientAmount,
      this.dailyRecAmount,
      this.nutritionType,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  _NutrientTileComponentState createState() => _NutrientTileComponentState(
      nutrientName: nutrientName,
      nutrientAmount: nutrientAmount,
      dailyRecAmount: dailyRecAmount,
      nutritionType: nutritionType,
      textColor: textColor);
}

class _NutrientTileComponentState extends State<NutrientTileComponent> {
  String nutrientName;
  double nutrientAmount;
  double dailyRecAmount;
  NutritionType nutritionType;
  Color textColor;

  _NutrientTileComponentState(
      {this.nutrientName,
      this.nutrientAmount,
      this.dailyRecAmount,
      this.nutritionType,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return new CircularPercentIndicator(
      radius: 78.0,
      lineWidth: 4.0,
      backgroundWidth: 2.0,
      animation: true,
      percent: min(1.0, (nutrientAmount.round()) / dailyRecAmount),
      center: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        new Text(
          nutrientName,
          style: new TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 12.0),
        ),
        new Text(
            nutrientAmount.toInt().toString() +
                ((nutritionType != NutritionType.CALORIES) ? "g" : ""),
            style: new TextStyle(
                fontWeight: FontWeight.normal,
                color: NutrientTileComponent.getNutitionColor(nutritionType),
                fontSize: 28.0)),
      ]),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: NutrientTileComponent.getNutitionColor(nutritionType),
    );
  }
}
