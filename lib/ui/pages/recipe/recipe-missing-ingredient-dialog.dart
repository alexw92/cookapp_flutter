import 'package:cookable_flutter/common/constants.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: Text(
          "${AppLocalizations.of(context).doYouHave} ${ingredient.name} ${AppLocalizations.of(context).inStock}?"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context).yes,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(Constants.UserHasIngredient);
                },
              ),
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context).no,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(Constants.UserLacksIngredient);
                },
              )
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(
                AppLocalizations.of(context).addToShoppingList,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context)
                    .pop(Constants.UserLacksIngredientAndWantsToAddToList);
              },
            )
          ],
        )
      ]),
    );
  }
}
