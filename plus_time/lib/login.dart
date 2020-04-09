import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:plus_time/data/moor_database.dart';
import 'package:provider/provider.dart';

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
  bool passSetUp = false;
  AppDatabase database;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  List<LoginOperation> loginoplst;
  String password;

  bool isAuthenticated = false;

  void _setPassCode(String passCode) {
    password = passCode;
  }

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
      if (authenticated) {
        _onAuthenticationSuccessful(1, "000000");
        Navigator.pushNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    database.getAllLoginOperations().then((lst) {
      loginoplst = lst;
    });
    Widget rt;
    if (loginoplst == null || loginoplst.isEmpty) {
      _hasBiometricsAuthent = false;
      if (_canCheckBiometrics == null) {
        _checkBiometrics().then((_) {
          if (_canCheckBiometrics) {
            _getAvailableBiometrics().then((_) {});
          }
        });
      }
      rt = Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
            Image.asset('images/logo.png'),
            Text('Hi there, we\'re +PlusTime'),
            Text('Helping you keeping track of your time.'),
            if (_availableBiometrics != null &&
                _availableBiometrics.length != 0) ...[
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
                    setState(() {
                      if (password == null) {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                opaque: false,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        PasscodeScreen(
                                          title: 'Set up the App Passcode',
                                          circleUIConfig: CircleUIConfig(
                                              borderColor: Colors.blue,
                                              fillColor: Colors.blue,
                                              circleSize: 30),
                                          keyboardUIConfig: KeyboardUIConfig(
                                              digitBorderWidth: 2,
                                              primaryColor: Colors.blue),
                                          passwordEnteredCallback:
                                              _onNewPassEntered,
                                          cancelLocalizedText: 'Cancel',
                                          deleteLocalizedText: 'Delete',
                                          shouldTriggerVerification:
                                              _verificationNotifier.stream,
                                          backgroundColor:
                                              Colors.black.withOpacity(0.8),
                                          cancelCallback: _onPasscodeCancelled,
                                        )));
                      }
                    });
                  })
            ] else ...[
              RaisedButton(
                  child: Wrap(spacing: 12, children: <Widget>[
                    Text('Pin'),
                    Icon(Icons.keyboard),
                  ]),
                  onPressed: () {
                    setState(() {
                      if (password == null) {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                opaque: false,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        PasscodeScreen(
                                          title: 'Set up the App Passcode',
                                          circleUIConfig: CircleUIConfig(
                                              borderColor: Colors.blue,
                                              fillColor: Colors.blue,
                                              circleSize: 30),
                                          keyboardUIConfig: KeyboardUIConfig(
                                              digitBorderWidth: 2,
                                              primaryColor: Colors.blue),
                                          passwordEnteredCallback:
                                              _onNewPassEntered,
                                          cancelLocalizedText: 'Cancel',
                                          deleteLocalizedText: 'Delete',
                                          shouldTriggerVerification:
                                              _verificationNotifier.stream,
                                          backgroundColor:
                                              Colors.black.withOpacity(0.8),
                                          cancelCallback: _onPasscodeCancelled,
                                        )));
                      }
                    });
                  }),
            ]
          ])));
    } else {
      rt = rt = Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
            Image.asset('images/logo.png'),
            Text('Hi there, we\'re +PlusTime'),
            Text('Helping you keeping track of your time.')
          ])));
      // 0 - pass, 1 - fingerprint
      if (loginoplst[0].type == 0) {
        passSetUp = true;
        Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PasscodeScreen(
                title: 'Enter App Passcode',
                circleUIConfig: CircleUIConfig(
                    borderColor: Colors.blue,
                    fillColor: Colors.blue,
                    circleSize: 30),
                keyboardUIConfig: KeyboardUIConfig(
                    digitBorderWidth: 2, primaryColor: Colors.blue),
                passwordEnteredCallback: _onPasscodeEntered,
                cancelLocalizedText: 'Cancel',
                deleteLocalizedText: 'Delete',
                shouldTriggerVerification: _verificationNotifier.stream,
                backgroundColor: Colors.black.withOpacity(0.8),
                cancelCallback: _onPasscodeCancelled,
              ),
            ));
      } else {
        _setPassCode(loginoplst[0].pass);
        _authenticate();
      }
    }
    return rt;
  }

  _onNewPassEntered(String enteredPasscode) {
    if (!passSetUp) {
      _setPassCode(enteredPasscode);
      _onPasscodeEntered(enteredPasscode);
      passSetUp = true;
      Navigator.of(context).pop();
      Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) =>
                PasscodeScreen(
              title: 'Enter App Passcode',
              circleUIConfig: CircleUIConfig(
                  borderColor: Colors.blue,
                  fillColor: Colors.blue,
                  circleSize: 30),
              keyboardUIConfig: KeyboardUIConfig(
                  digitBorderWidth: 2, primaryColor: Colors.blue),
              passwordEnteredCallback: _onPasscodeEntered,
              cancelLocalizedText: 'Cancel',
              deleteLocalizedText: 'Delete',
              shouldTriggerVerification: _verificationNotifier.stream,
              backgroundColor: Colors.black.withOpacity(0.8),
              cancelCallback: _onPasscodeCancelled,
            ),
          ));
    }
  }

  _onPasscodeEntered(String enteredPasscode) {
    String pass = "123456";
    if (password != null && password.length != 0) {
      pass = password;
    }
    bool isValid = pass == enteredPasscode;
    //bool isValid = widget.password == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
        if (passSetUp) {
          Navigator.pushNamed(context, '/');
        } else {
          _onAuthenticationSuccessful(0, password);
        }
      });
    }
  }

  _onPasscodeCancelled() {}

  _onAuthenticationSuccessful(int _type, String _pass) {
    if (loginoplst == null && loginoplst.isEmpty) {
      final loginOp = LoginOperation(id: 1, type: _type, pass: _pass);
      database.insertLoginOperation(loginOp);
    }
  }
}
