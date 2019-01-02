import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/ui/rounded_checkbox.dart';
import 'package:habitat/utils/transpose.dart';
import 'package:scoped_model/scoped_model.dart';

class Calendar extends StatefulWidget {
  final DateTime startingDay;
  final int daysInMonth;
  Calendar({@required this.startingDay, @required this.daysInMonth});

  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  bool _getValue(int i) {
    final habitModel =
        ScopedModel.of<HabitModel>(context, rebuildOnChange: true);
    final habit = habitModel.habits.first;
    return habit.getValue(widget.startingDay.add(Duration(days: i))) ?? false;
  }

  _onChange(int i) => (bool v) {
        final habitModel =
            ScopedModel.of<HabitModel>(context, rebuildOnChange: true);
        final habits = habitModel.habits;
        habits.first.setValue(widget.startingDay.add(Duration(days: i)), v);
        habitModel.habits = habits;
      };

  List<Widget> _buildCalendar() {
    int wd = 0;
    int i = 1;

    List<List<Widget>> rows = [
      weekdays
          .map(
            (w) => Container(
                  child: Text(
                    w,
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 5, bottom: 9),
                ),
          )
          .toList(),
    ];
    List<Widget> row = [];
    // prefil the start
    while (wd < widget.startingDay.weekday - 1) {
      row.add(RoundCheckbox(disabled: true));
      wd++;
    }
    // fill days
    while (i <= widget.daysInMonth) {
      row.add(RoundCheckbox(
        placeholder: "$i",
        value: _getValue(i - 1),
        onChanged: _onChange(i - 1),
      ));
      i++;
      if (wd == 6) {
        rows.add(row);
        row = [];
        wd = 0;
      } else {
        wd++;
      }
    }
    // fill out the end
    while (wd <= 6) {
      row.add(RoundCheckbox(disabled: true));
      wd++;
    }
    rows.add(row);

    // switch rows with columns
    return transpose(rows)
        .map((col) => Column(
              mainAxisSize: MainAxisSize.min,
              children: col,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildCalendar(),
      ),
    );
  }
}
