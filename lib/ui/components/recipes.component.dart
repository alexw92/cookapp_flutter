import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/recipe-tile.component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipesComponent extends StatefulWidget {
  RecipesComponent({Key key}) : super(key: key);

  @override
  _RecipesComponentState createState() => _RecipesComponentState();
}

class _RecipesComponentState extends State<RecipesComponent> {
  List<Recipe> recipeList = [];
  String apiToken;
  bool loading = false;

  void loadFoodProducts() async {
    loading = true;
    recipeList = await RecipeController.getRecipes();
    apiToken = await TokenStore().getToken();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadFoodProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return CircularProgressIndicator(
        value: null,
        backgroundColor: Colors.green,
      );
    else
      return Container(
        color: Colors.blueGrey,
        child: Container(
          // height: 400,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: GridView.count(
            primary: true,
            padding: const EdgeInsets.all(0),
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            children: [...getAllTiles()],
          ),
        ),
      );
  }

  List<Widget> getAllTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < recipeList.length; i++) {
      myTiles.add(
        RecipeTileComponent(recipe: recipeList[i], apiToken: apiToken),
      );
    }
    return myTiles;
  }
}
