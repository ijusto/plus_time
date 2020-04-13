import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'services/load_calendars.dart';

/* Based on a tutorial: https://www.youtube.com/watch?v=siuJhQ9BqsU */

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  String result = "Import using the camera to scan a QR Code or export by producing a new QR Code";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied.";
        });
      } else {
        setState(() {
          result = "Someting went wrong: $e";
        });
      }
    } on FormatException {
      setState(() {
        result = "You left before scanning anything.";
      });
    } catch (e) {
      setState(() {
        result = "Someting went wrong: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      int _selectedIndex = 2;
   
    return Scaffold(
      appBar: AppBar(
        title: Text("Import/export"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
                  result,
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add Event'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export),
            title: Text('Import/export'),
          ),
         
          
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).disabledColor,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            print("Selected index is $_selectedIndex");
            switch (_selectedIndex) {
              case 0: // Home
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home(Provider.of<ProjectsInfo>(context))));
                break;
              case 1: // Add Event
                Navigator.pushNamed(context, '/add_event');
                break;
              case 2: // Import/export
                Navigator.pushNamed(context, '/qrModule');
                break;
              case 3: // Logout
                Navigator.pushNamed(context, '/login');
                break;
            }
          });
        },
      ),
      
       floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
        ),
     
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
