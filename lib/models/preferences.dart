import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends Model {
  bool _darkMode = false;
  bool _amoledDark = false;
  SharedPreferences prefs;

  Preferences() {
    fetchLocal();
  }

  bool get darkMode => _darkMode;
  set darkMode(bool dark) {
    this._darkMode = dark;
    notifyListeners();

    // save
    this.prefs.setBool("darkTheme", dark);
  }

  bool get amoledDark => _amoledDark;
  set amoledDark(bool value) {
    this._amoledDark = value;
    notifyListeners();

    this.prefs.setBool("amoledDark", value);
  }

  fetchLocal() async {
    this.prefs = await SharedPreferences.getInstance();
    final darkMode = prefs.getBool("darkTheme");
    if (darkMode != null) this.darkMode = darkMode;
    final amoledDark = prefs.getBool("amoledDark");
    if (amoledDark != null) this.amoledDark = amoledDark;
  }
}
