import 'dart:convert';
import 'dart:io';

import 'package:habitat/utils/get_month_start.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:date_format/date_format.dart';

part 'habit_model.g.dart';

@JsonSerializable(nullable: false)
class Habit {
  Habit(this.title, this.map, [this.period = 1, this.repeat = 1]);

  String title;
  Map<String, bool> map;
  int period;
  int repeat;

  String _getKey(DateTime date) => formatDate(date, [yyyy, '/', mm, '/', dd]);

  setValue(DateTime day, bool value) {
    String key = _getKey(day);
    map[key] = value;
    if (!value) map.remove(key);
  }

  bool getValue(DateTime day) {
    String key = _getKey(day);
    if (map.containsKey(key)) return map[key];
    return false;
  }

  int get streak {
    int count = 0;
    DateTime date = DateTime.now();
    if (map.containsKey(_getKey(date)) && map[_getKey(date)]) {
      count++;
    }
    date = date.subtract(Duration(days: 1));
    while (map.containsKey(_getKey(date)) && map[_getKey(date)]) {
      date = date.subtract(Duration(days: 1));
      count++;
    }

    return count;
  }

  int get30DayTotat([DateTime endingDate]) {
    if (endingDate == null) endingDate = DateTime.now();
    int total = 0;
    int i = 0;
    while (i < 30) {
      String key = _getKey(endingDate);
      if (map.containsKey(key) && map[key]) total++;
      endingDate = endingDate.subtract(Duration(days: 1));
      i++;
    }
    return total;
  }

  int thisMonthTotal(DateTime date) {
    int total = 0;
    int done = 0;
    DateTime start = getMonthStart(date);
    while (start.day <= date.day) {
      if (getValue(start)) done++;
      total++;
      start = start.add(Duration(days: 1));
    }
    return (done / total * 100).round();
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}

class HabitModel extends Model {
  List<Habit> _habits = [];

  HabitModel() {
    _fetchLocal();
  }

  Future<File> _getStorageFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File("${directory.path}/data.json");
    return file;
  }

  _fetchLocal() async {
    final file = await _getStorageFile();
    if (await file.exists()) {
      final String contents = await file.readAsString();
      final habits = (json.decode(contents)["habits"] as List)
          .map((h) => Habit.fromJson(h))
          .toList();
      this.habits = habits;
    }
  }

  Future<void> _updateLocal() async {
    final file = await _getStorageFile();
    await file.writeAsString(jsonEncode({
      "habits": habits.map((h) => h.toJson()).toList(),
    }));
  }

  importJson(String path) async {
    final local = await _getStorageFile();
    final newContent = await File(path).readAsString();
    await local.writeAsString(newContent);
    await _fetchLocal();
  }

  Future<String> getData() async {
    final file = await _getStorageFile();
    if (await file.exists()) {
      return await file.readAsString();
    }
    return "";
  }

  List<Habit> get habits => _habits;
  set habits(List<Habit> value) {
    _habits = value;
    notifyListeners();
    _updateLocal();
  }
}
