import 'package:flutter/material.dart';
import 'package:plus_time/afterInstallPanel.dart';
import 'package:plus_time/data/moor_database.dart';
import 'package:provider/provider.dart';
import 'services/load_calendars.dart';
import 'services/locationService.dart';
import 'add_event.dart';
import 'qrcode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  LocationService locationService = LocationService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => AppDatabase()),
          Provider(create: (_) => ProjectsInfo()),
          StreamProvider(create: (_) => locationService.locationStream),
        ],
        child: MaterialApp(
          title: '+Time',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.lime,
            primaryColor: const Color(0xFFcddc39),
            accentColor: const Color(0xFFcddc39),
            canvasColor: const Color(0xFFfafafa),
            fontFamily: 'Merriweather',
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 37.0, fontWeight: FontWeight.bold),
              title: TextStyle(
                  fontSize: 27.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w200),
              subtitle: TextStyle(
                  fontSize: 16.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w200),
              body1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) =>
                InstalationPanel(locationService: locationService),
            '/add_event': (context) => AddEvent(),
            '/qrModule': (context) => QRCode(),
          },
        ));
  }
}
