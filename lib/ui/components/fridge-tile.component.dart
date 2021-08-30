import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/io-config.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FridgeTileComponent extends StatefulWidget {
  UserFoodProduct userFoodProduct;
  String apiToken;

  FridgeTileComponent({Key key, this.userFoodProduct, this.apiToken})
      : super(key: key);

  @override
  _FridgeTileComponentState createState() => _FridgeTileComponentState(
      userFoodProduct: userFoodProduct, apiToken: apiToken);
}

class _FridgeTileComponentState extends State<FridgeTileComponent> {
  UserFoodProduct userFoodProduct;
  String apiToken;

  _FridgeTileComponentState({this.userFoodProduct, this.apiToken});

  Color getGlowColorForFoodProduct(){
   // switch(userFoodProduct.)
    return Colors.red;
  }

  // glow https://stackoverflow.com/questions/56420822/how-to-add-a-neon-glow-effect-to-an-widget-border-shadow
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: CircleAvatar(
            // needs --web-renderer html
            backgroundImage: CachedNetworkImageProvider(
                "${IOConfig.apiUrl}${userFoodProduct.imgSrc}",
                headers: {
                  "Authorization": "Bearer $apiToken",
                  "Access-Control-Allow-Headers":
                      "Access-Control-Allow-Origin, Accept"
                },
                imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
            // backgroundColor: Colors.transparent,
            backgroundColor: CookableTheme.darkGrey,
            radius: 40,
          ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(
                  color: getGlowColorForFoodProduct(),
                  blurRadius: 8,
                  spreadRadius: 6,
                  offset: Offset(0, 0), // Shadow position
                ),
              ],
            ),
          ),
          Text(
            userFoodProduct.name,
            style: CookableTheme.smallWhiteFont,
          ),
          // removed amount from api
          // Text(
          //   "${Utility.getFormattedAmount(userFoodProduct)}",
          //   style: CookableTheme.smallWhiteFont,
          // ),
        ],
      ),
    );
  }
}
