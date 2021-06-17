import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FridgeTileComponent extends StatefulWidget {
  FoodProduct foodProduct;
  FridgeTileComponent({Key key, this.foodProduct}) : super(key: key);

  @override
  _FridgeTileComponentState createState() =>
      _FridgeTileComponentState(foodProduct: foodProduct);
}

class _FridgeTileComponentState extends State<FridgeTileComponent> {
  FoodProduct foodProduct;
  _FridgeTileComponentState({this.foodProduct});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              "http://192.168.2.102:8080${foodProduct.imgSrc}"
            ),
            // backgroundColor: Colors.transparent,
            backgroundColor: CookableTheme.darkGrey,
            radius: 40,
          ),
          Text(
            foodProduct.name,
            style: CookableTheme.smallWhiteFont,
          ),
          Text(
            "50" + " " + foodProduct.quantityType.toString(),
            style: CookableTheme.smallWhiteFont,
          ),
        ],
      ),
    );
  }
}
