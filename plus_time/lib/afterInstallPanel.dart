import 'package:flutter/material.dart';
import 'package:plus_time/data/moor_database.dart';
import 'package:plus_time/home.dart';
import 'package:plus_time/login.dart';
import 'package:plus_time/services/load_calendars.dart';
import 'package:provider/provider.dart';

class InstalationPanel extends StatefulWidget {
  InstalationPanel({Key key}) : super(key: key);

  @override
  _InstalationPanelState createState() => _InstalationPanelState();
}

class _InstalationPanelState extends State<InstalationPanel> {
  ProjectsInfo projectsInfo;
  int pageIndex = 0;
  AccessesGivenDao permDao;
  bool firstTime = true;
  var _pages = [
    GettingStartedPage(),
    CalendarAccessPage(),
    LocationAccessPage(),
    StorageAccessPage(),
    CameraAccessPage(),
  ];

  var _buttonText = [
    "Get Started",
    "Give Calendar Access",
    "Give Location Access",
    "Give Storage Access",
    "Give Camera Access",
  ];

  void _nextImage() {
    setState(() {
      pageIndex = pageIndex < _pages.length - 1 ? pageIndex + 1 : pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    projectsInfo = Provider.of<ProjectsInfo>(context);
    if (!firstTime) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home(projectsInfo)));
    } else {
      permDao = Provider.of<AppDatabase>(context).accessesGivenDao;
      return Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                _pages[pageIndex],
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        child: Text(_buttonText[pageIndex]),
                        onPressed: _nextImage,
                        elevation: 5.0,
                        color: Colors.green),
                  ],
                ),
                Padding(padding: const EdgeInsets.all(50.0)),
                SelectedPage(numberOfDots: _pages.length, pageIndex: pageIndex),
              ],
            ),
          ),
        ],
      ));
    }
  }
}

/* Based on tutorial https://www.youtube.com/watch?v=sC9qhNPvW1M */

class SelectedPage extends StatelessWidget {
  final int numberOfDots;
  final int pageIndex;

  SelectedPage({this.numberOfDots, this.pageIndex});

  Widget _inactivePage() {
    return new Container(
      child: new Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
            height: 8.0,
            width: 8.0,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(4.0))),
      ),
    );
  }

  Widget _activePage() {
    return new Container(
      child: new Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 0.0,
                    blurRadius: 2.0,
                  )
                ])),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int dotIndex = 0; dotIndex < numberOfDots; dotIndex++) {
      dots.add(dotIndex == pageIndex ? _activePage() : _inactivePage());
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildDots(),
    ));
  }
}

class GettingStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(child: Text("GettingStartedPage"));
  }
}

class CalendarAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Column(children: <Widget>[
      Padding(padding: const EdgeInsets.all(50.0)),
      Text("CalendarAccessPage"),
      Padding(padding: const EdgeInsets.all(50.0)),
    ]));
  }
}

class LocationAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(child: Text("LocationAccessPage"));
  }
}

class StorageAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(child: Text("StorageAccessPage"));
  }
}

class CameraAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(child: Text("CameraAccessPage"));
  }
}
