import 'package:cookable_flutter/core/data/models.dart';
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
  final PrivateRecipe privateRecipe;

  RecipeEditPage(this.privateRecipe, {Key key}) : super(key: key);

  @override
  _RecipeEditPageState createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  List<bool> _isOpen = [false, false];
  String apiToken;
  PrivateRecipe privateRecipe;
  int dailyCalories;
  double dailyCarbohydrate;
  double dailyProtein;
  double dailyFat;

  _RecipeEditPageState();

  @override
  void initState() {
    getToken();
    loadDailyRequiredNutrients();
    privateRecipe = widget.privateRecipe;
    super.initState();
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
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).recipeEdit)),
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
                    isExpanded: _isOpen[0],
                    headerBuilder: (context, isOpen) {
                      return Text(
                        AppLocalizations.of(context).ingredients +
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
                                  shape:
                                      MaterialStateProperty.all(CircleBorder()),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.white), // <-- Button color,
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
                    isExpanded: _isOpen[1],
                    headerBuilder: (context, isOpen) {
                      return Text(
                          AppLocalizations.of(context).howToCookSteps +
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
                            shape: MaterialStateProperty.all(CircleBorder()),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(10)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white), // <-- Button color,
                          ),
                        ),
                        getInstructions()
                      ],
                    )),
              ],
              expansionCallback: (i, isOpen) => {
                setState(() {
                  _isOpen[i] = !isOpen;
                })
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => {},
                child: Text(AppLocalizations.of(context).save),
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
            builder: (context) => AddIngredientPage(
                  privateRecipe: this.privateRecipe,
                ))).then((ingredient) => {
          if (ingredient is Ingredient)
            {
              setState(() {
                privateRecipe.ingredients.add(ingredient);
              })
            }
          else
            setState(() {})
        });
    print('addIngredientScreen completed');
  }

  Future<void> _openEditIngredientsAmountScreen() async {
    print('EditIngredientsAmountScreen');
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditIngredientsAmountPage(
                ingredients: privateRecipe.ingredients,
                routedFromAddIngredient: false))).then((ingredients) => {
          print(ingredients),
          if (ingredients != null)
            {
              //    privateRecipe.ingredients.clear(),
              print(ingredients),
              setState(() {
                //        privateRecipe.ingredients.addAll(ingredients);
              })
            }
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
          nutrientName: AppLocalizations.of(context).calories,
          nutrientAmount: privateRecipe.nutrients.calories.toDouble(),
          dailyRecAmount: dailyCalories.toDouble(),
          nutritionType: NutritionType.CALORIES,
          textColor: Colors.black),
      NutrientTileComponent(
          nutrientName: AppLocalizations.of(context).fat,
          nutrientAmount: privateRecipe.nutrients.fat,
          dailyRecAmount: dailyFat,
          nutritionType: NutritionType.FAT),
      NutrientTileComponent(
          nutrientName: AppLocalizations.of(context).carbs,
          nutrientAmount: privateRecipe.nutrients.carbohydrate,
          dailyRecAmount: dailyCarbohydrate,
          nutritionType: NutritionType.CARBOHYDRATE),
      NutrientTileComponent(
          nutrientName: AppLocalizations.of(context).protein,
          nutrientAmount: privateRecipe.nutrients.protein,
          dailyRecAmount: dailyProtein,
          nutritionType: NutritionType.PROTEIN)
    ]);

    return myTiles;
  }

  Widget getInstructions() {
    if (privateRecipe.instructions.length == 0)
      return Container();
    else
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: getInstructionTiles());
  }

  List<Widget> getInstructionTiles() {
    List<Widget> instructionTiles = [];
    privateRecipe.instructions.sort((RecipeInstruction a, RecipeInstruction b) {
      return a.step.compareTo(b.step);
    });
    for (int i = 0; i < privateRecipe.instructions.length; i++) {
      RecipeInstruction instruction = privateRecipe.instructions[i];
      instructionTiles.add(PrivateRecipeInstructionTileComponent(
          recipeInstruction: instruction));
    }
    return instructionTiles;
  }

  Future<void> openAddInstructionDialog() async {
    int lastStep = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AddRecipeInstructionDialog();
      },
    ).then((value) => {
          if (value != null)
            {
              print("instruction " + value),
              privateRecipe.instructions.forEach((element) {
                if (element.step > lastStep) {
                  lastStep = element.step;
                }
              }),
              setState(() {
                privateRecipe.instructions.add(RecipeInstruction(
                    id: 0,
                    recipeId: privateRecipe.id,
                    step: lastStep + 1,
                    instructionsText: value));
              })
            }
        });
  }
}
