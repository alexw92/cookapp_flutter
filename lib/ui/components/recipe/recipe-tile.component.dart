import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/pages/recipe/recipe-details-page.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class RecipeTileComponent extends StatefulWidget {
  Recipe recipe;
  String apiToken;
  final VoidCallback userFoodUpdatedCallback;

  RecipeTileComponent(
      {Key key, this.recipe, this.apiToken, this.userFoodUpdatedCallback})
      : super(key: key);

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
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Stack(fit: StackFit.expand, children: [
            Container(
                height: 300,
                width: 300,
                color: Colors.grey,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        // needs --web-renderer html
                        image: CachedNetworkImageProvider(recipe.imgSrc,
                            imageRenderMethodForWeb:
                                ImageRenderMethodForWeb.HttpGet),
                        // backgroundColor: Colors.transparent,
                      ),
                    ))),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5),
                    child: Container(
                        child: (Row(children: [
                      Container(
                          margin: EdgeInsets.only(top: 8, right: 3),
                          child: LikeButton(
                            size: 40,
                            circleColor: CircleColor(
                                start: Color(0xffdd6666),
                                end: Color(0xffff3600)),
                            likeCount: recipe.likes,
                            isLiked: recipe.userLiked,
                            likeBuilder: (bool isLiked) {
                              return isLiked
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 40,
                                    )
                                  : Icon(
                                      Icons.favorite_outline_sharp,
                                      color: Colors.black,
                                      size: 40,
                                    );
                            },
                            countBuilder:
                                (int count, bool isLiked, String text) {
                              var color = Colors.white;
                              Widget result;
                              if (count == 0) {
                                result = Text(
                                  "",
                                  style: TextStyle(color: color),
                                );
                              } else
                                result = Text(
                                  text,
                                  style: TextStyle(color: color),
                                );
                              return result;
                            },
                          )),
                      Expanded(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(spacing: 3, children: [
                                Container(
                                    margin: EdgeInsets.only(top: 12),
                                    child: Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      //   labelPadding: EdgeInsets.all(4.0),
                                      avatar:
                                          Utility.getIconForDiet(recipe.diet),
                                      label: Text(
                                        Utility.getTranslatedDiet(
                                            context, recipe.diet),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 6.0,
                                      shadowColor: Colors.grey[60],
                                      // padding: EdgeInsets.all(8.0),
                                    )),
                                getHighProteinChipIfNeeded(),
                                getHighCarbChipIfNeeded(),
                              ])))
                    ]))))),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(200, 255, 255, 255),
                        border: Border.all(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(this.recipe.name,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center))),
            Positioned(
                top: 35,
                left: 0,
                right: 0,
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(200, 255, 255, 255),
                        border: Border.all(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                        "${Intl.plural(this.recipe.missingUserFoodProducts.length, zero: "${AppLocalizations.of(context).noMissingIngredients}", one: "${this.recipe.missingUserFoodProducts.length} ${AppLocalizations.of(context).missingIngredient}", other: "${this.recipe.missingUserFoodProducts.length} ${AppLocalizations.of(context).missingIngredients}")}",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center)))
          ]),
        ));
  }

  Widget getHighProteinChipIfNeeded() {
    return (!recipe.nutrients.isHighProteinRecipe)
        ? Container(
            margin: EdgeInsets.only(top: 4),
            child: Chip(
              avatar: Icon(
                Icons.fitness_center,
              ),
              label: Text(
                AppLocalizations.of(context).highProtein,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),
              backgroundColor: Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: EdgeInsets.all(8.0),
            ))
        : Container();
  }

  Widget getHighCarbChipIfNeeded() {
    return (!recipe.nutrients.isHighCarbRecipe)
        ? Container(
            margin: EdgeInsets.only(top: 4),
            child: Chip(
              //  labelPadding: EdgeInsets.all(4.0),
              avatar: Icon(
                Icons.directions_bike,
              ),
              label: Text(
                AppLocalizations.of(context).highCarb,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),
              backgroundColor: Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: EdgeInsets.all(8.0),
            ))
        : Container();
  }

  navigateToRecipePage(int recipeId) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RecipesDetailsPage(recipeId)));
    // in case the user changed the food product from missing to in stock
    // recipes must be reloaded to reflect correct missing ingredient numbers
    // Todo find less expensive solution for this
    bool needsRecipesUpdate = NeedsRecipeUpdateState().recipesUpdateNeeded;
    if (needsRecipesUpdate) widget.userFoodUpdatedCallback();
  }
}
