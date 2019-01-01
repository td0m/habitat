import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitat/ui/rounded_checkbox.dart';

void main() => runApp(App());

final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitat',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blue,
        canvasColor: Colors.white,
      ),
      home: MyHomePage(title: 'Habitat'),
    );
  }
}

List<List<T>> transpose<T>(List<List<T>> list) {
  List<List<T>> out = [];
  for (int i = 0; i < list.first.length; i++) {
    if (i >= out.length) out.add(List.filled(list.length, null));
    for (int j = 0; j < list.length; j++) {
      out[i][j] = list[j][i];
    }
  }
  return out;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black26,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  List<Widget> _buildCalendar() {
    int swd = 1;
    int length = 31;

    int wd = 0;
    int i = 1;

    List<List<Widget>> rows = [
      weekdays
          .map(
            (w) => Container(
                  child: Text(
                    w,
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 5, bottom: 9),
                ),
          )
          .toList(),
    ];
    List<Widget> row = [];
    // prefil the start
    while (wd < swd) {
      row.add(RoundCheckbox(disabled: true));
      wd++;
    }
    // fill days
    while (i <= length) {
      row.add(RoundCheckbox(placeholder: "$i"));
      i++;
      if (wd == 6) {
        rows.add(row);
        row = [];
        wd = 0;
      } else {
        wd++;
      }
    }
    // fill out the end
    while (wd <= 6) {
      row.add(RoundCheckbox(disabled: true));
      wd++;
    }
    rows.add(row);

    // switch rows with columns
    return transpose(rows)
        .map((col) => Column(
              mainAxisSize: MainAxisSize.min,
              children: col,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffcccccc),
              boxShadow: [
                BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 4)
              ]),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildCalendar(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
