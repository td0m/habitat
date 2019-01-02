import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/ui/calendar.dart';
import 'package:scoped_model/scoped_model.dart';

class HabitDetailPage extends StatefulWidget {
  final int index;
  HabitDetailPage({@required this.index});

  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  @override
  Widget build(BuildContext context) {
    final habitModel = ScopedModel.of<HabitModel>(context);
    final habit = habitModel.habits[widget.index];

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Text(habit.title, style: Theme.of(context).textTheme.display2),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
