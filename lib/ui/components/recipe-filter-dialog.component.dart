import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterRecipesDialog extends StatefulWidget {
  Diet diet;
  FilterRecipesDialog({this.diet});
  //final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  _FilterRecipesDialogState createState() => _FilterRecipesDialogState();
}

class _FilterRecipesDialogState extends State<FilterRecipesDialog> {
  Diet recipeDiet;
  _FilterRecipesDialogState();

  @override
  void initState() {
    recipeDiet = widget.diet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Recipes'),
      actions: <Widget>[
        DropdownButton<Diet>(
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          items: <Diet>[
            Diet.NORMAL,
            Diet.PESCATARIAN,
            Diet.VEGETARIAN,
            Diet.VEGAN
          ].map((Diet value) {
            return DropdownMenuItem<Diet>(
              value: value,
              child: Text(Utility.getTranslatedDiet(context, value)),
            );
          }).toList(),
          onChanged: (Diet newValue) async {
            setState(() {
              recipeDiet = newValue;
            });
            var prefs = await SharedPreferences.getInstance();
            prefs.setInt('recipeDietFilter', newValue.index);
          },
          value: recipeDiet,
        ),
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
