import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateRecipeDialog extends StatefulWidget {
  Diet diet;

  CreateRecipeDialog({this.diet});

  //final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  _CreateRecipeDialogState createState() => _CreateRecipeDialogState();
}

class _CreateRecipeDialogState extends State<CreateRecipeDialog> {
  final TextEditingController _controller = TextEditingController();

  _CreateRecipeDialogState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).newRecipe),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter the name of your recipe'),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Create'),
          onPressed: () async {
            String recipeName = _controller.value.text;
            if (recipeName != null) {
              PrivateRecipe privateRecipe =
                  await createAndReturnPrivateRecipe(recipeName);
              if (privateRecipe != null)
                Navigator.of(context).pop(privateRecipe);
            }
          },
        ),
      ],
    );
  }

  Future<PrivateRecipe> createAndReturnPrivateRecipe(String recipeName) async {
    PrivateRecipe recipe;
    await RecipeController.createPrivateRecipe(recipeName)
        .then((value) => {recipe = value}, onError: (error) => {print(error)});
    return recipe;
  }
}
