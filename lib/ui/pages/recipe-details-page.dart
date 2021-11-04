import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/ingredient-tile.component.dart';
import 'package:cookable_flutter/ui/components/nutrient-tile.component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RecipesDetailsPage extends StatefulWidget {
  final int recipeId;

  RecipesDetailsPage(this.recipeId, {Key key}) : super(key: key);

  @override
  _RecipesDetailsPageState createState() => _RecipesDetailsPageState();
}

class _RecipesDetailsPageState extends State<RecipesDetailsPage> {
  RecipeDetails recipe;
  String apiToken;
  int dailyCalories;
  double dailyCarbohydrate;
  double dailyProtein;
  double dailyFat;

  _RecipesDetailsPageState();

  void loadRecipe() async {
    // recipe = await RecipeController.getRecipe();
    apiToken = await TokenStore().getToken();
    var prefs = await SharedPreferences.getInstance();
    dailyCalories = prefs.getInt('dailyCalories');
    dailyCarbohydrate = prefs.getDouble('dailyCarbohydrate');
    dailyProtein = prefs.getDouble('dailyProtein');
    dailyFat = prefs.getDouble('dailyFat');
    this.recipe = await RecipeController.getRecipe(this.widget.recipeId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return recipe == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [CircularProgressIndicator()])
              ])
        : Scaffold(
            body: SafeArea(
            child: Container(
                child: SingleChildScrollView(
                    //  padding: EdgeInsets.only(bottom: 15),
                    child: Column(children: [
              //  Container( child: Stack(
              //        fit:StackFit.expand,
              //        children: [
              //   Container(
              //       height: 300,
              //       width: 300,
              //       color:Colors.grey,
              //       child: FittedBox(
              //           fit: BoxFit.fill,
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(20), child:Image(
              //             // needs --web-renderer html
              //             image: CachedNetworkImageProvider(recipe.imgSrc,
              //                 imageRenderMethodForWeb:
              //                 ImageRenderMethodForWeb.HttpGet),
              //             // backgroundColor: Colors.transparent,
              //             //  radius: 40,
              //           ),
              //           ))),
              //   Positioned(
              //       bottom: 0,
              //       left: 0,
              //       right: 0,
              //       child: Container(
              //           width: 100,
              //           height: 50,
              //           decoration: BoxDecoration(
              //               color: Color.fromARGB(200, 255, 255, 255),
              //
              //               border: Border.all(
              //                 color: Color.fromARGB(0, 0, 0, 0),
              //               ),
              //               borderRadius: BorderRadius.all(Radius.circular(20))
              //           ),
              //           child: Text("Laaaaawwlllll"))),
              //   Positioned(
              //       top: 0,
              //       left: 0,
              //       right: 0,
              //       child: Container(
              //           width: 100,
              //           height: 30,
              //           decoration: BoxDecoration(
              //               color: Color.fromARGB(200, 255, 255, 255),
              //               border: Border.all(
              //                 color: Color.fromARGB(0, 0, 0, 0),
              //               ),
              //               borderRadius: BorderRadius.all(Radius.circular(20))
              //           ),
              //           child: Text(this.recipe.name,style: TextStyle(fontSize: 20),textAlign: TextAlign.center)))
              // ])),
              Container(
                  height: 400,
                  width: double.infinity,
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image(
                        // needs --web-renderer html
                        image: CachedNetworkImageProvider(recipe.imgSrc,
                            imageRenderMethodForWeb:
                                ImageRenderMethodForWeb.HttpGet),
                        // backgroundColor: Colors.transparent,
                        //  radius: 40,
                      ))),
              Container(
                color: Colors.black,
                width: double.infinity,
                child: Column(children: [
                  Text(
                    AppLocalizations.of(context).ingredients,
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: new GridView.count(
                        //     primary: true,
                        //    padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        mainAxisSpacing: 0,
                        padding: EdgeInsets.only(left:10,right:10),
                        crossAxisSpacing: 10,
                        children: [
                          ...getAllIngredientTiles()
                          //
                        ],
                      ))
                ]),
              ),
              Container(
                  color: Colors.black,
                  width: double.infinity,
                  child: Column(children: [
                    Text(
                      AppLocalizations.of(context).nutrients, style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: new GridView.count(
                          //     primary: true,
                          //    padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 5,
                          children: [
                            ...getNutrientTiles()
                            //
                          ],
                        ))
                  ])),
            ]))),
          ));
  }

  List<Widget> getAllIngredientTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < recipe.ingredients.length; i++) {
      myTiles.add(
        IngredientTileComponent(
            ingredient: recipe.ingredients[i], apiToken: apiToken),
      );
    }
    return myTiles;
  }

  List<Widget> getNutrientTiles() {
    List<Widget> myTiles = [];
      myTiles.addAll([
        NutrientTileComponent(
            nutrientName: AppLocalizations.of(context).calories, nutrientAmount: recipe.nutrients.calories.toDouble(),
            dailyRecAmount: dailyCalories.toDouble(), isCalories: true),
        NutrientTileComponent(
            nutrientName: AppLocalizations.of(context).fat, nutrientAmount: recipe.nutrients.fat,
            dailyRecAmount: dailyFat, isCalories: false),
        NutrientTileComponent(
            nutrientName: AppLocalizations.of(context).carbs, nutrientAmount: recipe.nutrients.carbohydrate,
            dailyRecAmount: dailyCarbohydrate, isCalories: false),
        NutrientTileComponent(
            nutrientName: AppLocalizations.of(context).protein, nutrientAmount: recipe.nutrients.protein,
            dailyRecAmount: dailyProtein, isCalories: false)]
      );

    return myTiles;
  }
}




