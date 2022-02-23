import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeRecipeNameDialog extends StatefulWidget {
  final String oldRecipeName;
  final int privateRecipeId;

  ChangeRecipeNameDialog(this.privateRecipeId, this.oldRecipeName);

  //final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  _ChangeRecipeNameDialogState createState() => _ChangeRecipeNameDialogState();
}

class _ChangeRecipeNameDialogState extends State<ChangeRecipeNameDialog> {
  final TextEditingController _controller = TextEditingController();

  _ChangeRecipeNameDialogState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).changeRecipeName),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: AppLocalizations.of(context).recipeNameHint),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            AppLocalizations.of(context).okay,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            String recipeName = _controller.value.text;
            if (recipeName != null) {
              String newName = await changePrivateRecipeName(
                  widget.privateRecipeId, recipeName);
              Navigator.of(context).pop(newName);
            }
          },
        ),
        //Text(AppLocalizations.of(context).createRecipe, style: TextStyle(color: w),),
      ],
    );
  }

  Future<String> changePrivateRecipeName(
      int privateRecipeId, String recipeName) async {
    String result = null;
    await RecipeController.changePrivateRecipeName(privateRecipeId, recipeName)
        .then((_) => {result = recipeName},
            onError: (error) => {print(error), result = null});
    return result;
  }
}
