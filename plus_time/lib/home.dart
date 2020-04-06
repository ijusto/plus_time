import 'package:flutter/material.dart';
import 'package:plus_time/load_calendars.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void initState(){
    super.initState();
    retriveCalendars();
  }

  int _counter = 0;
  int _selectedIndex = 0;
  var projectsStats = [const _ProjectCard(
          color: Colors.amber,
          projectName: 'Mobile Computation',
          projectType: '54h',
    ),];

  void _addEvent() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    print(calendars);
    print(calendarsNames);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: new AppBar(
          title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'What should I do next?',
            ),
            Row(children: projectsStats),
            Text(
              'Based on your location you should be here'
            ),
            Text('My projects'),
          ],
        ),
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
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.black,
      onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Add Event',
        child: Icon(Icons.event),
      ),
    );
  }
}


class _ProjectCard extends StatefulWidget {
  _ProjectCard({Key key, this.color, this.name, this.time}) : super(key: key);

  final Color  color;
  final String name;
  final String time;

  @override
  _ProjectCardState createState() => _ProjectCardState();

}
class _ProjectCardState extends  State<_ProjectCard> {
  @override
  Widget build(BuildContext context) {
    	
  return Container(
    decoration: BoxDecoration(
      color: widget.color,
    ),
    child: [

    ]
          title: Text(widget.name),
          subtitle: Text(widget.time),
        ),
      ],
    ),
  );
  }
  
}
