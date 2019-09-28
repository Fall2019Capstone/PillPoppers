import 'package:flutter/material.dart';

//TODO: Design and implement card style (where items are & layout)
//TODO: Find method for storing and loading data (hopefully JSON)
//TODO: Find new method for adding new prescriptions

void main() => runApp(MyApp());

// Current storage of data
// Should attempt to use json for this functionality later to allow saving
List<String> prescriptions = ['Test Pill 1', 'Test Pill 2', 'Pill 3'];
List<bool> hasTaken = [true, false, false];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pill Poppers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Pill Poppers'), centerTitle: true,),
        body: BodyLayout(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Add new list item when FAB pressed
            print("FAB Pressed");
          },
          icon: Icon(Icons.add),
          label: Text("New"),
        ),
      ),
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
      prescriptions.insert(prescriptions.length, 'New prescription');
      hasTaken.insert(hasTaken.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _myListView();
  }

  Widget _myListView() {
    return ListView.builder(
      itemCount: prescriptions.length,
      itemBuilder: (context, index) {
        final item = prescriptions[index];
        return Card(
          child: InkWell(
            onTap: () {
              // When outside of card touched
              _addPrescription();
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(item, style: TextStyle(fontSize: 16),),
                  Checkbox(
                    value: hasTaken[index],
                    onChanged: (bool newValue) {
                      setState(() {
                        // Change the hasTaken bool to true or false
                        hasTaken[index] = newValue;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}