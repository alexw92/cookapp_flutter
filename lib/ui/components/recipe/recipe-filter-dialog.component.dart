import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterRecipesDialog extends StatefulWidget {
  Diet diet;
  bool filterHighProtein;
  bool filterHighCarb;

  FilterRecipesDialog({this.diet, this.filterHighProtein, this.filterHighCarb});

  @override
  _FilterRecipesDialogState createState() => _FilterRecipesDialogState();
}

class _FilterRecipesDialogState extends State<FilterRecipesDialog> {
  Diet recipeDiet;
  bool filterHighProtein;
  bool filterHighCarb;

  _FilterRecipesDialogState();

  @override
  void initState() {
    recipeDiet = widget.diet;
    filterHighProtein = widget.filterHighProtein;
    filterHighCarb = widget.filterHighCarb;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).filterRecipes),
      actions: <Widget>[
        Column(children: [
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
          FilterNutritionWidget(
            isSelectedHighCarb: filterHighCarb,
            isSelectedHighProtein: filterHighProtein,
          )
        ]),
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

class FilterNutritionWidget extends StatefulWidget {
  const FilterNutritionWidget(
      {Key key, this.isSelectedHighProtein, this.isSelectedHighCarb})
      : super(key: key);
  final bool isSelectedHighProtein;
  final bool isSelectedHighCarb;

  @override
  State<FilterNutritionWidget> createState() => _FilterNutritionWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _FilterNutritionWidgetState extends State<FilterNutritionWidget> {
  bool _isSelectedHighProtein;
  bool _isSelectedHighCarb;

  @override
  void initState() {
    _isSelectedHighProtein = widget.isSelectedHighProtein;
    _isSelectedHighCarb = widget.isSelectedHighCarb;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      HighProteinCheckbox(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        value: _isSelectedHighProtein,
        onChanged: (bool newValue) {
          SharedPreferences.getInstance()
              .then((prefs) => {
                prefs.setBool('highProteinFilter', newValue),
                print("highProteinFilter after set "+prefs.getBool('highProteinFilter').toString())
              });
          setState(() {
            _isSelectedHighProtein = newValue;
          });
        },
      ),
      HighCarbCheckbox(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        value: _isSelectedHighCarb,
        onChanged: (bool newValue) {
          SharedPreferences.getInstance()
              .then((prefs) => {
                prefs.setBool('highCarbFilter', newValue),
                print("highCarbFilter after set "+prefs.getBool('highCarbFilter').toString())
          });
          setState(() {
            _isSelectedHighCarb = newValue;
          });
        },
      )
    ]);
  }
}

class HighProteinCheckbox extends StatelessWidget {
  const HighProteinCheckbox({
    Key key,
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Chip(
              labelPadding: EdgeInsets.all(4.0),
              avatar: Icon(
                Icons.fitness_center,
              ),
              label: Text(
                AppLocalizations.of(context).highProtein,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: EdgeInsets.all(8.0),
            )),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HighCarbCheckbox extends StatelessWidget {
  const HighCarbCheckbox({
    Key key,
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Chip(
              labelPadding: EdgeInsets.all(4.0),
              avatar: Icon(
                Icons.fitness_center,
              ),
              label: Text(
                AppLocalizations.of(context).highCarb,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: EdgeInsets.all(8.0),
            )),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
