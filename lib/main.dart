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

        // For debugging
        persistentFooterButtons: <Widget>[
          FlatButton(
            child: Text("Print Debug"),
            onPressed: (){
              NotificationHandler.DebugPrintAlarmIDsStored();
            },
          ),
          FlatButton(
            child: Text("Remove all notifications"),
            onPressed: ((){
              NotificationHandler.disableAllAlarms();
            }),
          )
        ],
        // End debugging
        
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return NewPrescriptionDialog();
                  }).then((value) {
                if (value) {
                  // Update the cards to show the new prescription
                  setState(() {});
                }
              });
            },
            icon: Icon(Icons.add),
            label: Text("New Prescription")));
  }

  Widget _myListView() {
    return ListView.builder(
      itemCount: Prescription.prescriptions.length,
      itemBuilder: (context, index) {
        final item = Prescription.prescriptions[index];
        return Card(
          child: InkWell(
            onTap: () {},
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
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewPrescriptionDialog extends StatefulWidget {
  @override
  _NewPrescriptionDialogState createState() =>
      new _NewPrescriptionDialogState();
}

class _NewPrescriptionDialogState extends State<NewPrescriptionDialog> {
  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  List<String> daysAbbrev = ["S", "M", "T", "W", "TH", "F", "S"];

  Prescription newPrescription = new Prescription("New prescription");

  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        "Create Prescription",
        textAlign: TextAlign.center,),
      contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      children: <Widget>[
        // Name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
                child: TextField(
              expands: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Prescription name",
                  ),
                  textAlign: TextAlign.center,
              onChanged: (name) {
                newPrescription.name = name;
              },
              onSubmitted: (name) {
                newPrescription.name = name;
              },
            ))
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ),
        // Notification handler (Daily or on X,Y,Z days)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ToggleButtons(
              
              children: <Widget>[Text("Daily"), Text("Certain Days")],
              onPressed: (int index) {
                setState(() {
                  switch (index) {
                    case 0:
                      newPrescription.daily = true;
                      isSelected[0] = true;
                      isSelected[1] = false;
                      break;
                    case 1:
                      newPrescription.daily = false;
                      isSelected[0] = false;
                      isSelected[1] = true;
                      break;
                    // Doesn't occur
                    default:
                      break;
                  }
                });
              },
              isSelected: isSelected,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ),
        // Day pickerr if not set to Daily
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: newPrescription.daily,
              child: new Text(""),
              replacement: new Container(
                  width: MediaQuery.of(context).size.width * .7,
                  height: MediaQuery.of(context).size.height * .05,
                  child: new GridView.builder(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7),
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        return new RaisedButton(
                          child: Text(daysAbbrev[index]),
                          color: newPrescription.daysSelected[index]
                              ? Colors.blue
                              : Colors.white,
                          onPressed: () {
                            setState(() {
                              newPrescription.daysSelected[index] =
                                  !newPrescription.daysSelected[index];
                            });
                          },
                        );
                      })),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          OutlineButton(
              onPressed: () {
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    currentTime: newPrescription.alarmTime,
                    onConfirm: (dateTime) {
                  newPrescription.alarmTime = dateTime;
                });
              },
              child: Text('Select time for alarm.')),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ButtonBar(children: <Widget>[
              RaisedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              RaisedButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    print("Confirmed: \n" + newPrescription.toString());
                    newPrescription.confirmNewPrescription();
                    Navigator.pop(context, true);
                  })
            ])
          ],
        ),
      ],
    );
  }
}
