import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

import '../generate.dart';
import '../map.dart';
import 'package:geocoder/geocoder.dart';

class ProjectsInfo {
  DeviceCalendarPlugin _deviceCalendarPlugin;

  List<Calendar> calendars = List<Calendar>();
  List<Event> _calendarEvents = List<Event>();
  bool isLoading;

  int _selectedCalendarIndex;
  Calendar _selectedCalendar;

  Map<String, double> projects = Map<String, double>();
  List<Card> projectCards = List<Card>();
  Map<int, List<Location>> projectLocations = Map<int, List<Location>>();

  List<Card> get getProjectCards => projectCards;

  ProjectsInfo() {
    isLoading = true;
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
    _selectedCalendarIndex = 1;
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
          double durationHours = duration.inHours.toDouble();
          ;

          /* Update project info */
          if (projects.containsKey(projectName)) {
            double currentValue = projects.remove(projectName);
            projects[projectName] = currentValue + durationHours;
          } else {
            projects[projectName] = durationHours;
          }
        }
      }
      print(projects);
    }
  }

  Future<List<Card>> obtainProjectCards(BuildContext context) async {
    print("Going to parse");
    await _parseEventsIntoProjects();
    print("Parsed");

    /* compute average value */
    double average = 0;
    projects.forEach((k, v) => average += v);
    average /= projects.keys.length;

    /* create list of cards */

    int projectIndex = -1;
    projectCards.clear();

    for (var project in projects.keys) {
      projectIndex++;
      List<Location> locations = List<Location>();
      Location recentLoc;

      for (Event ev in _calendarEvents) {
        if (ev.title.split(" ")[0].startsWith("#")) {
          if (ev.title.split(" ")[0] == project) {
            if (ev.location != null) {
              try {
                var addresses =
                    await Geocoder.local.findAddressesFromQuery(ev.location);
                var first = addresses.first;
                Location loc = Location(
                    latitude: addresses.first.coordinates.latitude,
                    longitude: addresses.first.coordinates.longitude);

                if (ev.start.compareTo(DateTime.now()) > 0) {
                  recentLoc = loc;
                }

                locations.add(loc);
              } catch (e) {
                print(e); // TODO: handle this later
              }
            }
          }
        }
      }
      projectLocations[projectIndex] = locations;
      Icon ic;
      if (projects[project] < 0.2 * average) {
        ic = Icon(Icons.error, size: 56.0, color: Colors.red);
      } else if (projects[project] < 0.5 * average) {
        ic = Icon(
          Icons.warning,
          size: 56.0,
          color: Colors.amber,
        );
      } else {
        ic = Icon(
          Icons.check_box,
          size: 56.0,
          color: Colors.green,
        );
      }
      projectCards.add(new Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ExpansionTile(
          leading: ic,
          title: Text(project),
          subtitle: Text(projects[project].toString()),
          trailing: Wrap(spacing: 30, children: <Widget>[
            if (locations != null && locations.isNotEmpty) ...[
              Icon(Icons.location_on),
            ],
            GestureDetector(
              onTap: () {
                createAlertDialog(context);
              },
              child: Icon(Icons.share),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Icon(Icons.play_arrow),
            )
          ]),
          children: <Widget>[
            if (locations != null && locations.isNotEmpty) ...[
              Container(
                  height: 300,
                  child: MapPage(locations: locations, recentLoc: recentLoc)),
            ]
          ],
        )
      ])));
    }
    print(projectCards);
    projectCards.forEach((card) => print(card.child));
    return projectCards;
  }

  Future createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Do you want to share this event?"),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GenerateScreen(eventData: "eventData")),
                      );
                    },
                    child: Text("Yes")),
                MaterialButton(
                    elevation: 5.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"))
              ]);
        });
  }
}
