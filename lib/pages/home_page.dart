import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/pages/settings_page.dart';
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

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Column(
              children: List.generate(habitModel.habits.length, (i) => i)
                  .map((index) => HabitListItem(
                        title: habitModel.habits[index].title,
                        onChanged: (i, v) => _onHabitValueChanged(index, i, v),
                        habit: habitModel.habits[index],
                      ))
                  .toList(),
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
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                    color: Colors.black.withAlpha(0xbb),
                  ),
                  Text(
                    "Habitat",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.black.withAlpha(0xbb)),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed:
                    open ? () => Navigator.of(context).pop() : _openSettings,
                color: Colors.black.withAlpha(0xbb),
              )
            ],
          ),
        ),
      ),
    );
  }
}
