import 'package:flutter/material.dart';
import 'package:plus_time/data/moor_database.dart';
import 'package:plus_time/datamodels/user_location.dart';
import 'package:plus_time/home.dart';
import 'package:plus_time/login.dart';
import 'package:plus_time/services/load_calendars.dart';
import 'package:plus_time/services/locationService.dart';
import 'package:provider/provider.dart';

class InstalationPanel extends StatefulWidget {
  InstalationPanel({Key key, this.locationService}) : super(key: key);
  final LocationService locationService;
  @override
  _InstalationPanelState createState() => _InstalationPanelState();
}

class _InstalationPanelState extends State<InstalationPanel> {
  ProjectsInfo projectsInfo;
  //LocationService locServ;
  int pageIndex = 0;
  AccessesGivenDao permDao;
  bool _loading = true;
  bool firstTime = true;
  var _pages = [
    GettingStartedPage(),
    CalendarAccessPage(),
    LocationAccessPage(),
    CameraAccessPage(),
    HelpPage(),
  ];

  var _buttonText = [
    "Get Started",
    "Give Calendar Access",
    "Give Location Access",
    "Give Camera Access",
    "Let's Start",
  ];

  Future _nextImage() async {
    if (_buttonText[pageIndex] == "Give Calendar Access") {
      bool calperm = await projectsInfo.requestCalPerm();
      AccessGivenEntry calAccess =
          new AccessGivenEntry(typeOfAccess: "calendar", granted: calperm);
      await permDao.insertAccessesGiven(calAccess);
    } else if (_buttonText[pageIndex] == "Give Location Access") {
      await widget.locationService.requestPerm();
      bool calperm = widget.locationService.isPermGranted;
      AccessGivenEntry calAccess =
          new AccessGivenEntry(typeOfAccess: "location", granted: calperm);
      await permDao.insertAccessesGiven(calAccess);
    } else if (_buttonText[pageIndex] == "Give Storage Access") {
      AccessGivenEntry calAccess =
          new AccessGivenEntry(typeOfAccess: "storage", granted: false);
      await permDao.insertAccessesGiven(calAccess);
    } else if (_buttonText[pageIndex] == "Give Camera Access") {
      AccessGivenEntry calAccess =
          new AccessGivenEntry(typeOfAccess: "camera", granted: false);
      await permDao.insertAccessesGiven(calAccess);
    }

    setState(() {
      if (pageIndex < _pages.length - 1) {
        pageIndex = pageIndex + 1;
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterInstall();
    });
  }

  Future afterInstall() async {
    List<AccessGivenEntry> perms = await permDao.getAllAccessesGivens();
    if (!(perms == null || perms.isEmpty) && firstTime) {
      firstTime = false;
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    projectsInfo = Provider.of<ProjectsInfo>(context);
    projectsInfo.setLocationService(widget.locationService);
    permDao = Provider.of<AppDatabase>(context).accessesGivenDao;
    //locServ = Provider.of<LocationService>(context);
    if (_loading) {
      return Scaffold();
    } else {
      return Scaffold(
        bottomNavigationBar: Stack(
          children: [
            new Container(
              height: 50.0,
              color: Colors.transparent,
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: SelectedPage(
                  numberOfDots: _pages.length, pageIndex: pageIndex),
            ),
          ],
        ),
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
                      FloatingActionButton.extended(
                        icon: Icon(Icons.arrow_forward),
                        label: Text(_buttonText[pageIndex]),
                        onPressed: (() async {
                          await _nextImage();
                        }),
                        elevation: 5.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
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
    return new Center(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Image.asset('assets/calendar(6).jpg'),
              ),
              Expanded(
                child: Image.asset('assets/statistics(3).jpg'),
              ),
            ]),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Welcome to +Time",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Your time management app, integrated with your calendar",
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(padding: const EdgeInsets.all(50.0)),
    ]));
  }
}

class CalendarAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Image.asset('assets/calendar(2).jpg'),
              ),
            ]),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Calendar Access",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "To use this app, we'll need access to your calendar",
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(padding: const EdgeInsets.all(50.0)),
    ]));
  }
}

class LocationAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Image.asset('assets/location(1).jpg'),
              ),
            ]),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Location Access",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "To use this app, we'll need access to your location",
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(padding: const EdgeInsets.all(50.0)),
    ]));
  }
}

class CameraAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset('assets/qrcode.jpg'),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Camera Access",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "To use this app sharing features, we'll need access to your camera",
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(padding: const EdgeInsets.all(50.0)),
    ]));
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Image.asset('assets/hashtag.jpg'),
              ),
            ]),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "How to use",
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Just create an event starting with your project name to see statistics about your project",
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Eg. An event named #Personal Gym with duration of 2 hours, will add 2 hours to the project #Personal",
          style: Theme.of(context).textTheme.subtitle,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(padding: const EdgeInsets.all(50.0)),
    ]));
  }
}
