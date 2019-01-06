import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitat/models/habit_model.dart';
import 'package:habitat/models/preferences.dart';
import 'package:habitat/pages/home_page.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(
      ScopedModel<HabitModel>(
        model: HabitModel(),
        child: ScopedModel<Preferences>(
          model: Preferences(),
          child: App(),
        ),
      ),
    );

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FlutterLocalNotificationsPlugin notifications;

  Preferences get _prefs =>
      ScopedModel.of<Preferences>(context, rebuildOnChange: true);

  HabitModel get _habits => ScopedModel.of<HabitModel>(context);

  void initState() {
    super.initState();
    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    notifications = FlutterLocalNotificationsPlugin();
    notifications.initialize(initializationSettings);

    _scheduleNotifications();
  }

  _scheduleNotifications() async {
    notifications.cancelAll();
    final habits = _habits.habits;
    for (int i = 0; i < habits.length; i++) {
      final time = Time(20, 9 + i, 0);
      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description',
      );
      final iOSPlatformChannelSpecifics = IOSNotificationDetails();
      final platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await notifications.showDailyAtTime(
          i, habits[i].title, '', time, platformChannelSpecifics);
    }
  }

  _theme() {
    final now = DateTime.now();
    final isDarkOutside = now.hour > 21 || now.hour < 7;
    final dark =
        _prefs.theme == "Dark" || _prefs.theme == "Adaptive" && isDarkOutside;
    final amoled = _prefs.amoledDark;

    return ThemeData(
      primaryColor: Color(0xff1a73e8),
      accentColor: Color(0xff1a73e8),
      canvasColor:
          dark ? (amoled ? Colors.black : Color(0xFF202230)) : Colors.grey[50],
      cardColor: dark ? Colors.black : Colors.white,
      brightness: dark ? Brightness.dark : Brightness.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    _scheduleNotifications();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitat',
      theme: _theme(),
      home: HomePage(title: 'Habitat'),
    );
  }
}
