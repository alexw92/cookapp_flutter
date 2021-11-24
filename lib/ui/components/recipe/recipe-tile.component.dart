import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/pages/recipe/recipe-details-page.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    child: Row(children: [
                      Chip(
                        labelPadding: EdgeInsets.all(4.0),
                        avatar: Utility.getIconForDiet(recipe.diet),
                        label: Text(
                          Utility.getTranslatedDiet(context, recipe.diet),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 6.0,
                        shadowColor: Colors.grey[60],
                        padding: EdgeInsets.all(8.0),
                      ),
                      getHighProteinChipIfNeeded(),
                      getHighCarbChipIfNeeded(),
                    ]))),
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
                        textAlign: TextAlign.center)))
          ]),
        ));
  }

  Widget getHighProteinChipIfNeeded() {
    return (recipe.nutrients.isHighProteinRecipe)
        ? Chip(
            labelPadding: EdgeInsets.all(4.0),
            avatar: Icon(
              Icons.fitness_center,
            ),
            label: Text(
              AppLocalizations.of(context).highProtein,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.all(8.0),
          )
        : Container();
  }

  Widget getHighCarbChipIfNeeded() {
    return (recipe.nutrients.isHighCarbRecipe)
        ? Chip(
            labelPadding: EdgeInsets.all(4.0),
            avatar: Icon(
              Icons.directions_bike,
            ),
            label: Text(
              AppLocalizations.of(context).highCarb,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.all(8.0),
          )
        : Container();
  }

  navigateToRecipePage(int recipeId) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RecipesDetailsPage(recipeId)));
  }
}
