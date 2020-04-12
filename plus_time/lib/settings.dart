import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:plus_time/CalendarEventsPage.dart';
import 'package:provider/provider.dart';
import 'services/load_calendars.dart';

class Settings extends StatelessWidget {
  Settings();

  @override
  Widget build(BuildContext context) {
    ProjectsInfo projectInfo;
    projectInfo = Provider.of<ProjectsInfo>(context);

    return Scaffold(
      body: SettingsPage(projectInfo: projectInfo),
    );
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.projectInfo}) : super(key: key);

  final ProjectsInfo projectInfo;
  
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  List<Calendar> _calendars;

  @override
  void initState() {
    super.initState();
    ProjectsInfo projectInfo = Provider.of<ProjectsInfo>(context);
    _calendars = projectInfo.calendars;
  }
  

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
              flex: 1,
              child: ListView.builder(
                itemCount: _calendars?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    key: Key(_calendars[index].isReadOnly
                        ? 'readOnlyCalendar${_calendars?.where((c) => !c.isReadOnly)?.toList() ?? List<Calendar>().indexWhere((c) => c.id == _calendars[index].id)}'
                        : 'writableCalendar${_calendars?.where((c) => c.isReadOnly)?.toList() ?? List<Calendar>().indexWhere((c) => c.id == _calendars[index].id)}'),
                    onTap: () {
                      print("Changed calendar to");
                      print(index);
                      // TODO
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
}
