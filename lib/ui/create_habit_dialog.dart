import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/ui/repeat_input.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateHabitDialog extends StatefulWidget {
  CreateHabitDialog(this.title, this.onSaved, this.initial);

  final String title;
  final Function(Habit) onSaved;
  final Habit initial;

  _CreateHabitDialogState createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<CreateHabitDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _repeatController = TextEditingController();
  TextEditingController _periodController = TextEditingController();
  String _repeat = "Every Day";
  bool _enableReminder = false;
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initial.title;
    _repeatController.text = widget.initial.repeat.toString();
    _periodController.text = widget.initial.period.toString();
    if (widget.initial.repeat != 1 || widget.initial.period != 1) {
      _repeat = "Custom";
    }
    if (widget.initial.repeat == 1 && widget.initial.period == 7) {
      _repeat = "Every Week";
    }
    _enableReminder = widget.initial.reminder;
    time = TimeOfDay(hour: widget.initial.hour, minute: widget.initial.minute);
  }

  void _createHabit() {
    int repeat = 1;
    int period = 1;

    if (_repeat == "Every Week") {
      repeat = 1;
      period = 7;
    } else if (_repeat == "Custom") {
      repeat = int.parse(_repeatController.text);
      period = int.parse(_periodController.text);
      if (repeat > period) repeat = period;
      if (repeat == period) {
        repeat = 1;
        period = 1;
      }
    }

    final habit = Habit(
      _titleController.text,
      widget.initial.map,
      repeat,
      period,
      _enableReminder,
      time.hour,
      time.minute,
    );

    widget.onSaved(habit);

    Navigator.of(context).pop();
  }

  _pickReminder() {
    showTimePicker(
      context: context,
      initialTime: time,
    ).then(
      (time) => setState(() {
            if (time != null) {
              this.time = time;
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        autovalidate: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                controller: _titleController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: "Repeat",
                  contentPadding: EdgeInsets.zero,
                ),
                baseStyle: TextStyle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _repeat,
                      style: TextStyle(),
                    ),
                    PopupMenuButton<String>(
                      initialValue: _repeat,
                      icon: Icon(Icons.arrow_drop_down),
                      onSelected: (value) => setState(() {
                            _repeat = value;
                          }),
                      itemBuilder: (BuildContext context) =>
                          ["Every Day", "Every Week", "Custom"]
                              .map((v) => PopupMenuItem<String>(
                                    value: v,
                                    child: Text(v),
                                  ))
                              .toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              _repeat == "Custom"
                  ? RepeatInput(
                      repeatController: _repeatController,
                      periodController: _periodController,
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Reminder", style: Theme.of(context).textTheme.subhead),
                  Switch(
                    value: _enableReminder,
                    onChanged: (v) => setState(() {
                          _enableReminder = v;
                        }),
                  ),
                ],
              ),
              _enableReminder
                  ? _InputDropdown(
                      labelText: "Reminder",
                      valueText: time.format(context),
                      onPressed: _pickReminder,
                    )
                  : Container()
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          color: Theme.of(context).primaryColor,
          textColor: Theme.of(context).primaryTextTheme.body1.color,
          child: Text("Save"),
          onPressed: _createHabit,
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key, this.child, this.labelText, this.valueText, this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: Theme.of(context).textTheme.body1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: Theme.of(context).textTheme.title),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
