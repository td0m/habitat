import 'package:scoped_model/scoped_model.dart';

class Habit {
  final String title;
  Habit(this.title);
}

class HabitModel extends Model {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;
  set habits(List<Habit> value) {
    _habits = value;
    notifyListeners();
  }
}
