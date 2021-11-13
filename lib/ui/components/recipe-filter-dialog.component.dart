import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterRecipesDialog extends StatefulWidget {
  FilterRecipesDialog({
    this.filterVegan,
    this.filterVegetarian,
    this.filterPescatarian,
    this.filterMeat,
  //  this.onSelectedCitiesListChanged,
  });

  // recipe filters
  bool filterVegetarian = true;
  bool filterVegan = true;
  bool filterPescatarian = true;
  bool filterMeat = true;
  //final ValueChanged<List<String>> onSelectedCitiesListChanged;

  @override
  _FilterRecipesDialogState createState() => _FilterRecipesDialogState(filterVegan: filterVegan,
      filterVegetarian: filterVegetarian, filterPescatarian: filterPescatarian, filterMeat: filterMeat);
}

class _FilterRecipesDialogState extends State<FilterRecipesDialog> {

  bool filterVegetarian = true;
  bool filterVegan = true;
  bool filterPescatarian = true;
  bool filterMeat = true;

  _FilterRecipesDialogState({this.filterVegan, this.filterVegetarian, this.filterPescatarian, this.filterMeat});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text('Filter Recipes'),
      actions: <Widget>[
        CheckboxListTile(
            title: Text("vegan"),
            value: filterVegan,
            onChanged: (bool value) {
              setState(() {
                filterVegan = value;
              });
            }),
        CheckboxListTile(
            title: Text("vegetarian"),
            value: filterVegetarian,
            onChanged: (bool value) {
              setState(() {
                filterVegetarian = value;
              });
            }),
        CheckboxListTile(
            title: Text("pescatarian"),
            value: filterPescatarian,
            onChanged: (bool value) {
              setState(() {
                filterPescatarian = value;
              });
            }),
        CheckboxListTile(
            title: Text("meat"),
            value: filterMeat,
            onChanged: (bool value) {
              setState(() {
                filterMeat = value;
              });
            }),
        TextButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}