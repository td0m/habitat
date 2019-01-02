import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _resetData() {
    final habitModel = ScopedModel.of<HabitModel>(context);
    habitModel.habits = [];
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 2,
          spreadRadius: -3,
          offset: Offset(0, -3),
        )
      ]),
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 40, right: 10, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Settings',
              style: themeData.textTheme.headline,
            ),
            Divider(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _resetData,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Reset Data",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Includes all your habits and settings.",
                            style: TextStyle(
                              color: Colors.black.withAlpha(0xaa),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
