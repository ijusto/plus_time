import 'package:flutter/material.dart';

import 'biom_auth.dart';
import 'details.dart';
import 'home.dart';
import 'qrcode.dart';
import 'settings.dart';

void main() {
  runApp(MaterialApp(
    title: '+Time',
    theme: ThemeData(
      primarySwatch: Colors.lime,
      primaryColor: const Color(0xFFcddc39),
      accentColor: const Color(0xFFcddc39),
      canvasColor: const Color(0xFFfafafa),
      fontFamily: 'Merriweather',
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(
            fontSize: 27.0,
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w200),
        subtitle: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w200),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/details': (context) => Details(),
      '/login': (context) => BiomAuth(),
      '/qrModule': (context) => QRCode(),
      '/settings': (context) => Settings(),
    },
  ));
}
