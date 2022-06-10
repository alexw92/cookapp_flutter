import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRecipeInstructionDialog extends StatefulWidget {
  AddRecipeInstructionDialog();

  @override
  _AddRecipeInstructionDialogState createState() =>
      _AddRecipeInstructionDialogState();
}

class _AddRecipeInstructionDialogState
    extends State<AddRecipeInstructionDialog> {
  final TextEditingController _controller = TextEditingController();

  _AddRecipeInstructionDialogState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).addInstruction),
      content: TextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 1000,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).newRecipeInstructionSample,
            suffixIcon: Icon(Icons.edit, color: Colors.teal,),
          )),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'Okay',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            String instruction = _controller.value.text;
            Navigator.of(context).pop(instruction);
          },
        )
      ],
    );
  }
}
