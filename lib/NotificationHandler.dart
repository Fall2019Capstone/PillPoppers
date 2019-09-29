import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Prescription.dart';
import 'main.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', 'All notifications', 'All notifications',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  static BuildContext context;

  static Future scheduleNotification(Prescription prescription) async {
    var scheduledNotificationDateTime =
        //new DateTime.now().add(new Duration(seconds: 5));
        prescription.alarmTime;
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        prescription.alarmID,
        'Prescription Time!',
        'It is time to take "' + prescription.name + '"',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  static Future scheduleDailyNotification(Prescription prescription) async {
    var timeOfDay = prescription.alarmTime;
    Time time = new Time(timeOfDay.hour, timeOfDay.minute, 0);

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        prescription.alarmID,
        'show daily title',
        'Daily notification shown at approximately ${time.hour}:${time.minute}:${time.second}',
        time,
        platformChannelSpecifics);
  }

  static void setupNotifications(BuildContext buildContext) {
    print("Setting up notifications...");
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    context = buildContext;
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new MyApp()),
    );
  }

  static Future disableAlarm(Prescription prescription) async {
    var futurePendingAlarms = retrieveNotifications();
    futurePendingAlarms.then((alarms) {
      for (int i = 0; i < alarms.length; i++) {
        if (alarms[i].id == prescription.alarmID) {
          print("Disabling alarm...");
          flutterLocalNotificationsPlugin.cancel(prescription.alarmID);
        }
      }
    });
  }

  static Future updateAlarm(Prescription prescription) async {
    var futurePendingAlarms = retrieveNotifications();
    futurePendingAlarms.then((alarms) {
      var alarm =
          alarms.firstWhere((alarm) => alarm.id == prescription.alarmID);
      flutterLocalNotificationsPlugin?.cancel(alarm.id);
    });
  }

  static Future<List<PendingNotificationRequest>>
      retrieveNotifications() async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new MyApp(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
