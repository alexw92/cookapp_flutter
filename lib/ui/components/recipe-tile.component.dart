import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/io-config.dart';
import 'package:cookable_flutter/ui/styles/cookable-theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeTileComponent extends StatefulWidget {
  Recipe recipe;
  String apiToken;

  RecipeTileComponent({Key key, this.recipe, this.apiToken}) : super(key: key);

  @override
  _RecipeTileComponentState createState() =>
      _RecipeTileComponentState(recipe: recipe, apiToken: apiToken);
}

class _RecipeTileComponentState extends State<RecipeTileComponent> {
  Recipe recipe;
  String apiToken;

  _RecipeTileComponentState({this.recipe, this.apiToken});

  @override
  Widget build(BuildContext context) {
    return Card(
        //padding: new EdgeInsets.all(20.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Stack(
        children: [
          Image(
            // needs --web-renderer html
            image:
                CachedNetworkImageProvider("${IOConfig.apiUrl}${recipe.imgSrc}",
                    headers: {
                      "Authorization": "Bearer $apiToken",
                      "Access-Control-Allow-Headers":
                          "Access-Control-Allow-Origin, Accept"
                    },
                    imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
            width: 300,
            height: 250,
            // backgroundColor: Colors.transparent,
            //  radius: 40,
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                recipe.name,
                style: CookableTheme.noramlBlackFont,
              )),

          // removed amount from api
          // Text(
          //   "${Utility.getFormattedAmount(userFoodProduct)}",
          //   style: CookableTheme.smallWhiteFont,
          // ),
        ],
      ),
      Expanded(
        flex: 2,
          child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.orange,
      )),
    ]));
  }
}
