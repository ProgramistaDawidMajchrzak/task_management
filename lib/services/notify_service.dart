import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_management_go_online/services/task_management_db.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    configureLocalTimeZone();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => null);
  }


  static tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    const String timeZone = 'Europe/Warsaw';
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  /// Scheduled Notification
  static Future scheduledNotification({
    required int hour,
    required int minutes,
  }) async {
    final tasksDB = TaskManagementDB();
    int countTasks = await tasksDB.countTodaysPendingTasks();
    if (countTasks != 0) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'To do reminder',
        'You have $countTasks tasks to do today',
        _convertTime(hour, minutes),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            //sound: RawResourceAndroidNotificationSound(sound),
          ),
        ),
        //androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        //payload: 'It could be anything you pass',
      );
    }
  }

  // cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();
  // cancel(id) async => await flutterLocalNotificationsPlugin.cancel(id);
}
