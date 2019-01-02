import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/pages/habit_detail_page.dart';
import 'package:habitat/ui/rounded_checkbox.dart';

class HabitListItem extends StatefulWidget {
  final Habit habit;
  final int index;
  final void Function(int item, bool value) onChanged;
  HabitListItem({
    @required this.onChanged,
    @required this.habit,
    @required this.index,
  });

  _HabitListItemState createState() => _HabitListItemState();
}

class _HabitListItemState extends State<HabitListItem> {
  _onChanged(int index, bool value) {
    if (widget.onChanged != null) widget.onChanged(index, value);
  }

  Widget _generateCheckbox(int i) => RoundCheckbox(
        value:
            widget.habit.getValue(DateTime.now().subtract(Duration(days: i))) ??
                false,
        size: 24,
        onChanged: (v) => _onChanged(i, v),
      );

  _handleTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext builder) => HabitDetailPage(index: widget.index),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          splashColor: Theme.of(context).primaryColorLight,
          onTap: _handleTap,
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.habit.title,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 17)),
                    widget.habit.streak >= 3
                        ? Text(
                            "${widget.habit.streak}🔥",
                            style: Theme.of(context).textTheme.body1,
                          )
                        : Container(),
                  ],
                ),
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
