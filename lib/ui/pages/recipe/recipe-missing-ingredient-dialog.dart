import 'package:cookable_flutter/common/constants.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MissingIngredientDialog extends StatefulWidget {
  Ingredient ingredient;

  MissingIngredientDialog({this.ingredient});

  //final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  _MissingIngredientDialogState createState() =>
      _MissingIngredientDialogState(ingredient: ingredient);
}

class _MissingIngredientDialogState extends State<MissingIngredientDialog> {
  Ingredient ingredient;

  _MissingIngredientDialogState({this.ingredient});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Do you have ${ingredient.name}?"),
      content: Column(
          //  crossAxisAlignment: CrossAxisAlignment.center,
          //  mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
         //       crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              ElevatedButton(
                child: Text("Yes"),
                onPressed: () async {
                  Navigator.of(context).pop(Constants.UserHasIngredient);
                },
              ),
              ElevatedButton(
                child: Text("No"),
                onPressed: () async {
                  Navigator.of(context).pop(Constants.UserLacksIngredient);
                },
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Add to buying list"),
                  onPressed: () async {
                    Navigator.of(context).pop(Constants.UserLacksIngredientAndWantsToAddToList);
                  },
                )
              ],
            )
          ]),
    );
  }

}
