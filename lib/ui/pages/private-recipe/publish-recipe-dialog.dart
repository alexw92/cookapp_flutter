import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
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

  bool loading = false;

  _PublishRecipeDialogState({this.privateRecipe});

  @override
  void initState() {
    RecipeController.getPrivateRecipePublishable(this.privateRecipe.id)
        .then((value) => {this.publishStatus = value, this.setState(() {})});
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
              if (publishStatus == null || loading)
                getProgressWidget()
              else
                getConstraintIcon(
                    fullFilled:
                        publishStatus.constraintRecipeNameMaxLengthFulfilled)
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context).recipeImage,
                style: TextStyle(fontSize: 20)),
            Spacer(),
            if (publishStatus == null || loading)
              getProgressWidget()
            else
              getConstraintIcon(
                  fullFilled: publishStatus.constraintHasImageFulfilled)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context).ingredients,
                style: TextStyle(fontSize: 20)),
            Spacer(),
            if (publishStatus == null || loading)
              getProgressWidget()
            else
              getConstraintIcon(
                  fullFilled: publishStatus.constraintMinIngredientsFulfilled)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context).howToCookSteps,
                style: TextStyle(fontSize: 20)),
            Spacer(),
            if (publishStatus == null || loading)
              getProgressWidget()
            else
              getConstraintIcon(
                  fullFilled: publishStatus.constraintMinInstructionsFulfilled)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getRecipeRequestStatusWidget(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  onSurface: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
              child: Text(
                (publishStatus != null &&
                        publishStatus.status ==
                            PublishRecipeRequestStatus.PENDING)
                    ? AppLocalizations.of(context).cancelPublish
                    : AppLocalizations.of(context).publish,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: (publishStatus != null &&
                      (publishStatus.status ==
                              PublishRecipeRequestStatus.NOT_REQUESTED ||
                          publishStatus.status ==
                              PublishRecipeRequestStatus.DENIED) &&
                      publishStatus.constraintsFulfilled())
                  ? _sendPublishRequest
                  : (publishStatus != null &&
                          publishStatus.status ==
                              PublishRecipeRequestStatus.PENDING)
                      ? _cancelPublishRequest
                      : null,
              //
            )
          ],
        )
      ]),
    );
  }

  _sendPublishRequest() {
    setState(() {
      loading = true;
    });
    RecipeController.publishPrivateRecipe(privateRecipe.id)
        .then((value) => {
              RecipeController.getPrivateRecipePublishable(
                      this.privateRecipe.id)
                  .then((value) => {
                        this.publishStatus = value,
                        loading = false,
                        this.setState(() {})
                      })
                  .onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
                return;
              })
            })
        .onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      return;
    });
  }

  _cancelPublishRequest() {
    setState(() {
      loading = true;
    });
    RecipeController.cancelPublishPrivateRecipe(privateRecipe.id)
        .then((value) => {
              RecipeController.getPrivateRecipePublishable(
                      this.privateRecipe.id)
                  .then((value) => {
                        this.publishStatus = value,
                        loading = false,
                        this.setState(() {})
                      })
                  .onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
                return;
              })
            })
        .onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      return;
    });
  }

  getProgressWidget() {
    return SizedBox(
        height: 16,
        width: 16,
        child: Center(
            child: CircularProgressIndicator(
          strokeWidth: 2,
        )));
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

  getRecipeRequestStatusWidget() {
    if (this.publishStatus == null || loading)
      return SizedBox(
          height: 24,
          width: 24,
          child: Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          )));
    Widget widget;
    switch (this.publishStatus.status) {
      case PublishRecipeRequestStatus.PENDING:
        widget = Text(AppLocalizations.of(context).recipePublishPending,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        break;
      case PublishRecipeRequestStatus.NOT_REQUESTED:
        widget = Text(AppLocalizations.of(context).recipePublishNotRequested,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        break;
      case PublishRecipeRequestStatus.APPROVED:
        widget = Text(AppLocalizations.of(context).recipePublishApproved,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        break;
      case PublishRecipeRequestStatus.DENIED:
        widget = Text(AppLocalizations.of(context).recipePublishDenied,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        break;
    }
    return widget;
  }
}
