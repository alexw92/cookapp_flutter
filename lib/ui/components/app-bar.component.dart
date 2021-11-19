import 'package:cookable_flutter/ui/styles/app-theme.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  static const _appBarHeight = 70.0;
  AppBarComponent({this.title})
      : preferredSize = Size.fromHeight(_appBarHeight);

  final String title;
  @override
  final Size preferredSize; // default is 56.0

  @override
  _AppBarComponentState createState() => _AppBarComponentState(title: title);
}

class _AppBarComponentState extends State<AppBarComponent> {
  String title;

  _AppBarComponentState({this.title});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.green,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Center(
              child: Text(
                title,
                style: MyAppTheme.largeBoldFont,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
