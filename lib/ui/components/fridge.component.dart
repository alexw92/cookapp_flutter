import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/components/fridge-tile.component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FridgeComponent extends StatefulWidget {
  FridgeComponent({Key key}) : super(key: key);

  @override
  _FridgeComponentState createState() => _FridgeComponentState();
}

class _FridgeComponentState extends State<FridgeComponent> {
  List<UserFoodProduct> userFoodProductList = [];
  String apiToken;

  void loadFoodProducts() async{
    userFoodProductList = await UserFoodProductController.getUserFoodProducts();
    apiToken = await TokenStore().getToken();
    setState(() {

    });
  }

  @override
  void initState(){
    super.initState();
    loadFoodProducts();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.black,
    //   child: new StaggeredGridView.countBuilder(
    //     shrinkWrap: true,
    //     crossAxisCount: 3,
    //     itemCount: ingredientsList.length,
    //     itemBuilder: (BuildContext context, int index) => new Container(
    //       child: new Center(
    //         child: FridgeTileComponent(
    //           ingredient: ingredientsList[index],
    //         ),
    //       ),
    //     ),
    //     staggeredTileBuilder: (int index) => new StaggeredTile.extent(
    //         2, (1 / 3) * MediaQuery.of(context).size.width),
    //     mainAxisSpacing: 4.0,
    //     crossAxisSpacing: 4.0,
    //   ),

    return Container(
      color: Colors.blueGrey,
      child: Container(
       // height: 400,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GridView.count(
          primary: true,
          padding: const EdgeInsets.all(0),
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          children: [...getAllTiles()],
        ),
      ),
    );
  }

  List<Widget> getAllTiles() {
    List<Widget> myTiles = [];
    for (int i = 0; i < userFoodProductList.length; i++) {
      myTiles.add(
        FridgeTileComponent(
          userFoodProduct: userFoodProductList[i],
            apiToken: apiToken
        ),
      );
    }
    return myTiles;
  }
}
