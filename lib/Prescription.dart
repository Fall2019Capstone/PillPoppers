import 'package:pill_poppers/NotificationHandler.dart';

class Prescription {
  // I just don't have a better way to curerntly keep track of the highest used ID
  // Second thought, just add it to the list and take the length, but still, I'm too lazy right now
  static int maxUsedID = 0;

  String name = "New prescription";
  bool taken = false;
  bool alarmEnabled = false;
  int numberToTake = 10;
  int numberTaken = 0;
  DateTime alarmTime;
  int alarmID;

  static List<Prescription> prescriptions = [
    new Prescription("TestMade1"),
    new Prescription("TestMade2")
  ];

  Prescription(String name) {
    this.name = name;
    alarmID = maxUsedID;
    maxUsedID++;
    //prescriptions.add(this);
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
}
