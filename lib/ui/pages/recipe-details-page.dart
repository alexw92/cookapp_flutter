import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipesDetailsPage extends StatefulWidget {
  final int recipeId;

  RecipesDetailsPage(this.recipeId, {Key key}) : super(key: key);

  @override
  _RecipesDetailsPageState createState() => _RecipesDetailsPageState();
}

class _RecipesDetailsPageState extends State<RecipesDetailsPage> {
  RecipeDetails recipe;
  String apiToken;

  _RecipesDetailsPageState();

  void loadRecipe() async {
    // recipe = await RecipeController.getRecipe();
    apiToken = await TokenStore().getToken();
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
        : Container(
            color: Colors.blueGrey,
            child: Container(
              // height: 400,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(this.recipe.name),
            ),
          );
  }
}
