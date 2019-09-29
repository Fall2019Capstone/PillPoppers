import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pill_poppers/NotificationHandler.dart';

import 'Prescription.dart';

//TODO: Design and implement card style (where items are & layout)
//TODO: Find method for storing and loading data (hopefully JSON)
//TODO: Find new method for adding new prescriptions

void main() => runApp(MyApp());

// Current storage of data
// Should attempt to use json for this functionality later to allow saving
// List<String> prescriptions = ['Test Pill 1', 'Test Pill 2', 'Pill 3'];
// List<bool> hasTaken = [true, false, false];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationHandler.setupNotifications(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pill Poppers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Pill Poppers'),
            centerTitle: true,
          ),
          body: BodyLayout()),
    );
  }
}

class BodyLayout extends StatefulWidget {
  @override
  BodyLayoutState createState() {
    return new BodyLayoutState();
  }
}

class BodyLayoutState extends State<BodyLayout> {
  // Called when outside of any card is touched, adds new blank prescription for now.
  void _addPrescription() {
    setState(() {
      Prescription.newPrescription("New Prescription");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _myListView(),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // TODO: Add new list item when FAB pressed
              print("FAB Pressed");
              _addPrescription();
            },
            icon: Icon(Icons.add),
            label: Text("New Presciption")));
    //return _myListView();
  }

  Widget _myListView() {
    return ListView.builder(
      itemCount: Prescription.prescriptions.length,
      itemBuilder: (context, index) {
        final item = Prescription.prescriptions[index];
        return Card(
          child: InkWell(
            onTap: () {
              // When outside of card touched
              // Moved to FAB
              //_addPrescription();
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Taken",
                        style: TextStyle(fontSize: 16),
                      ),
                      Checkbox(
                        value: item.taken,
                        onChanged: (bool newValue) {
                          setState(() {
                            item.taken = newValue;
                          });
                        },
                      ),
                      Spacer(),
                      Text("Enable Alarm?", style: TextStyle(fontSize: 16)),
                      Checkbox(
                        value: item.alarmEnabled,
                        onChanged: (bool newValue) {
                          setState(() {
                            item.setAlarm(newValue);
                            
                          });
                        },
                      )
                    ],
                  ),
                  FlatButton(
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            currentTime: item.alarmTime, onConfirm: (dateTime) {
                          item.updateTime(dateTime);
                        }, locale: LocaleType.en);
                      },
                      child: Text(
                        'Show time picker',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
