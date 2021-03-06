import 'package:cookable_flutter/core/caching/private_recipe_service.dart';
import 'package:cookable_flutter/core/caching/recipe_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/ingredient-tile.component.dart';
import 'package:cookable_flutter/ui/components/nutrient-tile.component.dart';
import 'package:cookable_flutter/ui/components/private-recipe/private-recipe-instruction-tile.component.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/add-ingredient-page.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/edit-ingredients-amount-page.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private-recipe-name-edit-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add-instruction-dialog.dart';

class RecipeEditPage extends StatefulWidget {
  final int privateRecipeId;

  RecipeEditPage(this.privateRecipeId, {Key key}) : super(key: key);

  @override
  _RecipeEditPageState createState() => _RecipeEditPageState(privateRecipeId);
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  List<bool> _isOpen = [true, true];
  List<Widget> _instructionTiles = [];
  DefaultNutrients defaultNutrients;
  RecipeService recipeService = RecipeService();
  PrivateRecipeService privateRecipeService = PrivateRecipeService();
  String apiToken;
  PrivateRecipe privateRecipe;
  int privateRecipeId;
  int dailyCalories = 0;
  double dailyCarbohydrate = 0;
  double dailyProtein = 0;
  double dailyFat = 0;
  int updateNutrientsKey = 0;
  int updateIngredientsKey = 1000;

  _RecipeEditPageState(this.privateRecipeId);

  @override
  void initState() {
    super.initState();
    getToken();
    loadDailyRequiredNutrients();
    privateRecipeService.getPrivateRecipes().then((privateRecipes) => {
          privateRecipe = privateRecipes
              .firstWhere((element) => element.id == privateRecipeId),
          getInstructionTiles(),
          setState(() {})
        });
  }

  void loadPrivateRecipe(int privateRecipeId) async {
    var updatedPrivateRecipe =
        await RecipeController.getPrivateRecipe(privateRecipeId);
    privateRecipeService.addOrUpdatePrivateRecipe(updatedPrivateRecipe);
    setState(() {
      privateRecipe = updatedPrivateRecipe;
      updateNutrientsKey++;
      updateIngredientsKey++;
    });
  }

