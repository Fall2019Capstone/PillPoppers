import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AlarmType { Daily, SpecificDays }

class Alarm {
  int prescriptionID = -1;
  List<int> alarmIDs = new List<int>();
  // We can readd title/body if we want to allow custom reminders instead of the default
  String title;
  String body;
  AlarmType alarmType;
  DateTime timeToAlert;
  List<bool> days = [false, false, false, false, false, false, false];
  bool enabled = false;

  Alarm(List<int> id, DateTime timeOfDay, AlarmType type, [List<Day> days]) {
    alarmIDs = id;
    this.timeToAlert = timeOfDay;
    alarmType = type;
  }

  Alarm.empty();

  setName(String name){
    title = "Prescription Time!";
    body = "It is time to take $name.";
  }

}
