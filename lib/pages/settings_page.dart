import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/models/preferences.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Preferences get prefs =>
      ScopedModel.of<Preferences>(context, rebuildOnChange: true);

  _resetData() {
    final habitModel = ScopedModel.of<HabitModel>(context);
    habitModel.habits = [];
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 2,
            spreadRadius: -3,
            offset: Offset(0, -3),
          ),
        ],
      ),
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
                borderRadius: BorderRadius.circular(5),
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
                              color: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .color
                                  .withAlpha(0xaa),
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
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () => prefs.darkMode = !prefs.darkMode,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Theme",
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                            Text(
                              prefs.darkMode ? "Dark Theme" : "Light Theme",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: prefs.darkMode,
                        onChanged: (val) => prefs.darkMode = val,
                      )
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