  loadDailyRequiredNutrients() async {
    defaultNutrients = await recipeService.getDefaultNutrients();
    dailyCalories = defaultNutrients.recDailyCalories;
    dailyCarbohydrate = defaultNutrients.recDailyCarbohydrate;
    dailyProtein = defaultNutrients.recDailyProtein;
    dailyFat = defaultNutrients.recDailyFat;
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
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).recipeEdit,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.teal,
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Wrap(children: [
                  Text(privateRecipe.name,
                      style: TextStyle(fontSize: 26, height: 2)),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.teal,
                      size: 28,
                    ),
                    padding: EdgeInsets.only(top: 14),
                    onPressed: () => openChangeNameDialog(),
                  )
                ]),
                SizedBox(
                  height: 16,
                ),
                ExpansionPanelList(
                  elevation: 2,
                  expandedHeaderPadding: EdgeInsets.all(4),
                  dividerColor: Colors.green,
                  children: [
                    ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[0],
                        headerBuilder: (context, isOpen) {
                          return Text(
                            AppLocalizations.of(context).ingredients +
                                " (" +
                                privateRecipe.ingredients.length.toString() +
                                ")",
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          );
                        },
                        body: Column(
                          children: [
                            getIngredientGridView(),
                            getNutritionGridView()
                          ],
                        )),
                    ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[1],
                        headerBuilder: (context, isOpen) {
                          return Text(
                              AppLocalizations.of(context).howToCookSteps +
                                  " (" +
                                  privateRecipe.instructions.length.toString() +
                                  ")",
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center);
                        },
                        body: privateRecipe.instructions.length == 0
                            ? ElevatedButton(
                                onPressed: openAddInstructionDialog,
                                child: Text(
                                  "${AppLocalizations.of(context).addInstruction}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.teal), // <-- Button color,
                                ),
                              )
                            : Column(
                                children: [
                                  ReorderableListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      onReorder: (int oldIndex, int newIndex) {
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }
                                        setState(() {
                                          Widget oldItem = _instructionTiles
                                              .removeAt(oldIndex);
                                          _instructionTiles.insert(
                                              newIndex, oldItem);

                                          for (int i = 0;
                                              i < _instructionTiles.length;
                                              i++) {
                                            var tile = _instructionTiles[i]
                                                as PrivateRecipeInstructionTileComponent;
                                            var recipeInstruction =
                                                tile.recipeInstruction;
                                            recipeInstruction.step = i;
                                            tile.recipeInstruction =
                                                recipeInstruction;
                                          }
                                          savePrivateRecipeManually();
                                        });
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var instructionTile = _instructionTiles[
                                                index]
                                            as PrivateRecipeInstructionTileComponent;
                                        return Dismissible(
                                            key: ValueKey(
                                              instructionTile
                                                  .recipeInstruction.id,
                                            ),
                                            background: Container(
                                                color: Colors.red,
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 48,
                                                )),
                                            onDismissed: (direction) =>
                                                _onRecipeInstructionDismissed(
                                                    index, direction),
                                            child: instructionTile);
                                      },
                                      itemCount: _instructionTiles.length),
                                  ElevatedButton(
                                    onPressed: openAddInstructionDialog,
                                    child: Icon(
                                      Icons.add,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(10)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.teal), // <-- Button color,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              )),
                  ],
                  expansionCallback: (i, isOpen) => {
                    setState(() {
                      _isOpen[i] = !isOpen;
                    })
                  },
                ),
              ],
            )));
  }

  List<Widget> getAllIngredientTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < privateRecipe.ingredients.length; i++) {
      myTiles.add(
        IngredientEditTileComponent(
            ingredient: privateRecipe.ingredients[i],
            apiToken: apiToken,
            textColor: Colors.black,
            radius: 34.0,
            onTap: _openEditIngredientsAmountScreen),
      );
    }
    return myTiles;
  }

  void _onRecipeInstructionDismissed(index, direction) {
    setState(() {
      var tile = (_instructionTiles.removeAt(index)
          as PrivateRecipeInstructionTileComponent);
      privateRecipe.instructions
          .removeWhere((instr) => tile.recipeInstruction.id == instr.id);
      for (int i = index; i < _instructionTiles.length; i++) {
        var tile =
            _instructionTiles[i] as PrivateRecipeInstructionTileComponent;
        var recipeInstruction = tile.recipeInstruction;
        recipeInstruction.step = i;
        tile.recipeInstruction = recipeInstruction;
      }
    });
    savePrivateRecipeManually();
  }

  Future<void> _openAddIngredientScreen() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddIngredientPage(
                  privateRecipe: this.privateRecipe,
                ))).then((ingredient) => {loadPrivateRecipe(privateRecipeId)});
  }

  Future<void> _openEditIngredientsAmountScreen() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditIngredientsAmountPage(
                privateRecipe: privateRecipe,
                routedFromAddIngredient: false))).then((ghj) {
      loadPrivateRecipe(privateRecipeId);
    });
  }

  Future<void> getToken() async {
    apiToken = await TokenStore().getToken();
  }

  Widget getIngredientGridView() {
    return privateRecipe.ingredients.length == 0
        ? ElevatedButton(
            onPressed: _openAddIngredientScreen,
            child: Text(
              "${AppLocalizations.of(context).addIngredient}",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.teal), // <-- Button color,
            ),
          )
        : Card(
            key: ValueKey(updateIngredientsKey),
            elevation: 10,
            margin: EdgeInsets.all(10),
            child: Padding(
                padding: EdgeInsets.all(4),
                child: new GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      mainAxisExtent: 136),
                  shrinkWrap: true,
                  //     primary: true,
                  //    padding: const EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  itemCount: privateRecipe.ingredients.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == privateRecipe.ingredients.length) {
                      //
                      //  the last item is the addbutton
                      return Padding(
                          child: ElevatedButton(
                            onPressed: _openAddIngredientScreen,
                            child: Icon(
                              Icons.add,
                              size: 42,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder()),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(2)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.teal), // <-- Button color,
                            ),
                          ),
                          padding: EdgeInsets.only(
                              left: 14, right: 14, bottom: 30, top: 0));
                    } else
                      return IngredientEditTileComponent(
                          ingredient: privateRecipe.ingredients[index],
                          apiToken: apiToken,
                          textColor: Colors.black,
                          radius: 42.0,
                          onTap: _openEditIngredientsAmountScreen);
                  },
                  //
                )));
  }

  Widget getNutritionGridView() {
    if (privateRecipe.ingredients.length == 0)
      return Container();
    else
      return Card(
          key: ValueKey(updateNutrientsKey),
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

  List<Widget> getInstructionTiles() {
    privateRecipe.instructions.sort((RecipeInstruction a, RecipeInstruction b) {
      return a.step.compareTo(b.step);
    });
    List<Widget> updatedTiles = [];

    updatedTiles = [];
    for (int i = 0; i < privateRecipe.instructions.length; i++) {
      RecipeInstruction instruction = privateRecipe.instructions[i];
      updatedTiles.add(PrivateRecipeInstructionTileComponent(
          key: ValueKey(instruction.id), recipeInstruction: instruction));
    }
    setState(() {
      _instructionTiles = updatedTiles;
    });
  }

  Future<void> openChangeNameDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new ChangeRecipeNameDialog(privateRecipeId, privateRecipe.name);
      },
    ).then((newName) => {
          if (newName != null)
            {
              privateRecipe.name = newName,
              privateRecipeService.addOrUpdatePrivateRecipe(privateRecipe),
              setState(() {})
            }
        });
  }

  Future<void> openAddInstructionDialog() async {
    int lastStep = -1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AddRecipeInstructionDialog();
      },
    ).then((value) => {
          if (value != null && value.toString().isNotEmpty)
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
    // update recipe in the box
    privateRecipeService.addOrUpdatePrivateRecipe(privateRecipe);
    getInstructionTiles();
  }
}
