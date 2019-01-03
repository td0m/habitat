import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/models/preferences.dart';
import 'package:habitat/ui/confirm_dialog.dart';
import 'package:habitat/ui/settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Preferences get prefs =>
      ScopedModel.of<Preferences>(context, rebuildOnChange: true);

  HabitModel get habitModel =>
      ScopedModel.of<HabitModel>(context, rebuildOnChange: true);

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
    habitModel.habits = [];
  }

  _importData() async {
    String filePath = await FilePicker.getFilePath(
      type: FileType.ANY,
    );
    if (filePath == null) {
    } else if (path.extension(filePath) == ".json") {
      habitModel.importJson(filePath);
    } else {
      showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              title: "Invalid extension",
              description:
                  "JSON file required, instead given ${path.extension(filePath)}",
              onConfirm: () {},
            ),
      );
    }
  }

  _exportData() async {
    String filePath = await FilePicker.getFilePath(
      type: FileType.ANY,
    );
    if (path.extension(filePath) != ".json") {
      filePath = path.join(path.dirname(filePath), "habitat.exported.json");
      await File(filePath).create();
    }
    await File(filePath).writeAsString(await habitModel.getData());
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
            Setting(
              title: "Import Data",
              description: "Import data from a json file.",
              onTap: _importData,
            ),
            Setting(
              title: "Export Data",
              description: "Export data to a json file.",
              onTap: _exportData,
            ),
            Divider(),
            SettingsSection("Display"),
            Setting(
              title: "Theme",
              description: prefs.theme + " Theme",
              trailing: PopupMenuButton<String>(
                initialValue: prefs.theme,
                icon: Icon(Icons.arrow_drop_down),
                onSelected: (theme) => prefs.theme = theme,
                itemBuilder: (BuildContext context) =>
                    ["Light", "Dark", "Adaptive"]
                        .map((theme) => PopupMenuItem<String>(
                              value: theme,
                              child: Text(theme),
                            ))
                        .toList(),
              ),
            ),
            Setting(
              title: "Pure Blacks",
              description:
                  "Use pure black in dark mode. Saves battery on AMOLED displays.",
              onTap: () => prefs.amoledDark = !prefs.amoledDark,
              trailing: Switch(
                activeColor: themeData.primaryColor,
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
