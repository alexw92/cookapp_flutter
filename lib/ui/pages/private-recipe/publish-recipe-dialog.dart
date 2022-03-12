import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PublishRecipeDialog extends StatefulWidget {
  PrivateRecipe privateRecipe;

  PublishRecipeDialog({this.privateRecipe});

  //final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  _PublishRecipeDialogState createState() =>
      _PublishRecipeDialogState(privateRecipe: privateRecipe);
}

class _PublishRecipeDialogState extends State<PublishRecipeDialog> {
  PrivateRecipe privateRecipe;
  PrivateRecipePublishableStatus publishStatus;

  _PublishRecipeDialogState({this.privateRecipe});

  @override
  void initState() {
    RecipeController.getPrivateRecipePublishable(this.privateRecipe.id)
        .then((value) => {this.publishStatus = value});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "${AppLocalizations.of(context).publishYourRecipe}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).recipeName,
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              getConstraintIcon(fullFilled: true)
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context).recipeImage,
                style: TextStyle(fontSize: 20)),
            Spacer(),
            getConstraintIcon(fullFilled: true)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context).ingredients,
                style: TextStyle(fontSize: 20)),
            Spacer(),
            getConstraintIcon(fullFilled: true)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context).howToCookSteps,
                style: TextStyle(fontSize: 20)),
            Spacer(),
            getConstraintIcon(fullFilled: false)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
              child: Text(
                AppLocalizations.of(context).publish,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            )
          ],
        )
      ]),
    );
  }

  getConstraintIcon({bool fullFilled: false}) {
    if (fullFilled)
      return FaIcon(
        FontAwesomeIcons.check,
        color: Colors.lightGreen,
        size: 26,
      );
    else
      return Wrap(children: [
        FaIcon(
          FontAwesomeIcons.times,
          color: Colors.redAccent,
          size: 26,
        ),
        SizedBox(
          width: 6,
        )
      ]);
  }
}
