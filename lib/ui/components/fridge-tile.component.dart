import 'package:cookable_flutter/core/models/ingredient.model.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FridgeTileComponent extends StatefulWidget {
  Ingredient ingredient;
  FridgeTileComponent({Key key, this.ingredient}) : super(key: key);

  @override
  _FridgeTileComponentState createState() =>
      _FridgeTileComponentState(ingredient: ingredient);
}

class _FridgeTileComponentState extends State<FridgeTileComponent> {
  Ingredient ingredient;
  _FridgeTileComponentState({this.ingredient});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(ingredient.imagePath),
            // backgroundColor: Colors.transparent,
            backgroundColor: CookableTheme.darkGrey,
            radius: 40,
          ),
          Text(
            ingredient.title,
            style: CookableTheme.smallWhiteFont,
          ),
          Text(
            ingredient.quantity.toString() + ' ' + ingredient.unit,
            style: CookableTheme.smallWhiteFont,
          ),
        ],
      ),
    );
  }
}
