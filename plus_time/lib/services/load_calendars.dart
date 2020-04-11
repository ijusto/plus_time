import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class ProjectsInfo {
  DeviceCalendarPlugin _deviceCalendarPlugin;
  
  List<Calendar> calendars;
  List<Event> _calendarEvents;
  bool _isLoading;

  int _selectedCalendarIndex;
  Calendar _selectedCalendar;

  Map<String, int> projects;
  List<Card> projectCards;

  ProjectsInfo() {
    _isLoading = true;
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
    _selectedCalendarIndex = 0;
  }

  /* Calendar Logic */
  Future retriveCalendars() async {
    List<String> calendarsNames;

    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();

        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      calendars = calendarsResult?.data;

      for (int c = 0; c < calendars.length; c++) {
        calendarsNames.add(calendars[c].name);
      }
      print(calendarsNames);
    } catch (e) {
      print(e);
    }

    _selectedCalendar = calendars[_selectedCalendarIndex];
  }

  Future _retrieveCalendarEvents() async {
    final startDate = DateTime.now().add(Duration(days: -30));
    final endDate = DateTime.now().add(Duration(days: 30));
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        _selectedCalendar.id,
        RetrieveEventsParams(startDate: startDate, endDate: endDate));
    _isLoading = false;
    return calendarEventsResult?.data;
  }

  void setSelectedCalendar(int index) {
    _selectedCalendarIndex = index;
    _selectedCalendar = calendars[_selectedCalendarIndex];
  }

  Future<void> updateCalendarInfo() async {
    await retriveCalendars();
    await _retrieveCalendarEvents();
    this._isLoading = false;
  }
  
  /* Projects Logic */
  Future<void> _parseEventsIntoProjects() async {
    if (!_isLoading) {
      for (int i = 0; i < _calendarEvents.length; i++) {
        Event calendarEvent = _calendarEvents[i];
        
        /* Obtain project name */
        String calendarEventName = calendarEvent.title;
        List<String> splittedName = calendarEventName.split("\s");
        if (!splittedName[0].startsWith("#")) {
            break;    // ignores event
        }
        
        String projectName = splittedName[0];
        
        /* Compute duration */
        Duration duration = calendarEvent.end.difference(calendarEvent.start);
        int durationHours = duration.inHours;

        /* Update project info */
        if (projects.containsKey(projectName)) {
          int currentValue = projects.remove(projectName);
          projects[projectName] = currentValue + durationHours; 
        }
        else {
          projects[projectName] = durationHours; 
        }
      }
    }
  }

  Future<void> obtainProjectCards() async {
    _parseEventsIntoProjects();

    /* compute average value */
    double average = 0;
    projects.forEach((k,v) => average += v); 
    average /= projects.keys.length;

    /* create list of cards */
    
    for (var project in projects.keys) {
      
      if (projects[project] < 0.2 * average) {          // YELLOW
        projectCards.add(new Card( child: ListTile(
                                    leading: Icon(
                                      Icons.error,
                                      size: 56.0,
                                      color: Colors.red,
                                    ),
                                    title: Text(project),
                                    subtitle: Text(projects[project].toString()),
                                    trailing: Icon(Icons.play_arrow),
                                  ),
      ));
      }
      else if (projects[project] < 0.5 * average) {          // YELLOW
        projectCards.add(new Card( child: ListTile(
                                    leading: Icon(
                                      Icons.warning,
                                      size: 56.0,
                                      color: Colors.amber,
                                    ),
                                    title: Text(project),
                                    subtitle: Text(projects[project].toString()),
                                    trailing: Icon(Icons.play_arrow),
                                  ),
      ));
      }
      else {                                                  // GREEN
        projectCards.add(new Card( child: ListTile(
                                    leading: Icon(
                                      Icons.check_box,
                                      size: 56.0,
                                      color: Colors.green,
                                    ),
                                    title: Text(project),
                                    subtitle: Text(projects[project].toString()),
                                    trailing: Icon(Icons.play_arrow),
                                  ),
      ));
      }
      }
      
    }
  
}

