import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitat/models/habit_model.dart';

class NotificationScheduler {
  static schedule(List<Habit> habits) async {
    // init
    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    final notifications = FlutterLocalNotificationsPlugin();
    notifications.initialize(initializationSettings);

    // schedule
    notifications.cancelAll();
    for (int i = 0; i < habits.length; i++) {
      Habit habit = habits[i];
      if (habit.reminder) {
        print("scheduling ${habit.title} at ${habit.hour}:${habit.minute}");
        final time = Time(habit.hour, habit.minute, 0);
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
  }
}
