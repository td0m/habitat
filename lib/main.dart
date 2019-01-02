import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/models/preferences.dart';
import 'package:habitat/pages/home_page.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(
      ScopedModel<HabitModel>(
        model: HabitModel(),
        child: ScopedModel<Preferences>(
          model: Preferences(),
          child: App(),
        ),
      ),
    );

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Preferences get _prefs =>
      ScopedModel.of<Preferences>(context, rebuildOnChange: true);

  _theme() {
    final dark = _prefs.darkMode;
    final amoled = _prefs.amoledDark;
    return ThemeData(
      primaryColor: Color(0xff1a73e8),
      accentColor: Color(0xff1a73e8),
      canvasColor:
          dark ? (amoled ? Colors.black : Color(0xFF202230)) : Colors.grey[50],
      cardColor: dark ? Colors.black : Colors.white,
      brightness: dark ? Brightness.dark : Brightness.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitat',
      theme: _theme(),
      home: HomePage(title: 'Habitat'),
    );
  }
}
