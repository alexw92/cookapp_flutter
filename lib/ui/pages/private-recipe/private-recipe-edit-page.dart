import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/ingredient-tile.component.dart';
import 'package:cookable_flutter/ui/components/nutrient-tile.component.dart';
import 'package:cookable_flutter/ui/components/private-recipe/private-recipe-instruction-tile.component.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/add-ingredient-page.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/edit-ingredients-amount-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add-instruction-dialog.dart';

class RecipeEditPage extends StatefulWidget {
  final int privateRecipeId;

  RecipeEditPage(this.privateRecipeId, {Key key}) : super(key: key);

  @override
  _RecipeEditPageState createState() => _RecipeEditPageState(privateRecipeId);
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  List<bool> _isOpen = [false, false];
  List<Widget> _instructionTiles = [];
  String apiToken;
  PrivateRecipe privateRecipe;
  int privateRecipeId;
  int dailyCalories = 0;
  double dailyCarbohydrate = 0;
  double dailyProtein = 0;
  double dailyFat = 0;

  _RecipeEditPageState(this.privateRecipeId);

  @override
  void initState() {
    getToken();
    loadDailyRequiredNutrients();
    loadPrivateRecipe(privateRecipeId);
    super.initState();
  }

  void loadPrivateRecipe(int privateRecipeId) async {
    privateRecipe = await RecipeController.getPrivateRecipe(privateRecipeId);
    getInstructionTiles();
    setState(() {});
  }

  loadDailyRequiredNutrients() async {
    var prefs = await SharedPreferences.getInstance();
    dailyCalories = prefs.getInt('dailyCalories');
    dailyCarbohydrate = prefs.getDouble('dailyCarbohydrate');
    dailyProtein = prefs.getDouble('dailyProtein');
    dailyFat = prefs.getDouble('dailyFat');
  }

