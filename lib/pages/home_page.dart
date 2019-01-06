import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/pages/settings_page.dart';
import 'package:habitat/ui/calendar.dart';
import 'package:habitat/ui/create_habit_dialog.dart';
import 'package:habitat/ui/habit_list_item.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool open = false;

  void _openSettings() {
    setState(() {
      open = true;
    });
    _scaffoldKey.currentState
        .showBottomSheet((BuildContext context) => SettingsPage())
        .closed
        .whenComplete(() {
      if (mounted) {
        setState(() {
          open = false;
        });
      }
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CreateHabitDialog(),
    );
  }

  _onHabitValueChanged(int index, int days, bool value) {
    final habitModel =
        ScopedModel.of<HabitModel>(context, rebuildOnChange: true);
    DateTime day = DateTime.now().subtract(Duration(days: days));
    final habits = habitModel.habits;
    habits[index].setValue(day, value);
    habitModel.habits = habits;
  }

  @override
  Widget build(BuildContext context) {
    final habitModel =
        ScopedModel.of<HabitModel>(context, rebuildOnChange: true);

    final habitList = List.generate(habitModel.habits.length, (i) => i)
        .map((index) => HabitListItem(
              index: index,
              onChanged: (i, v) => _onHabitValueChanged(index, i, v),
              habit: habitModel.habits[index],
            ));

    final labels = List.generate(6, (i) {
      DateTime day = DateTime.now().subtract(Duration(days: i));
      String weekday = weekdays[day.weekday - 1];
      return Container(
        width: 32,
        child: Text(
          "$weekday",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).textTheme.body1.color.withAlpha(0x77)),
        ),
      );
    });

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 23, top: 4, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: labels,
                  ),
                )
              ]..addAll(habitList),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4,
        shape: CircularNotchedRectangle(),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed:
                    open ? () => Navigator.of(context).pop() : _openSettings,
              )
            ],
          ),
        ),
      ),
    );
  }
}
