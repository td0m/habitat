import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends Model {
  String _theme = "Light";
  String get theme => _theme;
  set theme(String value) {
    _theme = value;
    notifyListeners();

    this.prefs.setString("theme", value);
  }

  bool _amoledDark = false;
  SharedPreferences prefs;

  Preferences() {
    fetchLocal();
  }

  bool get amoledDark => _amoledDark;
  set amoledDark(bool value) {
    this._amoledDark = value;
    notifyListeners();

    this.prefs.setBool("amoledDark", value);
  }

  fetchLocal() async {
    this.prefs = await SharedPreferences.getInstance();
    final amoledDark = prefs.getBool("amoledDark");
    if (amoledDark != null) this.amoledDark = amoledDark;
  }
}
