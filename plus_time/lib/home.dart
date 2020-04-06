import 'package:flutter/material.dart';
import 'utils.dart';

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
  final List<Card> projectsOverview = [
        Card(
          child: ListTile(
            leading: Icon(Icons.error, size: 56.0, color: Colors.red,),
            title: Text('ComputaçãoMóvel'),
            subtitle: Text('15h'),
            trailing: Icon(Icons.play_arrow),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.warning, size: 56.0, color: Colors.amber,),
            title: Text('SistemasDistribuidos'),
            subtitle: Text('35h'),
            trailing: Icon(Icons.play_arrow),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.check_box, size: 56.0, color: Colors.green,),
            title: Text('ComputaçãoMóvel'),
            subtitle: Text('55h'),
            trailing: Icon(Icons.play_arrow),
          ),
        ),
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   int _selectedIndex = 0;
   
   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("Selected index is $_selectedIndex");
      switch (_selectedIndex) {
        case 0:   // Home
          Navigator.pushNamed(context, '/');
          break;
        case 1:   // Import/export
          Navigator.pushNamed(context, '/qrModule');
          break;
        case 2:   // Settings
          Navigator.pushNamed(context, '/settings');
          break;
        case 3:   // Logout
          Navigator.pushNamed(context, '/login');
          break;
      }
    });
  } 

  // Event Handlers

  // Project card/Floating button
  void _addEvent() {
    setState(() {
      // TODO 
      // Add an event
    });
  }

  // Project details
  void _seeProjectDetails() {
    setState(() {
      // TODO 
      // Go to details page with info about the chosen project (index)
    });
  }
  
  // Create the layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(widget.title),
      ),
      
      body: Center(
        child: 
           Column(

            children: <Widget>[
               Padding(
                padding: const EdgeInsets.all(24.0),
              ),
    
               Text(
              "What should I do next?",
                style: Theme.of(context).textTheme.title,
              ),

               Padding(
                padding: const EdgeInsets.all(10.0),
              ),
    
               Expanded (
                 child: ListView(
                   children: widget.projectsOverview,),
               ),

               Padding(
                padding: const EdgeInsets.all(24.0),
              ),

               Text(
              "Don't forget to go to ... at",
                 style: Theme.of(context).textTheme.title,
              ),
    
               Text(
              "You are X km away",
                 style: Theme.of(context).textTheme.title,
              ),
    
               Padding(
                padding: const EdgeInsets.all(24.0),
              ),
    
               Text(
              "My projects",
                style: Theme.of(context).textTheme.title,
              ),
    
              
            ]
    
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
}

