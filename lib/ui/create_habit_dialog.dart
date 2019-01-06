import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateHabitDialog extends StatefulWidget {
  _CreateHabitDialogState createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<CreateHabitDialog> {
  String _name;
  String _repeat = "Every Day";
  TextEditingController _repeatController;
  TextEditingController _periodController;

  @override
  void initState() {
    super.initState();
    _repeatController = TextEditingController(text: "1");
    _periodController = TextEditingController(text: "7");
  }

  void _createHabit() {
    final habitModel = ScopedModel.of<HabitModel>(context);

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
      _name,
      {},
      repeat,
      period,
    );

    print(habit);

    habitModel.habits = habitModel.habits..add(habit);

    Navigator.of(context).pop();
  }

  _handleNameChange(String name) {
    setState(() {
      _name = name;
    });
  }

  String _repeatValidator(String s) {
    print(s);
    if (s == null) return null;
    final i = int.parse(s);
    if (i > int.parse(_periodController.text)) {
      return "Repeat cannot be larger than the period";
    }
    return null;
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
          Row(
            children: _repeat == "Custom"
                ? <Widget>[
                    Text("Repeat"),
                    Container(
                      width: 40,
                      child: TextFormField(
                        validator: _repeatValidator,
                        keyboardType: TextInputType.number,
                        controller: _repeatController,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text("times in"),
                    Container(
                      width: 40,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _periodController,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text("days."),
                  ]
                : [],
          )
        ],
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
          child: Text("Create"),
          onPressed: _name == null || _name.length == 0 ? null : _createHabit,
        ),
      ],
    );
  }
}
