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

class RecipeTileComponent extends StatefulWidget {
  Recipe recipe;
  String apiToken;
  final VoidCallback userFoodUpdatedCallback;
  final Function likesUpdated;
  Color bannerColor = Colors.brown;

  RecipeTileComponent(
      {Key key,
      this.recipe,
      this.apiToken,
      this.userFoodUpdatedCallback,
      this.likesUpdated,
      this.bannerColor})
      : super(key: key);

  @override
  _RecipeTileComponentState createState() =>
      _RecipeTileComponentState(recipe: recipe, apiToken: apiToken);
}

class _RecipeTileComponentState extends State<RecipeTileComponent> {
  Recipe recipe;
  String apiToken;
  RecipeService recipeService = RecipeService();

  _RecipeTileComponentState({this.recipe, this.apiToken});

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
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () => navigateToRecipePage(recipe.id),
                child: Center(
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        //               height: 400,
                        //               width: 320,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(0, 0, 0, 0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal,
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Column(children: [
                              Stack(children: [
                                Container(
                                  color: Colors.grey,
                                  height: 320,
                                  width: 320,
                                  child: Image(
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
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Column(children: [
                                      Container(
                                          margin:
                                              EdgeInsets.only(top: 3, right: 3),
                                          child: LikeButton(
                                            size: 40,
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
                                                      size: 40,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .favorite_outline_sharp,
                                                      color: Colors.white,
                                                      size: 40,
                                                    );
                                            },
                                            countBuilder: (int count,
                                                bool isLiked, String text) {
                                              var color = isLiked
                                                  ? Colors.red
                                                  : Colors.white;
                                              Widget result;
                                              if (count == 0) {
                                                result = Text(
                                                  "0",
                                                  style: TextStyle(
                                                      color: color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                );
                                              } else
                                                result = Text(
                                                  text,
                                                  style: TextStyle(
                                                      color: color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                );
                                              return result;
                                            },
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ])),
                                Positioned(
                                    top: 5,
                                    left: 5,
                                    child: Container(
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
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
                                              fontSize: 20,
                                              color: Colors.white),
                                        )))
                              ]),
                              Container(
                                  height: 80,
                                  width: 320,
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
                                                            color: Colors.white,
                                                            fontSize: 24),
                                                        textAlign:
                                                            TextAlign.center))),
                                          ],
                                        ),
                                        Expanded(
                                            child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Wrap(
                                                  spacing: 3,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: Chip(
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      avatar: Text(
                                                          Utility
                                                              .getUnicodeIconForDiet(
                                                                  context,
                                                                  recipe.diet),
                                                          style: TextStyle(
                                                              fontSize: 20)),
                                                      label: Text(
                                                        Utility
                                                            .getTranslatedDiet(
                                                                context,
                                                                recipe.diet),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.0),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      elevation: 6.0,
                                                      shadowColor:
                                                          Colors.grey[60],
                                                      // padding: EdgeInsets.all(8.0),
                                                    )),
                                                    getHighProteinChipIfNeeded(),
                                                    getHighCarbChipIfNeeded(),
                                                  ])),
                                        ))
                                      ])))
                            ])))))));
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
        ? Container(
            child: Chip(
            avatar: Text(
                Utility.getUnicodeIconForNutritionDiet(
                    context, NutritionDiet.HIGH_PROTEIN),
                style: TextStyle(fontSize: 20)),
            label: Text(
              AppLocalizations.of(context).highProtein,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Colors.white,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            //  padding: EdgeInsets.all(8.0),
          ))
        : Container();
  }

  Widget getHighCarbChipIfNeeded() {
    return (recipe.nutrients.isHighCarbRecipe)
        ? Container(
            child: Chip(
            //  labelPadding: EdgeInsets.all(4.0),
            avatar: Text(
                Utility.getUnicodeIconForNutritionDiet(
                    context, NutritionDiet.HIGH_CARBS),
                style: TextStyle(fontSize: 20)),
            label: Text(
              AppLocalizations.of(context).highCarb,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Colors.white,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            //  padding: EdgeInsets.all(8.0),
          ))
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
