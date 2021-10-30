import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/pages/recipe-details-page.dart';
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
    return GestureDetector(
        onTap: () => navigateToRecipePage(recipe.id),
        child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,

          margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(0, 0, 0, 0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),

          child: Stack(
              fit:StackFit.expand,
              children: [
            Container(
                height: 300,
                width: 300,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), child:Image(
                    // needs --web-renderer html
                    image: CachedNetworkImageProvider(recipe.imgSrc,
                        imageRenderMethodForWeb:
                            ImageRenderMethodForWeb.HttpGet),
                    // backgroundColor: Colors.transparent,
                    //  radius: 40,
                  ),
                ))),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                width: 100,
                height: 50,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(200, 255, 255, 255),

                        border: Border.all(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                child: Text("Laaaaawwlllll"))),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(200, 255, 255, 255),
                        border: Border.all(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text(this.recipe.name,style: TextStyle(fontSize: 20),textAlign: TextAlign.center)))
          ]),
        )
        // Container(
        //     alignment: Alignment.center,
        //     child: Text(
        //       recipe.name,
        //       style: CookableTheme.normalBlackFont,
        //     )
        // ),

        // removed amount from api
        // Text(
        //   "${Utility.getFormattedAmount(userFoodProduct)}",
        //   style: CookableTheme.smallWhiteFont,
        // ),

        // Todo this is where I want to add #persons, diet icon, nutrients
        // Container(
        //   height: 50,
        //   alignment: Alignment.bottomCenter,
        //   color: Colors.orange,
        // ),
        );
  }

  navigateToRecipePage(int recipeId) async {
    //navigate to materials page when callbackPath is not report page and list component is clicked
    //Return the result to this component when task is finished from materials
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RecipesDetailsPage(recipeId)));
  }
}
