import 'package:cookable_flutter/core/caching/user_service.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeProfileNameDialog extends StatefulWidget {
  final ReducedUser user;

  ChangeProfileNameDialog(this.user);

  //final ValueChanged<List<String>> onSelectedCitiesListChanged;
  @override
  _ChangeProfileNameDialogState createState() =>
      _ChangeProfileNameDialogState();
}

class _ChangeProfileNameDialogState extends State<ChangeProfileNameDialog> {
  final TextEditingController _controller = TextEditingController();
  UserService userService = UserService();

  _ChangeProfileNameDialogState();

  @override
  void initState() {
    super.initState();
    _controller.text = this.widget.user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).changeRecipeName),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: AppLocalizations.of(context).recipeNameHint),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            AppLocalizations.of(context).okay,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            String username = _controller.value.text;
            if (username.isNotEmpty && username.trim().isNotEmpty) {
              String newName = await changeUserName(widget.user, username);
              Navigator.of(context).pop(newName);
            }
          },
        ),
        //Text(AppLocalizations.of(context).createRecipe, style: TextStyle(color: w),),
      ],
    );
  }

  Future<String> changeUserName(ReducedUser user, String username) async {
    var updatedUser =
        await UserController.updateUserData(UserDataEdit(displayName: username))
            .catchError((err) {
      print(err);
      return null;
    });
    var updatedUserName = updatedUser.displayName;
    return updatedUserName;
  }
}
