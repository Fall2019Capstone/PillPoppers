import 'package:pill_poppers/NotificationHandler.dart';

import 'Alarm.dart';

class Prescription {
  static int maxUsedID = 0;

  String name = "New prescription";
  bool taken = false;
  bool alarmEnabled = true;
  int numberToTake = 10;
  int numberTaken = 0;
  int prescriptionID;
  bool daily = true;
  Alarm alarm;

  // On startup, we would want to populate this from the DB
  static List<Prescription> prescriptions = [];

  Prescription.empty(){
    prescriptionID = maxUsedID;
    maxUsedID++;
    alarm = new Alarm.empty();
    alarm.prescriptionID = prescriptionID;
  }

  void confirmNewPrescription() {
    if (!prescriptions.contains(this)) {
      prescriptions.add(this);
    }
    if (alarm.days.contains(true) || daily) {
      scheduleAlarm();
    }
  }

  void setAlarm(bool value) {
    alarmEnabled = value;
    alarm.enabled = value;
    if (value) {
      scheduleAlarm();
    } else {
      NotificationHandler.disableAlarm(this);
    }
  }

  void updateTime(DateTime time) {
    alarm.timeToAlert = time;
    if (alarmEnabled) {
      NotificationHandler.updateAlarm(this);
    }
  }

  void scheduleAlarm() {
    NotificationHandler.schedulePrescriptionNotifications(this);
  }

  void setName(String name){
    this.name = name;
    alarm.setName(name);
  }

  @override
  String toString() {
    String desc = '''$name
    $alarm''';
    return desc;
  }
}
