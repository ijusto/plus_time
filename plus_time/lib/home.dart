import 'package:flutter/material.dart';
import 'package:plus_time/generate.dart';
import 'package:plus_time/map.dart';
import 'package:provider/provider.dart';
import 'package:plus_time/datamodels/user_location.dart';
import 'package:device_calendar/device_calendar.dart';
import 'dart:async';
import 'device_calendar_ex/event_item.dart';
import 'services/load_calendars.dart';

class Home extends StatelessWidget {
  Home();

  @override
  Widget build(BuildContext context) {
    ProjectsInfo projectInfo;
    List<Card> projectCards;
    projectInfo = Provider.of<ProjectsInfo>(context);
    print("HELLO?");
    projectInfo.retriveCalendars().then((selected_calendar) {
      print("Selected calendar: " + selected_calendar.name);
      projectInfo.obtainProjectCards().then((pcards) {
        print("PCARDS: $pcards");
        projectCards = pcards;
      });
    });
    //while (projectInfo.isLoading) print("."); // BUSY WAITING; WONT WORK
    print("--- $projectInfo");
    print("BYE $projectCards");
    print("");
    return Scaffold(
      body: HomePage(
          projectsInfo: projectInfo, projectCards: projectInfo.projectCards),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.projectsInfo, this.projectCards}) : super(key: key);

  final ProjectsInfo projectsInfo;
  final List<Card> projectCards;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<String> litems = [
    "What should I do next?",
  ];
  List<String> litems2 = [
    "Statistics",
  ];

  /* Events Handlers */
  void _addEvent() {}

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

  /* Create the layout */
  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('+Time'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          /*
          if (userLocation != null &&
              userLocation.latitude != null &&
              userLocation.longitude != null) ...[
            SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  "Location: Lat: ${userLocation.latitude}, Long: ${userLocation.longitude}",
                  style: Theme.of(context).textTheme.title,
                ),
              ]),
            ),
          ],*/
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  child: new Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        litems[index],
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                );
              },
              childCount: litems.length,
            ),
          ),
          if (widget.projectCards != null) ...[
            SliverList(
              delegate: SliverChildListDelegate(widget.projectCards),
            )
          ],
          /*
          SliverList(
              delegate: SliverChildListDelegate([
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ExpansionTile(
                    leading: Icon(
                      Icons.error,
                      size: 56.0,
                      color: Colors.red,
                    ),
                    title: Text('ComputaçãoMóvel'),
                    subtitle: Text('15h'),
                    trailing: Wrap(
                      spacing: 30,
                      children: <Widget>[
                        Icon(Icons.location_on),
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
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Container(height: 300, child: MapPage()),
                    ],
                  ),
                  (_calendarEvents?.isNotEmpty ?? false)
                      ? Stack(
                          children: [
                            ListView.builder(
                              itemCount: _calendarEvents?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return EventItem(
                                    _calendarEvents[index],
                                    _deviceCalendarPlugin,
                                    _onLoading,
                                    _onDeletedFinished,
                                    _onTapped,
                                    _calendar.isReadOnly);
                              },
                            ),
                            if (_isLoading)
                              Center(
                                child: CircularProgressIndicator(),
                              )
                          ],
                        )
                      : Center(child: Text('No events found')),
                ],
              ),
            ),
          ])),
          */
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  child: new Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        litems2[index],
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                );
              },
              childCount: litems2.length,
            ),
          ),
        ],
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Add Event',
        child: Icon(Icons.event),
      ),
    );
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
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"))
              ]);
        });
  }
}
