import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/ui/repeat_input.dart';
import 'package:scoped_model/scoped_model.dart';

class EditHabitDialog extends StatefulWidget {
  final int index;
  EditHabitDialog({@required this.index});

  _EditHabitDialogState createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _repeatController = TextEditingController();
  TextEditingController _periodController = TextEditingController();

  HabitModel get habitModel =>
      ScopedModel.of<HabitModel>(context, rebuildOnChange: true);

  void initState() {
    super.initState();
    final habit = ScopedModel.of<HabitModel>(context).habits[widget.index];
    _titleController.text = habit.title;
    _repeatController.text = habit.repeat.toString();
    _periodController.text = habit.period.toString();
  }

  _saveChanges() {
    int repeat = int.parse(_repeatController.text);
    int period = int.parse(_periodController.text);
    if (repeat > period) repeat = period;
    if (repeat == period) {
      repeat = 1;
      period = 1;
    }

    habitModel.habits[widget.index].title = _titleController.text;
    habitModel.habits[widget.index].repeat = repeat;
    habitModel.habits[widget.index].period = period;
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
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          RepeatInput(
            repeatController: _repeatController,
            periodController: _periodController,
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
