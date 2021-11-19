import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/ingredient-tile.component.dart';
import 'package:cookable_flutter/ui/pages/add-ingredient-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeEditPage extends StatefulWidget {
  final PrivateRecipe privateRecipe;

  RecipeEditPage(this.privateRecipe, {Key key}) : super(key: key);

  @override
  _RecipeEditPageState createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  List<bool> _isOpen = [false, false];
  List<Ingredient> ingredients = [];
  List<RecipeInstruction> instructions = [];
  String apiToken;
  PrivateRecipe privateRecipe;

  _RecipeEditPageState();

  @override
  void initState() {
    getToken();
    privateRecipe = widget.privateRecipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).recipeEdit)),
        body: Column(
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
                        IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 36,
                          onPressed: _openAddIngredientScreen,
                        ),
                        getIngredientGridView()
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
                    body: Text("Now Open 2")),
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
        ));
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
    await Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddIngredientPage()))
        .then((ingredient) => {
              if (ingredient is Ingredient)
                {
                  setState(() {
                    privateRecipe.ingredients.add(ingredient);
                  })
                }
            });
    print('addIngredientScreen completed');
  }

  Future<void> getToken() async {
    apiToken = await TokenStore().getToken();
  }

  Widget getIngredientGridView() {
    if (privateRecipe.ingredients.length == 0)
      return Container();
    else
      return Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: new GridView.count(
            //     primary: true,
            //    padding: const EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            padding: EdgeInsets.only(left: 10, right: 10),
            crossAxisSpacing: 10,
            children: [
              ...getAllIngredientTiles()
              //
            ],
          ));
  }
}
