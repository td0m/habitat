import 'package:flutter/material.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/ui/calendar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class HabitDetailPage extends StatefulWidget {
  final int index;
  HabitDetailPage({@required this.index});

  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  List<CircularStackEntry> _buildData(double percentageComplete) =>
      <CircularStackEntry>[
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              percentageComplete,
              Theme.of(context).primaryColor,
              rankKey: 'complete',
            ),
            CircularSegmentEntry(
              100 - percentageComplete,
              Colors.black26,
              rankKey: 'incomplete',
            ),
          ],
          rankKey: 'Last 30 days',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final habitModel =
        ScopedModel.of<HabitModel>(context, rebuildOnChange: true);
    final habit = habitModel.habits[widget.index];

    final thisMonth = habit.thisMonthTotal(DateTime.now());
    if (_chartKey.currentState != null)
      _chartKey.currentState.updateData(_buildData(thisMonth.toDouble()));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(habit.title),
            Text("${habit.streak}🔥",
                style: Theme.of(context).primaryTextTheme.body1),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "This month",
                  style: Theme.of(context).textTheme.title,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Calendar(date: DateTime.now(), index: widget.index),
                  ],
                ),
                Text(
                  "Overview",
                  style: Theme.of(context).textTheme.title,
                ),
                Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("This month",
                              style: Theme.of(context).textTheme.subhead),
                          Text("$thisMonth%"),
                        ],
                      ),
                      AnimatedCircularChart(
                        key: _chartKey,
                        holeRadius: 10,
                        edgeStyle: SegmentEdgeStyle.round,
                        size: Size(50, 50),
                        initialChartData: _buildData(thisMonth.toDouble()),
                        chartType: CircularChartType.Radial,
                        percentageValues: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
