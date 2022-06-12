import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/common/NeedsRecipeUpdateState.dart';
import 'package:cookable_flutter/core/caching/recipe_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/ui/pages/recipe/recipe-details-page.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:like_button/like_button.dart';

class RecipeGridTileComponent extends StatefulWidget {
  Recipe recipe;
  String apiToken;
  final VoidCallback userFoodUpdatedCallback;
  final Function likesUpdated;
  Color bannerColor = Colors.brown;

  RecipeGridTileComponent(
      {Key key,
      this.recipe,
      this.apiToken,
      this.userFoodUpdatedCallback,
      this.likesUpdated,
      this.bannerColor})
      : super(key: key);

  @override
  _RecipeGridTileComponentState createState() =>
      _RecipeGridTileComponentState(recipe: recipe, apiToken: apiToken);
}

class _RecipeGridTileComponentState extends State<RecipeGridTileComponent> {
  Recipe recipe;
  String apiToken;
  RecipeService recipeService = RecipeService();

  _RecipeGridTileComponentState({this.recipe, this.apiToken});

  Color _getColorForMissingIngredientNumber(int missing) {
    var color = Colors.red;
    switch (missing) {
      case 0:
        color = Colors.teal;
        break;
      case 1:
        color = Colors.lightGreen;
        break;
      case 2:
        color = Colors.lightGreen;
        break;
      case 3:
        color = Colors.orange;
        break;
      case 4:
        color = Colors.orange;
        break;
      case 5:
        color = Colors.red;
        break;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.all(2),
            child: GestureDetector(
                onTap: () => navigateToRecipePage(recipe.id),
                child: Center(
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        //               height: 400,
                        //               width: 320,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(0, 0, 0, 0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal,
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Stack(children: [
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Column(children: [
                                Stack(children: [
                                  Container(
                                    color: Colors.grey,
                                    child: Image(
                                      width: 380,
                                      height: 300,
                                      // needs --web-renderer html
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.center,
                                      image: CachedNetworkImageProvider(
                                          recipe.imgSrc,
                                          imageRenderMethodForWeb:
                                              ImageRenderMethodForWeb.HttpGet),
                                      // backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ]),
                                Container(
                                    height: 100,
                                    width: 380,
                                    child: Container(
                                        color: widget.bannerColor,
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                      child: Text(
                                                          this.recipe.name,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 36,
                                                          overflow: TextOverflow.ellipsis),
                                                          textAlign: TextAlign
                                                              .center))),
                                            ],
                                          ),
                                          Expanded(
                                              child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Wrap(
                                                    spacing: 3,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    children: [
                                                      Container(
                                                          child: Text(
                                                        Utility
                                                            .getUnicodeIconForDiet(
                                                                context,
                                                                recipe.diet),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 44.0),
                                                      )),
                                                      getHighProteinChipIfNeeded(),
                                                      getHighCarbChipIfNeeded(),
                                                    ])),
                                          ))
                                        ])))
                              ])),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Column(children: [
                                Container(
                                    margin: EdgeInsets.only(top: 0, right: 4),
                                    child: LikeButton(
                                      size: 28,
                                      circleColor: CircleColor(
                                          start: Color(0xffdd6666),
                                          end: Color(0xffff3600)),
                                      likeCount: recipe.likes,
                                      isLiked: recipe.userLiked,
                                      countPostion: CountPostion.bottom,
                                      onTap: onLikeButtonTapped,
                                      likeBuilder: (bool isLiked) {
                                        return isLiked
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 24,
                                              )
                                            : Icon(
                                                Icons.favorite_outline_sharp,
                                                color: Colors.white,
                                                size: 24,
                                              );
                                      },
                                      countBuilder: (int count, bool isLiked,
                                          String text) {
                                        var color =
                                            isLiked ? Colors.red : Colors.white;
                                        Widget result;
                                        if (count == 0) {
                                          result = Text(
                                            "0",
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          );
                                        } else
                                          result = Text(
                                            text,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          );
                                        return result;
                                      },
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                              ])),
                          Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                  width: 16,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color:
                                          _getColorForMissingIngredientNumber(
                                              this
                                                  .recipe
                                                  .missingUserFoodProducts
                                                  .length)),
                                  child: Text(
                                    "${this.recipe.missingUserFoodProducts.length}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )))
                        ]))))));
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    final int likes = await RecipeController.toggleRecipeLike(recipe.id);
    setState(() {
      recipe.userLiked = !recipe.userLiked;
      recipe.likes = likes;
    });
    await recipeService.addOrUpdateRecipe(recipe);
    this.widget.likesUpdated();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Widget getHighProteinChipIfNeeded() {
    return (recipe.nutrients.isHighProteinRecipe)
        ? Text(
            Utility.getUnicodeIconForNutritionDiet(
                context, NutritionDiet.HIGH_PROTEIN),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 44.0),
          )
        : Container();
  }

  Widget getHighCarbChipIfNeeded() {
    return (recipe.nutrients.isHighCarbRecipe)
        ? Text(
            Utility.getUnicodeIconForNutritionDiet(
                context, NutritionDiet.HIGH_CARBS),
            style: TextStyle(color: Colors.black, fontSize: 44.0),
          )
        : Container();
  }

  navigateToRecipePage(int recipeId) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipesDetailsPage(
                  recipeId,
                  recipeBannerColor: widget.bannerColor,
                )));
    // in case the user changed the food product from missing to in stock
    // recipes must be reloaded to reflect correct missing ingredient numbers
    // Todo find less expensive solution for this
    bool needsRecipesUpdate = NeedsRecipeUpdateState().recipesUpdateNeeded;
    if (needsRecipesUpdate) {
      if (widget.userFoodUpdatedCallback == null) {
        print("nav back to recipes: no callback was given");
        return;
      }
      widget.userFoodUpdatedCallback();
    }
  }
}
