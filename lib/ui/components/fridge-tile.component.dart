import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/io-config.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FridgeTileComponent extends StatefulWidget {
  UserFoodProduct userFoodProduct;
  FridgeTileComponent({Key key, this.userFoodProduct}) : super(key: key);

  @override
  _FridgeTileComponentState createState() =>
      _FridgeTileComponentState(userFoodProduct: userFoodProduct);
}

class _FridgeTileComponentState extends State<FridgeTileComponent> {
  UserFoodProduct userFoodProduct;
  _FridgeTileComponentState({this.userFoodProduct});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              "${IOConfig.apiUrl}${userFoodProduct.imgSrc}"
            ),
            // backgroundColor: Colors.transparent,
            backgroundColor: CookableTheme.darkGrey,
            radius: 40,
          ),
          Text(
            userFoodProduct.name,
            style: CookableTheme.smallWhiteFont,
          ),
          Text(
            "${userFoodProduct.amount} ${userFoodProduct.quantityUnit.toString()}",
            style: CookableTheme.smallWhiteFont,
          ),
        ],
      ),
    );
  }
}
