import 'package:flutter/material.dart';

import 'details.dart';
import 'home.dart';
import 'login.dart';
import 'qrmodule.dart';
import 'settings.dart';

void main() {
  runApp(MaterialApp(
    title: '+Time',
    theme: ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primarySwatch: Colors.deepOrange,
      
    ),
    initialRoute: '/',
    routes: {
      '/'         : (context) => Home(),
      '/details'  : (context) => Details(), 
      '/login'    : (context) => LoginPage(),
      '/qrModule' : (context) => QRModule(),
      '/settings' : (context) => Settings(),
    },
    
  ));
}

