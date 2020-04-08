import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:plus_time/load_calendars.dart';
import 'package:plus_time/device_calendar_ex/CalendarEventsPage.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class _SettingsState extends State<Settings> {
  DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars;

  _SettingsState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

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

    void _getCalendars() {
      print("RETRIEVING CALENDARS");
      _retrieveCalendars();
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
            FloatingActionButton.extended(
              icon: Icon(Icons.calendar_view_day),
              label: Text("Get Calendars"),
              onPressed: _getCalendars,
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _calendars?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    key: Key(_calendars[index].isReadOnly
                        ? 'readOnlyCalendar${_calendars?.where((c) => !c.isReadOnly)?.toList() ?? List<Calendar>().indexWhere((c) => c.id == calendars[index].id)}'
                        : 'writableCalendar${_calendars?.where((c) => c.isReadOnly)?.toList() ?? List<Calendar>().indexWhere((c) => c.id == calendars[index].id)}'),
                    onTap: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CalendarEventsPage(_calendars[index],
                            key: Key('calendarEventsPage'));
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              _calendars[index].name,
                              style: Theme.of(context).textTheme.subhead,
                            ),
                          ),
                          Icon(_calendars[index].isReadOnly
                              ? Icons.lock
                              : Icons.lock_open)
                        ],
                      ),
                    ),
                  );
                },
              ),
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

  void _retrieveCalendars() async {
    try {
      print("PHASE 1");
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      print("PHASE 2");
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        print("PHASE 3");
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          print("PHASE 4");
          //return;
        }
      }
      print("PHASE 5");
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      print("PHASE 6");
      setState(() {
        _calendars = calendarsResult?.data;
        print("$_calendars");
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
