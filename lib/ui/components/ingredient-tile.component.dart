import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// To be used for for indication wether user owns it or not
class IngredientTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;
  bool userOwns;
  bool onShoppingList;
  VoidCallback onTap;

  // when used userOwns onShoppingList and onTap are ignored and this
  // item is displayed in stock
  bool ignoreInStock;

  IngredientTileComponent(
      {Key key,
      this.ingredient,
      this.apiToken,
      this.textColor = Colors.white,
      this.radius = 46.0,
      this.userOwns = true,
      this.onShoppingList = false,
      this.onTap,
      this.ignoreInStock = false})
      : super(key: key);

  @override
  _IngredientTileComponentState createState() => _IngredientTileComponentState(
      ingredient: ingredient,
      apiToken: apiToken,
      textColor: textColor,
      radius: radius,
      userOwns: userOwns,
      onShoppingList: onShoppingList,
      ignoreInStock: ignoreInStock);
}

class _IngredientTileComponentState extends State<IngredientTileComponent> {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;
  bool userOwns;
  bool onShoppingList;
  bool ignoreInStock;

  _IngredientTileComponentState(
      {this.ingredient,
      this.apiToken,
      this.textColor,
      this.radius,
      this.userOwns,
      this.onShoppingList,
      this.ignoreInStock});

  @override
  Widget build(BuildContext context) {
    print("ignoreinStock: $ignoreInStock");
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        color: Colors.transparent,
        child: Column(children: [
          Stack(children: [
            Container(
                decoration: onShoppingList && !ignoreInStock
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow,
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      )
                    : userOwns || ignoreInStock
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
                                color: Colors.transparent,
                                blurRadius: 4,
                                spreadRadius: 2,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                          ),
                child: InkWell(
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        ingredient.imgSrc,
                        imageRenderMethodForWeb:
                            ImageRenderMethodForWeb.HttpGet),
                    backgroundColor: Colors.black87,
                    radius: radius,
                  ),
                  // ignore tap when item has ignored flag set
                  onTap: ignoreInStock ? () {} : widget.onTap,
                  splashColor: Colors.white,
                )),
            onShoppingList && !ignoreInStock
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: FaIcon(
                      FontAwesomeIcons.cartPlus,
                      color: Colors.yellow,
                      size: 26,
                    ))
                : userOwns || ignoreInStock
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
          // bit of extra space to compensate for the blur
          SizedBox(
            height: 4,
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

// to be used for recipe creation only
class IngredientEditTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;
  Color textColor;
  double radius;
  VoidCallback onTap;

  IngredientEditTileComponent(
      {Key key,
      this.ingredient,
      this.apiToken,
      this.textColor = Colors.white,
      this.radius = 46.0,
      this.onTap})
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
          InkWell(
            child: Material(
              borderRadius: BorderRadius.circular(44),
              elevation: 6,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(ingredient.imgSrc,
                    imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
                backgroundColor: Colors.teal,
                radius: radius,
              ),
            ),
            onTap: widget.onTap,
          ),
          Text(
            ingredient.name +
                "\n" +
                Utility.getFormattedAmountForIngredient(ingredient),
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ]));
  }
}
