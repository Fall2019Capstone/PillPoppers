import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AlarmType { Daily, SpecificDays }

class Alarm {
  List<int> alarmIDs = new List<int>();
  String title;
  String body;
  AlarmType alarmType;
  DateTime timeOfDay;
  List<Day> days = List<Day>();

  Alarm(List<int> id, DateTime timeOfDay, String title, String body, AlarmType type, [List<Day> days]) {
    alarmIDs = id;
    this.timeOfDay = timeOfDay;
    this.title = title;
    this.body = body;
    alarmType = type;

    if (days != null) {
      this.days = days;
    }
  }
}
