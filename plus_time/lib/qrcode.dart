import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

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
      int _selectedIndex = 1;
   
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
      
      
    return Scaffold(
      appBar: AppBar(
        title: Text("Import/export"),
      ),
      body: Center(
        child: Text(
          result,
          style: Theme.of(context).textTheme.title
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
      
       floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
        ),
     
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
