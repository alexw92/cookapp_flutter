import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;

  IngredientTileComponent(
      {Key key, this.ingredient, this.apiToken, this.textColor = Colors.white, this.radius = 46.0})
      : super(key: key);

  @override
  _IngredientTileComponentState createState() => _IngredientTileComponentState(
      ingredient: ingredient, apiToken: apiToken, textColor: textColor, radius: radius);
}

class _IngredientTileComponentState extends State<IngredientTileComponent> {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;

  _IngredientTileComponentState(
      {this.ingredient, this.apiToken, this.textColor, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:5, bottom:5),
        color: Colors.transparent,
        child: Column(children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(ingredient.imgSrc,
                imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
            // backgroundColor: Colors.transparent,
            radius: radius,
          ),
          Text(
            ingredient.name,
            style: TextStyle(color: textColor),
          ),
          Text(
            Utility.getFormattedAmountForIngredient(ingredient),
            style: TextStyle(
              color: textColor,
            ),
          )
        ]));
  }
}
