import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EditHabitDialog extends StatefulWidget {
  final int index;
  EditHabitDialog({@required this.index});

  _EditHabitDialogState createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  TextEditingController _titleController = TextEditingController();

  HabitModel get habitModel =>
      ScopedModel.of<HabitModel>(context, rebuildOnChange: true);

  _saveChanges() {
    habitModel.habits[widget.index].title = _titleController.text;
    habitModel.habits = habitModel.habits;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Habit"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            controller: _titleController,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Discard"),
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Theme.of(context).primaryTextTheme.body1.color,
          onPressed: _saveChanges,
          child: Text("Save"),
        )
      ],
    );
  }
}
