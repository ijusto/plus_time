import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:plus_time/generate.dart';
import 'package:plus_time/map.dart';
import 'package:provider/provider.dart';
import 'package:plus_time/datamodels/user_location.dart';
import 'package:device_calendar/device_calendar.dart';
import 'dart:async';
import 'device_calendar_ex/event_item.dart';
import 'services/load_calendars.dart';

class Home extends StatelessWidget {
  final ProjectsInfo projectInfo;

  Home(this.projectInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(projectsInfo: projectInfo),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.projectsInfo}) : super(key: key);

  final ProjectsInfo projectsInfo;

  @override
  _HomePageState createState() => _HomePageState(projectsInfo);
}

class _HomePageState extends State<HomePage> {
  final ProjectsInfo projectsInfo;
  List<Card> projectCards;
  int _selectedIndex = 0;

  List<String> litems = [
    "What should I do next?",
  ];
  List<String> litems2 = [
    "Statistics",
  ];

  _HomePageState(this.projectsInfo);

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

  bool _isLoading = true;
  void _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _onLoading();
  }

  /* Create the layout */
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      getProjects();
    }
    print("HELLO?");

    var userLocation = Provider.of<UserLocation>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('+Time'),
      ),
      body: Stack(
        children: [
          CustomScrollView(
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
              if (!_isLoading && projectCards != null) ...[
                SliverList(
                  delegate: SliverChildListDelegate(projectCards),
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
              if (!_isLoading &&
                  projectCards != null &&
                  projectCards.length != 0)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        child: new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: PieChart(
                              dataMap: widget.projectsInfo.projects,
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 32.0,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 2.7,
                              showChartValuesInPercentage: true,
                              showChartValues: true,
                              showChartValuesOutside: false,
                              chartValueBackgroundColor: Colors.grey[200],
                              showLegends: true,
                              legendPosition: LegendPosition.right,
                              decimalPlaces: 1,
                              showChartValueLabel: true,
                              initialAngle: 0,
                              chartValueStyle: defaultChartValueStyle.copyWith(
                                color: Colors.blueGrey[900].withOpacity(0.9),
                              ),
                              chartType: ChartType.ring,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: litems2.length,
                  ),
                ),
              if (!_isLoading &&
                  (projectCards == null || projectCards.length == 0))
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        child: new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Text(
                              "Statistics not available",
                              style: Theme.of(context).textTheme.subtitle,
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
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
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

  Future getProjects() async {
    Calendar selectedCalendar = await projectsInfo.retriveCalendars();
    print("Selected calendar: " + selectedCalendar.name);
    projectCards = await projectsInfo.obtainProjectCards(context);
    setState(() {
      _isLoading = false;
    });
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
