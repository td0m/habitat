import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/pages/home_page.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<HabitModel>(
      model: HabitModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habitat',
        theme: ThemeData(
          primaryColor: Colors.lightBlue.shade600,
          accentColor: Colors.lightBlue.shade600,
          canvasColor: Color(0xfff5f5f5),
        ),
        home: HomePage(title: 'Habitat'),
      ),
    );
  }
}
