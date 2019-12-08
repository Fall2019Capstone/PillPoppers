/**
 *Class creates wireframe for a perscription
 */

import 'package:pill_poppers/NotificationHandler.dart';
import 'JSONConversion.dart';
import 'Alarm.dart';

class Prescription {

  //TODO: Pull from JSON doc to populate perscriptions list... 
  //TODO: Modify class to accept JSON data
  // On startup, we would want to populate this from the DB
  static List<Prescription> prescriptions = [];

  static int maxUsedID = 0;

  String name = "New prescription";
  bool taken = false;
  bool alarmEnabled = true;
  int numberToTake = 0;
  int numberTaken = 0;
  int prescriptionID;
  bool daily = true;
  Alarm alarm;



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