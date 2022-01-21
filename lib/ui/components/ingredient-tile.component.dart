import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// To be used for for indication wether user owns it or not
class IngredientTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;
  bool userOwns;

  IngredientTileComponent(
      {Key key,
      this.ingredient,
      this.apiToken,
      this.textColor = Colors.white,
      this.radius = 46.0,
      this.userOwns = true})
      : super(key: key);

  @override
  _IngredientTileComponentState createState() => _IngredientTileComponentState(
      ingredient: ingredient,
      apiToken: apiToken,
      textColor: textColor,
      radius: radius,
      userOwns: userOwns);
}

class _IngredientTileComponentState extends State<IngredientTileComponent> {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;
  bool userOwns;

  _IngredientTileComponentState(
      {this.ingredient,
      this.apiToken,
      this.textColor,
      this.radius,
      this.userOwns});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        color: Colors.transparent,
        child: Column(children: [
          Stack(children: [
            Container(
                decoration: userOwns
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green,
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      )
                    : BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(ingredient.imgSrc,
                      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
                  backgroundColor: Colors.black87,
                  radius: radius,
                )),
            userOwns
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: FaIcon(
                      FontAwesomeIcons.check,
                      color: Colors.lightGreen,
                      size: 26,
                    ))
                : Positioned(
                    bottom: 0,
                    right: 0,
                    child: FaIcon(
                      FontAwesomeIcons.times,
                      color: Colors.redAccent,
                      size: 26,
                    ))
          ]),
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

// to be used for recipe creation only
class IngredientEditTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;

  IngredientEditTileComponent(
      {Key key,
      this.ingredient,
      this.apiToken,
      this.textColor = Colors.white,
      this.radius = 46.0})
      : super(key: key);

  @override
  _IngredientEditTileComponentState createState() =>
      _IngredientEditTileComponentState(
          ingredient: ingredient,
          apiToken: apiToken,
          textColor: textColor,
          radius: radius);
}

class _IngredientEditTileComponentState
    extends State<IngredientEditTileComponent> {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;

  _IngredientEditTileComponentState(
      {this.ingredient, this.apiToken, this.textColor, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
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
