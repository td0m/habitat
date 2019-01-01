import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/ui/calendar.dart';
import 'package:habitat/ui/create_habit_dialog.dart';
import 'package:habitat/ui/habit_list_item.dart';
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
        home: MyHomePage(title: 'Habitat'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CreateHabitDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitModel =
        ScopedModel.of<HabitModel>(context, rebuildOnChange: true);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Column(
              children: habitModel.habits
                  .map((h) => HabitListItem(
                        title: h.title,
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
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              Text(
                "Habitat",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
