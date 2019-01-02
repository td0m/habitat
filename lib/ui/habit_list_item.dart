import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/ui/rounded_checkbox.dart';

class HabitListItem extends StatelessWidget {
  final String title;
  final Habit habit;
  final void Function(int item, bool value) onChanged;
  HabitListItem({
    @required this.title,
    @required this.onChanged,
    @required this.habit,
  });

  _onChanged(int index, bool value) {
    if (onChanged != null) onChanged(index, value);
  }

  Widget _generateCheckbox(int i) => RoundCheckbox(
        value:
            habit.getValue(DateTime.now().subtract(Duration(days: i))) ?? false,
        size: 22,
        onChanged: (v) => _onChanged(i, v),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        child: InkWell(
          splashColor: Theme.of(context).primaryColorLight,
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title, style: TextStyle(fontSize: 16)),
                Row(
                  children: List.generate(6, _generateCheckbox),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedCheckbox {}
