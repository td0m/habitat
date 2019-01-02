import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateHabitDialog extends StatefulWidget {
  _CreateHabitDialogState createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<CreateHabitDialog> {
  String _name;

  void _createHabit() {
    final habitModel = ScopedModel.of<HabitModel>(context);
    habitModel.habits = habitModel.habits..add(Habit(_name, {}));
    Navigator.of(context).pop();
  }

  _handleNameChange(String name) {
    setState(() {
      _name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create habit"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "Name"),
            onChanged: _handleNameChange,
            autofocus: true,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Theme.of(context).textTheme.body1.color,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child:
              Text("Create", style: Theme.of(context).primaryTextTheme.body1),
          onPressed: _name == null || _name.length == 0 ? null : _createHabit,
        ),
      ],
    );
  }
}
