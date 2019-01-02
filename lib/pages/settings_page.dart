import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/models/preferences.dart';
import 'package:habitat/ui/confirm_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Preferences get prefs =>
      ScopedModel.of<Preferences>(context, rebuildOnChange: true);

  _confirmResetData() async {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
            title: "Reset Application Data",
            description:
                "Are you sure you'd like to reset all your app data? This action cannot be undone and will delete all your progress.",
            onConfirm: _resetData,
          ),
    );
  }

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
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            SettingsSection("Account"),
            Setting(
              title: "Reset Data",
              description: "Includes all your habits and settings.",
              onTap: _confirmResetData,
            ),
            Divider(),
            SettingsSection("Display"),
            Setting(
              title: "Theme",
              description: prefs.darkMode ? "Dark Theme" : "Light Theme",
              onTap: () => prefs.darkMode = !prefs.darkMode,
              trailing: Switch(
                value: prefs.darkMode,
                onChanged: (val) => prefs.darkMode = val,
              ),
            ),
            Setting(
              title: "Pure Blacks",
              description:
                  "Use pure black in dark mode. Saves battery on AMOLED displays.",
              onTap: () => prefs.amoledDark = !prefs.amoledDark,
              trailing: Switch(
                value: prefs.amoledDark,
                onChanged: (val) => prefs.amoledDark = val,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String description;
  final Widget trailing;
  Setting({
    @required this.onTap,
    @required this.title,
    @required this.description,
    Widget trailing,
  }) : this.trailing = trailing ?? Text("");

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      description,
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
              ),
              trailing
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String text;
  SettingsSection(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3, top: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.body2.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }
}
