import 'dart:convert';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:date_format/date_format.dart';

part 'habit_model.g.dart';

@JsonSerializable(nullable: false)
class Habit {
  final String title;
  final Map<String, bool> map;
  Habit(this.title, this.map);

  String _getKey(DateTime date) => formatDate(date, [yyyy, '/', mm, '/', dd]);

  setValue(DateTime day, bool value) {
    String key = _getKey(day);
    map[key] = value;
  }

  bool getValue(DateTime day) {
    String key = _getKey(day);
    if (map.containsKey(key)) return map[key];
    return null;
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
      print(json.decode(contents)["habits"]);
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

  Future<void> _clear() async {
    habits = [];
    _updateLocal();
  }

  List<Habit> get habits => _habits;
  set habits(List<Habit> value) {
    _habits = value;
    notifyListeners();
    _updateLocal();
  }
}
