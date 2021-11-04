import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;

  IngredientTileComponent({Key key, this.ingredient, this.apiToken})
      : super(key: key);

  @override
  _IngredientTileComponentState createState() =>
      _IngredientTileComponentState(ingredient: ingredient, apiToken: apiToken);
}

class _IngredientTileComponentState extends State<IngredientTileComponent> {
  Ingredient ingredient;
  String apiToken;

  _IngredientTileComponentState({this.ingredient, this.apiToken});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 20,
        color: Colors.black,
        child: Column( children:[CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(ingredient.imgSrc,
              imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
          // backgroundColor: Colors.transparent,
          radius: 35,
        ),
          Text(ingredient.name,style: TextStyle(color: Colors.white),),
          Text(ingredient.amount.toString()+" ${ingredient.quantityType}",style: TextStyle(color: Colors.white,),)
        ])
    );
  }
}
