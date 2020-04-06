import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiomAuth extends StatefulWidget {
  @override
  _BiomAuthState createState() => _BiomAuthState();
}

class _BiomAuthState extends State<BiomAuth> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized.";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> lisOfBiometrics;
    try {
      lisOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometricTypes = lisOfBiometrics;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
            "Please authenticate to so you can enter your favorite app.",
        //androidAuthStrings: ,
        //iOSAuthStrings: ,
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not authorized";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biometric Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Can we check Biometric: $_canCheckBiometric"),
            RaisedButton(
              onPressed: _checkBiometric,
              child: Text("Check Biometric"),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),
            Text("List of Biometrics: ${_availableBiometricTypes.toString()}"),
            RaisedButton(
              onPressed: _getListOfBiometricTypes,
              child: Text("List of Biometric Types"),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),
            Text("Authorized: $_authorizedOrNot"),
            RaisedButton(
              onPressed: _authorizeNow,
              child: Text("Authorize Now"),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),
          ],
        ),
      ),
    );
  }
}
