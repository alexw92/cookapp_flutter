import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/ingredient-tile.component.dart';
import 'package:cookable_flutter/ui/pages/add-ingredient-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeCreationPage extends StatefulWidget {
  RecipeCreationPage({Key key}) : super(key: key);

  @override
  _RecipeCreationPageState createState() => _RecipeCreationPageState();
}

class _RecipeCreationPageState extends State<RecipeCreationPage> {
  List<bool> _isOpen = [false, false];
  List<Ingredient> ingredients = [];
  List<RecipeInstruction> instructions = [];
  String apiToken;

  _RecipeCreationPageState();

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context).recipeCreation)),
        body: Column(
          children: [
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
                            ingredients.length.toString() +
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
                        Container(
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
                            ))
                      ],
                    )),
                ExpansionPanel(
                    isExpanded: _isOpen[1],
                    headerBuilder: (context, isOpen) {
                      return Text(
                          AppLocalizations.of(context).howToCookSteps +
                              " (" +
                              instructions.length.toString() +
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
                child: Text("Save"),
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
    for (int i = 0; i < ingredients.length; i++) {
      myTiles.add(
        IngredientTileComponent(
            ingredient: ingredients[i], apiToken: apiToken, textColor: Colors.black,),
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
                    ingredients.add(ingredient);
                  })
                }
            });
    print('addIngredientScreen completed');
  }

  Future<void> getToken() async {
    apiToken = await TokenStore().getToken();
  }

}
