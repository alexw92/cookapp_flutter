import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;
  Color textColor;

  IngredientTileComponent({Key key, this.ingredient, this.apiToken, this.textColor = Colors.white})
      : super(key: key);

  @override
  _IngredientTileComponentState createState() =>
      _IngredientTileComponentState(ingredient: ingredient, apiToken: apiToken, textColor: textColor);
}

class _IngredientTileComponentState extends State<IngredientTileComponent> {
  Ingredient ingredient;
  String apiToken;
  Color textColor;

  _IngredientTileComponentState({this.ingredient, this.apiToken, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 50,
        color: Colors.transparent,
        child: Column( children:[CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(ingredient.imgSrc,
              imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
          // backgroundColor: Colors.transparent,
          radius: 34,
        ),
          Text(ingredient.name,style: TextStyle(color: textColor),),
          Text(ingredient.amount.toString()+" ${ingredient.quantityType}",style: TextStyle(color: textColor,),)
        ])
    );
  }
}
