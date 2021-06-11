import 'package:cookable_flutter/core/models/ingredient.model.dart';
import 'package:cookable_flutter/ui/components/fridge-tile.component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';

class FridgeComponent extends StatefulWidget {
  FridgeComponent({Key key}) : super(key: key);

  @override
  _FridgeComponentState createState() => _FridgeComponentState();
}

class _FridgeComponentState extends State<FridgeComponent> {
  List<Ingredient> ingredientsList = [];

  @override
  Widget build(BuildContext context) {
    ingredientsList.clear();
    Ingredient tomato =
        Ingredient('abc', 'assets/apple.png', 'Tomato', 500, 'kg');
    Ingredient avocado =
        Ingredient('def', 'assets/avocado.png', 'Avocado', 1, 'pcs');
    Ingredient baguette =
        Ingredient('ghi', 'assets/baguette.png', 'Baguette', 2, 'pcs');

    ingredientsList.add(tomato);
    ingredientsList.add(avocado);
    ingredientsList.add(baguette);
    ingredientsList.add(avocado);
    ingredientsList.add(baguette);
    ingredientsList.add(avocado);
    ingredientsList.add(avocado);
    ingredientsList.add(avocado);
    ingredientsList.add(avocado);

    return Container(
      color: Colors.black,
      child: new StaggeredGridView.countBuilder(
        shrinkWrap: true,
        crossAxisCount: 3,
        itemCount: ingredientsList.length,
        itemBuilder: (BuildContext context, int index) => new Container(
          child: new Center(
            child: FridgeTileComponent(
              ingredient: ingredientsList[index],
            ),
          ),
        ),
        staggeredTileBuilder: (int index) => new StaggeredTile.extent(
            2, (1 / 3) * MediaQuery.of(context).size.width),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
