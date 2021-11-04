import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NutrientTileComponent extends StatefulWidget {
  String nutrientName;
  double nutrientAmount;
  double dailyRecAmount;
  bool isCalories = false;

  NutrientTileComponent({Key key, this.nutrientName, this.nutrientAmount, this.dailyRecAmount, this.isCalories})
      : super(key: key);

  @override
  _NutrientTileComponentState createState() =>
      _NutrientTileComponentState(nutrientName: nutrientName, nutrientAmount: nutrientAmount,
          dailyRecAmount: dailyRecAmount, isCalories: isCalories);
}

class _NutrientTileComponentState extends State<NutrientTileComponent> {
  String nutrientName;
  double nutrientAmount;
  double dailyRecAmount;
  bool isCalories;

  _NutrientTileComponentState({this.nutrientName, this.nutrientAmount, this.dailyRecAmount, this.isCalories});

  @override
  Widget build(BuildContext context) {
    return new CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 5.0,
      animation: true,
      percent: nutrientAmount/dailyRecAmount,
      center: new Text(
        "${isCalories?nutrientAmount.toInt():nutrientAmount} ${isCalories?"kcal":"g"}",
        style:
        new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10.0),
      ),
      footer: new Text(
        nutrientName,
        style:
        new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.blue,
    );
  }
}