import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRecipeInstructionDialog extends StatefulWidget {
  AddRecipeInstructionDialog();

  @override
  _AddRecipeInstructionDialogState createState() => _AddRecipeInstructionDialogState();
}

class _AddRecipeInstructionDialogState extends State<AddRecipeInstructionDialog> {
  final TextEditingController _controller = TextEditingController();
  _AddRecipeInstructionDialogState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Instruction'),
      content: TextField(controller: _controller,),
      actions: <Widget>[
        TextButton(
          child: Text('Okay'),
          onPressed: () {
            String instruction = _controller.value.text;
            Navigator.of(context).pop(instruction);
          },
        ),
      ],
    );
  }
}
