import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:cookable_flutter/ui/styles/glow_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String apiToken;

  _DashboardPageState();

  void getToken() async {
    // recipe = await RecipeController.getRecipe();
    apiToken = await TokenStore().getToken();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomPaint(
            foregroundPainter: BorderPainter(),
            child: Container(
              width: 300,
              height: 100,
            ),
          ),
          CustomPaint(
            foregroundPainter: BorderPainter(),
            child: Container(
              width: 300,
              height: 100,
            ),
          )
        ]);
  }


}
