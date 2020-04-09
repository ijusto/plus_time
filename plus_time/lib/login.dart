import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:plus_time/passcodeScreen.dart';

/* Based on a tutorial: https://www.youtube.com/watch?v=S1ta90cTxBA */

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool _hasBiometricsAuthent;
  String _passcode;

  // Returns true if device is capable of checking biometrics
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  // Returns a list of enrolled biometrics
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    _hasBiometricsAuthent = false;
    if (_canCheckBiometrics == null) {
      _checkBiometrics().then((_) {
        if (_canCheckBiometrics) {
          _getAvailableBiometrics().then((_) {});
        }
      });
    }

    if (_availableBiometrics.length != 0) {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                      'Two modes of authentication are available. Choose the one that suits you best.'),
                  RaisedButton(
                      child: Wrap(spacing: 12, children: <Widget>[
                        Text('Biometrics'),
                        Icon(Icons.fingerprint),
                      ]),
                      onPressed: _authenticate),
                  RaisedButton(
                      child: Wrap(spacing: 12, children: <Widget>[
                        Text('Pin'),
                        Icon(Icons.keyboard),
                      ]),
                      onPressed: () {
                        Navigator.pushNamed(context, "/passCode");
                      }),
                  Text('Current State: $_authorized\n'),
                ])),
      ));
    } else {
      Navigator.pushNamed(context, "/passCode");
    }
  }
}
