import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestIngredientDialog extends StatefulWidget {
  String ingredientName;
  String ingredientNote;

  RequestIngredientDialog({this.ingredientName, this.ingredientNote});

  //final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  _RequestIngredientDialogState createState() => _RequestIngredientDialogState(
      ingredientName: ingredientName, ingredientNote: ingredientNote);
}

class _RequestIngredientDialogState extends State<RequestIngredientDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  PrivateRecipePublishableStatus publishStatus;
  String ingredientName;
  String ingredientNote;
  List<IngredientRequest> ingredientRequests = [];
  Future<List<IngredientRequest>> ingredientRequestsFuture;

  bool loading = false;

  _RequestIngredientDialogState({this.ingredientName, this.ingredientNote});

  @override
  void initState() {
    // RecipeController.getPrivateRecipePublishable(this.privateRecipe.id)
    //     .then((value) => {this.publishStatus = value, this.setState(() {})});
    _nameController.text = this.ingredientName;
    _noteController.text = this.ingredientNote;
    ingredientRequestsFuture = getIngredientRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "${AppLocalizations.of(context).requestIngredient}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        FutureBuilder(
            //  initialData: [],
            future: ingredientRequestsFuture,
            builder: (context, snapshot) => snapshot.hasData
                ? LimitedBox(
                    maxHeight: 100,
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int i) {
                          var e = snapshot.data[i];
                          return Text(e.ingredientName +
                              " " +
                              (e.requestedOn as DateTime).day.toString());
                        }))
                : getProgressWidget()),
        TextField(
            controller: _nameController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 1,
            maxLength: 35,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).ingredientName,
              suffixIcon: Icon(
                Icons.edit,
                color: Colors.teal,
              ),
            )),
        TextField(
            controller: _noteController,
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 10,
            maxLength: 1000,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).ingredientNote,
              suffixIcon: Icon(
                Icons.edit,
                color: Colors.teal,
              ),
            )),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     //       crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Text(
        //         AppLocalizations.of(context).recipeName,
        //         style: TextStyle(fontSize: 20),
        //       ),
        //       Spacer(),
        //       if (publishStatus == null || loading)
        //         getProgressWidget()
        //       else
        //         getConstraintIcon(
        //             fullFilled:
        //                 publishStatus.constraintRecipeNameMaxLengthFulfilled)
        //     ]),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Text(AppLocalizations.of(context).recipeImage,
        //         style: TextStyle(fontSize: 20)),
        //     Spacer(),
        //     if (publishStatus == null || loading)
        //       getProgressWidget()
        //     else
        //       getConstraintIcon(
        //           fullFilled: publishStatus.constraintHasImageFulfilled)
        //   ],
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Text(AppLocalizations.of(context).ingredients,
        //         style: TextStyle(fontSize: 20)),
        //     Spacer(),
        //     if (publishStatus == null || loading)
        //       getProgressWidget()
        //     else
        //       getConstraintIcon(
        //           fullFilled: publishStatus.constraintMinIngredientsFulfilled)
        //   ],
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Text(AppLocalizations.of(context).howToCookSteps,
        //         style: TextStyle(fontSize: 20)),
        //     Spacer(),
        //     if (publishStatus == null || loading)
        //       getProgressWidget()
        //     else
        //       getConstraintIcon(
        //           fullFilled: publishStatus.constraintMinInstructionsFulfilled)
        //   ],
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     getRecipeRequestStatusWidget(),
        //   ],
        // ),
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
                AppLocalizations.of(context).requestIngredientButtonText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: _sendAddIngredientRequest,
              //
            )
          ],
        )
      ]),
    );
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

  _sendAddIngredientRequest() {
    setState(() {
      this.ingredientName = _nameController.value.text;
      this.ingredientNote = _noteController.value.text;
    });
    if (this.ingredientName.length < 3) return;
    setState(() {
      loading = true;
    });

    IngredientRequestController.createIngredientRequest(
            this.ingredientName, this.ingredientNote)
        .then((_) => {
              setState(() {
                setState(() {
                  this.ingredientName = "";
                  this.ingredientNote = "";
                  _nameController.text = "";
                  _noteController.text = "";
                  this.loading = false;
                });
              })
            });
    //     .onError((error, stackTrace) {
    //   setState(() {
    //     loading = false;
    //   });
    //   return;
    // });
    // RecipeController.publishPrivateRecipe(privateRecipe.id)
    //     .then((value) => {
    //   RecipeController.getPrivateRecipePublishable(
    //       this.privateRecipe.id)
    //       .then((value) => {
    //     this.publishStatus = value,
    //     loading = false,
    //     this.setState(() {})
    //   })
    //       .onError((error, stackTrace) {
    //     setState(() {
    //       loading = false;
    //     });
    //     return;
    //   })
    // })
    //    .onError((error, stackTrace) {
    //   setState(() {
    //     loading = false;
    //   });
    //   return;
    // });
  }

  getIngredientRequests() {
    return IngredientRequestController.getIngredientRequests();
    //     .onError((error, stackTrace) {
    //   print(error);
    //   print(stackTrace);
    //   setState(() {
    //     loading = false;
    //   });
    //   return;
    // });
  }

  _cancelPublishRequest() {
    setState(() {
      loading = true;
    });
    // RecipeController.cancelPublishPrivateRecipe(privateRecipe.id)
    //     .then((value) => {
    //   RecipeController.getPrivateRecipePublishable(
    //       this.privateRecipe.id)
    //       .then((value) => {
    //     this.publishStatus = value,
    //     loading = false,
    //     this.setState(() {})
    //   })
    //       .onError((error, stackTrace) {
    //     setState(() {
    //       loading = false;
    //     });
    //     return;
    //   })
    // })
    //     .onError((error, stackTrace) {
    //   setState(() {
    //     loading = false;
    //   });
    //   return;
    // });
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
