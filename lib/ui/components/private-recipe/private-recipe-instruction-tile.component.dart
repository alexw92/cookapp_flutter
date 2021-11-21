import 'package:cookable_flutter/core/data/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivateRecipeInstructionTileComponent extends StatefulWidget {
  RecipeInstruction recipeInstruction;
  String apiToken;

  PrivateRecipeInstructionTileComponent(
      {Key key, this.recipeInstruction, this.apiToken})
      : super(key: key);

  @override
  _PrivateRecipeInstructionTileComponentState createState() =>
      _PrivateRecipeInstructionTileComponentState(
          recipeInstruction: recipeInstruction, apiToken: apiToken);
}

class _PrivateRecipeInstructionTileComponentState
    extends State<PrivateRecipeInstructionTileComponent> {
  RecipeInstruction recipeInstruction;
  String apiToken;

  _PrivateRecipeInstructionTileComponentState(
      {this.recipeInstruction, this.apiToken});

  @override
  didUpdateWidget(PrivateRecipeInstructionTileComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    recipeInstruction = widget.recipeInstruction;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top:5),
      child: Row(children: [
        Column(
          children: [
            Container(
                height: 36,
                width: 36,
                padding: const EdgeInsets.all(6),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 2, color: Colors.grey)),
                child: Center(
                    child: Text(
                        (recipeInstruction.step+1).toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )))
          ],
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
            width: 225,
            child: Text(
              recipeInstruction.instructionsText,
              overflow: TextOverflow.clip,
            )),
      ]),
    );
  }

// navigateToRecipePage(int recipeId) async {
//   final result = await Navigator.push(context,
//       MaterialPageRoute(builder: (context) => RecipesDetailsPage(recipeId)));
// }
}
