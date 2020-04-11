import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class ProjectsInfo {
  DeviceCalendarPlugin _deviceCalendarPlugin;

  List<Calendar> calendars = List<Calendar>();
  List<Event> _calendarEvents = List<Event>();
  bool isLoading;

  int _selectedCalendarIndex;
  Calendar _selectedCalendar;

  Map<String, double> projects = Map<String, double>();
  List<Card> projectCards = List<Card>();

  List<Card> get getProjectCards => projectCards;

  ProjectsInfo() {
    isLoading = true;
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
    _selectedCalendarIndex = 0;
  }

  /* Calendar Logic */
  Future<Calendar> retriveCalendars() async {
    List<String> calendarsNames = List<String>();

    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();

        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return null;
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
    await retrieveCalendarEvents();
    return _selectedCalendar;
    /*
    for (int calendarIndex = 0;
        calendarIndex == calendars.length;
        calendarIndex++) {
      retrieveCalendarEvents(calendars[calendarIndex]).then((eventsList) {
        for (int eventIndex = 0;
            eventIndex == eventsList.length;
            eventIndex++) {
          _calendarEvents.add(eventsList[eventIndex]);
        }
      });
    }
    */
  }

  Future retrieveCalendarEvents(
      /*Calendar selectedCalendar*/) async {
    final startDate = DateTime.now().add(Duration(days: -30));
    final endDate = DateTime.now().add(Duration(days: 30));
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        _selectedCalendar.id,
        RetrieveEventsParams(startDate: startDate, endDate: endDate));
    isLoading = false;
    print("events : " + calendarEventsResult?.data.toString());
    for (Event ev in calendarEventsResult?.data) {
      _calendarEvents.add(ev);
      print("event title: " + ev.title);
    }
  }

  void setSelectedCalendar(int index) {
    _selectedCalendarIndex = index;
    _selectedCalendar = calendars[_selectedCalendarIndex];
  }

  /* Projects Logic */
  Future _parseEventsIntoProjects() async {
    if (!isLoading) {
      projects.clear();
      for (int i = 0; i < _calendarEvents.length; i++) {
        Event calendarEvent = _calendarEvents[i];

        /* Obtain project name */
        String calendarEventName = calendarEvent.title;
        List<String> splittedName = calendarEventName.split(" ");
        
        if (splittedName[0].startsWith("#")) {
            String projectName = splittedName[0];

            /* Compute duration */
            Duration duration = calendarEvent.end.difference(calendarEvent.start);
            int durationHours = duration.inHours;

            /* Update project info */
            if (projects.containsKey(projectName)) {
              int currentValue = projects.remove(projectName);
              projects[projectName] = currentValue + durationHours;
            } else {
              projects[projectName] = durationHours;
            }
        }
      }
      print(projects);
    }
  }

  Future<List<Card>> obtainProjectCards() async {
    print("Going to parse");
    await _parseEventsIntoProjects();
    print("Parsed");

    /* compute average value */
    double average = 0;
    projects.forEach((k, v) => average += v);
    average /= projects.keys.length;

    /* create list of cards */
    projectCards.clear();
    
    for (var project in projects.keys) {
      if (projects[project] < 0.2 * average) {
        // YELLOW
        projectCards.add(new Card(
          child: ListTile(
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
      } else if (projects[project] < 0.5 * average) {
        // YELLOW
        projectCards.add(new Card(
          child: ListTile(
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
      } else {
        // GREEN
        projectCards.add(new Card(
          child: ListTile(
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
    print(projectCards);
    projectCards.forEach((card) => print(card.child));
    return projectCards;
  }
}