  @override
  Widget build(BuildContext context) {
    return privateRecipe == null
        ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [CircularProgressIndicator()])
        ])
        : Scaffold(
        appBar:
        AppBar(title: Text(AppLocalizations
            .of(context)
            .recipeEdit)),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Text(privateRecipe.name, style: TextStyle(fontSize: 26)),
                SizedBox(
                  height: 16,
                ),
                ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.all(4),
                  dividerColor: Colors.green,
                  children: [
                    ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[0],
                        headerBuilder: (context, isOpen) {
                          return Text(
                            AppLocalizations
                                .of(context)
                                .ingredients +
                                " (" +
                                privateRecipe.ingredients.length.toString() +
                                ")",
                            style: TextStyle(fontSize: 24),
                          );
                        },
                        body: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: _openAddIngredientScreen,
                                    child: Icon(Icons.add),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(10)),
                                      backgroundColor:
                                      MaterialStateProperty.all(Colors
                                          .white), // <-- Button color,
                                    ),
                                  ),
                                  (privateRecipe.ingredients.length != 0)
                                      ? ElevatedButton(
                                    onPressed:
                                    _openEditIngredientsAmountScreen,
                                    child: Image.asset(
                                      "assets/balance.png",
                                      width: 24,
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(10)),
                                      backgroundColor:
                                      MaterialStateProperty.all(Colors
                                          .white), // <-- Button color,
                                    ),
                                  )
                                      : Container()
                                ]),
                            getIngredientGridView(),
                            getNutritionGridView()
                          ],
                        )),
                    ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[1],
                        headerBuilder: (context, isOpen) {
                          return Text(
                              AppLocalizations
                                  .of(context)
                                  .howToCookSteps +
                                  " (" +
                                  privateRecipe.instructions.length.toString() +
                                  ")",
                              style: TextStyle(fontSize: 24));
                        },
                        body: Column(
                          children: [
                            ElevatedButton(
                              onPressed: openAddInstructionDialog,
                              child: Icon(Icons.add),
                              style: ButtonStyle(
                                shape:
                                MaterialStateProperty.all(CircleBorder()),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // <-- Button color,
                              ),
                            ),
                            // Todo shit doesnt work properly, try https://pub.dev/packages/flutter_reorderable_list/example
                            ReorderableListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                onReorder: (int oldIndex, int newIndex) {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  Widget oldItem =
                                  _instructionTiles.removeAt(oldIndex);
                                  _instructionTiles.insert(newIndex, oldItem);

                                  for (int i = 0;
                                  i < _instructionTiles.length;
                                  i++) {
                                    (_instructionTiles[i] as PrivateRecipeInstructionTileComponent).recipeInstruction.step=i;
                                  }
                                  savePrivateRecipeManually();
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return _instructionTiles.firstWhere((
                                      element) =>
                                  (element as PrivateRecipeInstructionTileComponent)
                                      .recipeInstruction.step == index);
                                },
                                itemCount: _instructionTiles.length)
                          ],
                        )),
                  ],
                  expansionCallback: (i, isOpen) =>
                  {
                    setState(() {
                      _isOpen[i] = !isOpen;
                    })
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    onPressed: savePrivateRecipeManually,
                    child: Text(AppLocalizations
                        .of(context)
                        .save),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white), // <-- Button color
                    ))
              ],
            )));
  }

  List<Widget> getAllIngredientTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < privateRecipe.ingredients.length; i++) {
      myTiles.add(
        IngredientTileComponent(
          ingredient: privateRecipe.ingredients[i],
          apiToken: apiToken,
          textColor: Colors.black,
        ),
      );
    }
    return myTiles;
  }

  Future<void> _openAddIngredientScreen() async {
    print('addIngredientScreen');
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddIngredientPage(
                  privateRecipe: this.privateRecipe,
                ))).then((ingredient) => {loadPrivateRecipe(privateRecipeId)});
    print('addIngredientScreen completed');
  }

  Future<void> _openEditIngredientsAmountScreen() async {
    print('EditIngredientsAmountScreen');
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditIngredientsAmountPage(
                    privateRecipe: privateRecipe,
                    routedFromAddIngredient: false))).then((ghj) {
      setState(() {});
    });
    print('EditIngredientsAmountScreen completed');
  }

  Future<void> getToken() async {
    apiToken = await TokenStore().getToken();
  }

  Widget getIngredientGridView() {
    if (privateRecipe.ingredients.length == 0)
      return Container();
    else
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: new GridView.count(
            //     primary: true,
            //    padding: const EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            padding: EdgeInsets.all(10),
            crossAxisSpacing: 10,
            children: [
              ...getAllIngredientTiles()
              //
            ],
          ));
  }

  Widget getNutritionGridView() {
    if (privateRecipe.ingredients.length == 0)
      return Container();
    else
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: new GridView.count(
            //     primary: true,
            //    padding: const EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 3,
            crossAxisSpacing: 0,
            children: [
              ...getNutrientTiles()
              //
            ],
          ));
  }

  List<Widget> getNutrientTiles() {
    List<Widget> myTiles = [];
    myTiles.addAll([
      NutrientTileComponent(
          nutrientName: AppLocalizations
              .of(context)
              .calories,
          nutrientAmount: privateRecipe.nutrients.calories.toDouble(),
          dailyRecAmount: dailyCalories.toDouble(),
          nutritionType: NutritionType.CALORIES,
          textColor: Colors.black),
      NutrientTileComponent(
          nutrientName: AppLocalizations
              .of(context)
              .fat,
          nutrientAmount: privateRecipe.nutrients.fat,
          dailyRecAmount: dailyFat,
          nutritionType: NutritionType.FAT),
      NutrientTileComponent(
          nutrientName: AppLocalizations
              .of(context)
              .carbs,
          nutrientAmount: privateRecipe.nutrients.carbohydrate,
          dailyRecAmount: dailyCarbohydrate,
          nutritionType: NutritionType.CARBOHYDRATE),
      NutrientTileComponent(
          nutrientName: AppLocalizations
              .of(context)
              .protein,
          nutrientAmount: privateRecipe.nutrients.protein,
          dailyRecAmount: dailyProtein,
          nutritionType: NutritionType.PROTEIN)
    ]);

    return myTiles;
  }

  List<Widget> getInstructionTiles() {
    privateRecipe.instructions.sort((RecipeInstruction a, RecipeInstruction b) {
      return a.step.compareTo(b.step);
    });
    setState(() {
      _instructionTiles = [];
      for (int i = 0; i < privateRecipe.instructions.length; i++) {
        RecipeInstruction instruction = privateRecipe.instructions[i];
        print(instruction.step.toString() + " " + instruction.instructionsText);
        _instructionTiles.add(PrivateRecipeInstructionTileComponent(
            key: ValueKey(instruction.id), recipeInstruction: instruction));
      }
    });
    return _instructionTiles;
  }

  Future<void> openAddInstructionDialog() async {
    int lastStep = -1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AddRecipeInstructionDialog();
      },
    ).then((value) =>
    {
      if (value != null)
        {
          print("instruction " + value),
          privateRecipe.instructions.forEach((element) {
            if (element.step > lastStep) {
              lastStep = element.step;
            }
          }),
          privateRecipe.instructions.add(RecipeInstruction(
              id: 0,
              recipeId: privateRecipe.id,
              step: lastStep + 1,
              instructionsText: value)),
          savePrivateRecipeManually()
        }
    });
  }

  savePrivateRecipeManually() async {
    privateRecipe = await RecipeController.updatePrivateRecipe(privateRecipe);
    getInstructionTiles();
  }
}
