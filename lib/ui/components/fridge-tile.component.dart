import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/io-config.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FridgeTileComponent extends StatefulWidget {
  UserFoodProduct userFoodProduct;
  String apiToken;
  FridgeTileComponent({Key key, this.userFoodProduct, this.apiToken}) : super(key: key);

  @override
  _FridgeTileComponentState createState() =>
      _FridgeTileComponentState(userFoodProduct: userFoodProduct, apiToken: apiToken);
}

class _FridgeTileComponentState extends State<FridgeTileComponent> {
  UserFoodProduct userFoodProduct;
  String apiToken;
  _FridgeTileComponentState({this.userFoodProduct, this.apiToken});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              "${IOConfig.apiUrl}${userFoodProduct.imgSrc}",
              headers: {"Authorization": "Bearer $apiToken"}
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
