import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:habitat/services/notification_scheduler.dart';
import 'package:habitat/utils/get_month_start.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:date_format/date_format.dart';

part 'habit_model.g.dart';

@JsonSerializable(nullable: false)
class Habit {
  Habit([
    String title,
    Map<String, bool> map,
    int repeat,
    int period,
    bool reminder,
    int hour,
    int minute,
  ])  : this.title = title ?? "",
        this.map = map ?? {},
        this.repeat = repeat ?? 1,
        this.period = period ?? 1,
        this.reminder = reminder ?? false,
        this.hour = hour ?? 0,
        this.minute = minute ?? 0;

  String title;
  Map<String, bool> map;
  int period;
  int repeat;

  bool reminder;
  int hour;
  int minute;

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
    DateTime date = DateTime.now();

    int h = period;
    int i = 0;
    bool first = true;
    int last = 0;

    while (h > (repeat - 1)) {
      if (getValue(date) || first) {
        last = i;
        h = min(h + 1, period);
      } else
        h--;

      if (!first || getValue(date)) i++;
      first = false;
      date = date.subtract(Duration(days: 1));
    }

    return last + 1;
  }

  bool get expiresToday {
    DateTime date = DateTime.now();
    int i = 0;
    while (!getValue(date) && i <= period) {
      date = date.subtract(Duration(days: 1));
      i++;
    }
    return i + repeat - 1 == period;
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
    return min((done * (period / repeat) / total * 100).round(), 100);
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
    NotificationScheduler.schedule(value);
  }
}
