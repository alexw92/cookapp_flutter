import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
                    "Ingredients",
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
                      "Nutrients",
                      style: TextStyle(color: Colors.white, fontSize: 26),
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
            nutrientName: "Calories", nutrientAmount: recipe.nutrients.calories.toDouble(),
            dailyRecAmount: dailyCalories.toDouble(), isCalories: true),
        NutrientTileComponent(
            nutrientName: "Fat", nutrientAmount: recipe.nutrients.fat,
            dailyRecAmount: dailyFat, isCalories: false),
        NutrientTileComponent(
            nutrientName: "Carbs", nutrientAmount: recipe.nutrients.carbohydrate,
            dailyRecAmount: dailyCarbohydrate, isCalories: false),
        NutrientTileComponent(
            nutrientName: "Protein", nutrientAmount: recipe.nutrients.protein,
            dailyRecAmount: dailyProtein, isCalories: false)]
      );

    return myTiles;
  }
}

class IngredientTileComponent extends StatefulWidget {
  Ingredient ingredient;
  String apiToken;

  IngredientTileComponent({Key key, this.ingredient, this.apiToken})
      : super(key: key);

  @override
  _IngredientTileComponentState createState() =>
      _IngredientTileComponentState(ingredient: ingredient, apiToken: apiToken);
}

class _IngredientTileComponentState extends State<IngredientTileComponent> {
  Ingredient ingredient;
  String apiToken;

  _IngredientTileComponentState({this.ingredient, this.apiToken});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 28,
      color: Colors.black,
      child: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(ingredient.imgSrc,
            imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
        // backgroundColor: Colors.transparent,
        radius: 40,
      ),
    );
  }
}

class NutrientTileComponent extends StatefulWidget {
  String nutrientName;
  double nutrientAmount;
  double dailyRecAmount;
  bool isCalories = false;

  NutrientTileComponent({Key key, this.nutrientName, this.nutrientAmount, this.dailyRecAmount, this.isCalories})
      : super(key: key);

  @override
  _NutrientTileComponentState createState() =>
      _NutrientTileComponentState(nutrientName: nutrientName, nutrientAmount: nutrientAmount,
          dailyRecAmount: dailyRecAmount, isCalories: isCalories);
}

class _NutrientTileComponentState extends State<NutrientTileComponent> {
  String nutrientName;
  double nutrientAmount;
  double dailyRecAmount;
  bool isCalories;

  _NutrientTileComponentState({this.nutrientName, this.nutrientAmount, this.dailyRecAmount, this.isCalories});

  @override
  Widget build(BuildContext context) {
    return new CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 5.0,
      animation: true,
      percent: nutrientAmount/dailyRecAmount,
      center: new Text(
        "${isCalories?nutrientAmount.toInt():nutrientAmount} ${isCalories?"kcal":"g"}",
        style:
        new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10.0),
      ),
      footer: new Text(
        nutrientName,
        style:
        new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.purple,
    );
  }
}
