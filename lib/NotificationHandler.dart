import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Alarm.dart';
import 'Prescription.dart';
import 'main.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', 'All notifications', 'All notifications',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  static BuildContext context;

  static Future schedulePrescriptionNotifications(
      Prescription prescription) async {

    List<int> alarmIDs = new List<int>();

    if (prescription.alarm != null) {
      for (int i = 0; i < prescription.alarm.alarmIDs.length; i++) {
        flutterLocalNotificationsPlugin.cancel(prescription.alarm.alarmIDs[i]);
      }
    }

    if (prescription.daily) {
      print("Making daily alarm");
      alarmIDs = await getNextIDs(1);
      print("Got id: " + alarmIDs[0].toString());
      prescription.alarm.alarmIDs = alarmIDs;

      //alarm = new Alarm(alarmIDs, prescription.alarmTime, AlarmType.Daily);
      scheduleDailyNotificationAlarm(prescription.alarm);
    } else {
      print("Making weekly alarm");
      int alarmsNeeded = 0;
      for (int i = 0; i < 7; i++) {
        if (prescription.alarm.days[i]) {
          alarmsNeeded++;
        }
      }
      alarmIDs = await getNextIDs(alarmsNeeded);
      prescription.alarm.alarmIDs = alarmIDs;

      int alarmIDIndex = 0;
      for (int i = 0; i < 7; i++) {
        if (prescription.alarm.days[i]) {
          scheduleWeeklyNotificationAlarm(prescription.alarm, alarmIDs[alarmIDIndex], days[i]);
          alarmIDIndex++;
        }
      }
    }
  }

  static List<Day> days = [
    Day.Sunday,
    Day.Monday,
    Day.Tuesday,
    Day.Wednesday,
    Day.Thursday,
    Day.Friday,
    Day.Saturday
  ];

  static Future scheduleDailyNotificationAlarm(Alarm alarm) async {
    var timeOfDay = alarm.timeToAlert;
    Time time = new Time(timeOfDay.hour, timeOfDay.minute, 0);

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(alarm.alarmIDs[0],
        alarm.title, alarm.body, time, platformChannelSpecifics);
  }

  static Future scheduleWeeklyNotificationAlarm(
      Alarm alarm, int id, Day day) async {
    var time = new Time(alarm.timeToAlert.hour, alarm.timeToAlert.minute, 0);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print(alarm.title);
    print(id);
    print("Setting notification : " + alarm.title + ", id : " + id.toString());
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id, alarm.title, alarm.body, day, time, platformChannelSpecifics);
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
        if (alarms[i].id == prescription.prescriptionID) {
          print("Disabling alarm...");
          print(alarms[i].title);
          flutterLocalNotificationsPlugin.cancel(prescription.prescriptionID);
        }
      }
    });
  }

  static Future disableAllAlarms() async {
    var futurePendingAlarms = retrieveNotifications();
    futurePendingAlarms.then((alarms) {
      for (int i = 0; i < alarms.length; i++) {
        print("Disabling alarm...");
        print(alarms[i].title);
        flutterLocalNotificationsPlugin.cancel(alarms[i].id);
      }
    });
  }

  static Future updateAlarm(Prescription prescription) async {
    print("Updating prescription: " + prescription.name);
    var futurePendingAlarms = await retrieveNotifications();

    for (int i = 0; i < futurePendingAlarms.length; i++) {
      if (prescription.alarm.alarmIDs.contains(futurePendingAlarms[i])) {
        flutterLocalNotificationsPlugin.cancel(futurePendingAlarms[i].id);
      }
    }
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

  static Future<List<int>> getSetAlarmIDs() async {
    List<int> ids = new List<int>();

    var notifs = await retrieveNotifications();

    for (int i = 0; i < notifs.length; i++) {
      ids.add(notifs[i].id);
    }

    return ids;
  }

  static Future<List<int>> getNextIDs(int numberOfIDs) async {
    if (numberOfIDs < 1) {
      return null;
    }

    List<int> ids = new List<int>();
    var setAlarmIDs = await getSetAlarmIDs();

    for (int i = 0; i < 250; i++) {
      if (!setAlarmIDs.contains(i)) {
        print("Sending id: $i");
        ids.add(i);
      }
      if (ids.length == numberOfIDs) {
        break;
      }
    }

    return ids;
  }

  static debugPrintAlarmIDsStored() async {
    var notifs = await retrieveNotifications();
    print("DebugPrintAlarmIDsStored");
    for (int i = 0; i < notifs.length; i++) {
      print(notifs[i].id.toString() + " : " + notifs[i].body);
    }
  }
}
