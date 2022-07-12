import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                    maxHeight: 200,
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int i) {
                          var e = snapshot.data[i];
                          return Card(
                            elevation: 12,
                                  child: SizedBox(
                                      height: 34,
                                      child: Row(
                                          // alignment: WrapAlignment.spaceBetween,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: _onClickIngredientRequestEdit,
                                                splashRadius: 20,
                                                icon: Icon(Icons.edit)),
                                            Wrap(
                                                direction: Axis.vertical,
                                                children: [
                                                  Text(e.ingredientName),
                                                  Text(
                                                    timeago
                                                        .format(e.requestedOn),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey),
                                                  )
                                                ]),
                                            IconButton(
                                                onPressed: _onClickIngredientRequestStatus,
                                                splashRadius: 20,
                                                icon: Icon(Icons.timer))
                                          ])));
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
        // TextField(
        //     controller: _noteController,
        //     keyboardType: TextInputType.multiline,
        //     minLines: 2,
        //     maxLines: 10,
        //     maxLength: 1000,
        //     decoration: InputDecoration(
        //       labelText: AppLocalizations.of(context).ingredientNote,
        //       suffixIcon: Icon(
        //         Icons.edit,
        //         color: Colors.teal,
        //       ),
        //     )),
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
                    fontSize: 18,
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
    FocusScope.of(context).unfocus();
    setState(() {
      this.ingredientName = _nameController.value.text;
      //  this.ingredientNote = _noteController.value.text;
      this.ingredientNote = "";
    });
    if (this.ingredientRequests.length >= 10) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${AppLocalizations.of(context).tooManyPendingIngredientRequests}"),
        ),
      );
      return;
    }
    if (this.ingredientName.length < 5) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("${AppLocalizations.of(context).ingredientNameToShort}"),
        ),
      );
      return;
    }
    // if (this.ingredientNote.length == 0) {
    //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content:
    //           Text("${AppLocalizations.of(context).ingredientNoteMissing}"),
    //     ),
    //   );
    //   return;
    // }
    setState(() {
      loading = true;
    });

    IngredientRequestController.createIngredientRequest(
            this.ingredientName, this.ingredientNote)
        .then((_) => {
              setState(() {
                this.ingredientName = "";
                this.ingredientNote = "";
                _nameController.text = "";
                _noteController.text = "";
                this.loading = false;
              }),
              // reload
              setState(() {
                ingredientRequestsFuture = getIngredientRequests();
              })
            });

    setState(() {
      ingredientRequestsFuture = getIngredientRequests();
    });
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

  _onClickIngredientRequestEdit (){
    print("ir edit clicked");
  }
  _onClickIngredientRequestStatus (){
    print("ir status clicked");
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
