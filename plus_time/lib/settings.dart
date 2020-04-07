import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:plus_time/load_calendars.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class SettingsState extends State<Settings> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    retriveCalendars();
  }

  List<Calendar> calends = calendars;
  List<String> calendNames = calendarsNames;

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        print("Selected index is $_selectedIndex");
        switch (_selectedIndex) {
          case 0: // Home
            Navigator.pushNamed(context, '/');
            break;
          case 1: // Import/export
            Navigator.pushNamed(context, '/qrModule');
            break;
          case 2: // Settings
            Navigator.pushNamed(context, '/settings');
            break;
          case 3: // Logout
            Navigator.pushNamed(context, '/login');
            break;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Select the calendars:'),
            Expanded(
              child: ListView.builder(
                  itemCount: calendNames.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Text(calendNames[index]);
                  }),
            ),
            Text('Number of hours/week:'),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export),
            title: Text('Import/export'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).disabledColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
