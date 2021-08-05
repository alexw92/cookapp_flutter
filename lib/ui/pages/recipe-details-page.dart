import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipesDetailsPage extends StatefulWidget {
  RecipesDetailsPage({Key key}) : super(key: key);

  @override
  _RecipesDetailsPageState createState() => _RecipesDetailsPageState();
}

class _RecipesDetailsPageState extends State<RecipesDetailsPage> {


  Recipe recipe;
  String apiToken;

  void loadRecipe() async{
   // recipe = await RecipeController.getRecipe();
    apiToken = await TokenStore().getToken();
    setState(() {

    });
  }

  @override
  void initState(){
    super.initState();
    loadRecipe();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.blueGrey,
      child: Container(
        // height: 400,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Text("recipe"),
      ),
    );
  }


}
