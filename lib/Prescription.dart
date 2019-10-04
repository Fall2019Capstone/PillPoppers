import 'package:pill_poppers/NotificationHandler.dart';

import 'Alarm.dart';

class Prescription {
  static int maxUsedID = 0;

  String name = "New prescription";
  bool taken = false;
  bool alarmEnabled = true;
  int numberToTake = 10;
  int numberTaken = 0;
  DateTime alarmTime = DateTime.now();
  int alarmID;
  bool daily = true;
  Alarm alarm;
  // Sunday - Saturday of alarm being set
  List<bool> daysSelected = [false, false, false, false, false, false, false];

  static List<Prescription> prescriptions = [
    new Prescription("TestMade1"),
    new Prescription("TestMade2")
  ];

  Prescription(String name) {
    this.name = name;
    alarmID = maxUsedID;
    maxUsedID++;
  }

  void confirmNewPrescription() {
    if (!prescriptions.contains(this)) {
      prescriptions.add(this);
    }
    if (daysSelected.contains(true)) {
      NotificationHandler.schedulePrescriptionNotifications(this);
    }
  }

  void setAlarm(bool value) {
    alarmEnabled = value;
    if (value) {
      scheduleAlarm(alarmTime);
    } else {
      NotificationHandler.disableAlarm(this);
    }
  }

  void updateTime(DateTime time) {
    alarmTime = time;
    if (alarmEnabled) {
      NotificationHandler.updateAlarm(this);
    }
  }

  void scheduleAlarm(DateTime time) {
    alarmTime = time;
    NotificationHandler.scheduleNotification(this);
  }

  static instantiate() {
    prescriptions = new List<Prescription>();

    Prescription scrip1 = new Prescription("TestMade1");
    Prescription scrip2 = new Prescription("TestMade2");
    prescriptions.add(scrip1);
    prescriptions.add(scrip2);
  }

  static newPrescription(String name) {
    prescriptions.add(new Prescription(name));
  }

  @override
  String toString() {
    String desc = '''$name
    $daysSelected''';
    return desc;
  }
}
