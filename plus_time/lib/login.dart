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

class SetPinButton extends StatefulWidget {
  @override
  _SetPinButtonState createState() => _SetPinButtonState();
}

class _SetPinButtonState extends State<SetPinButton> {
  String password;
  bool passSetUp = false;
  LoginOperationDao loginDao;
  bool isAuthenticated = false;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  List<LoginOperation> loginoplst;

  _onNewPassEntered(String enteredPasscode) {
    bool isValid = enteredPasscode == enteredPasscode;
    //bool isValid = widget.password == enteredPasscode;
    _verificationNotifier.add(isValid);
    final loginOp = LoginOperation(id: 1, type: 0, pass: enteredPasscode);
    loginDao.insertLoginOperation(loginOp).then((_) {});
    setState(() {
      password = enteredPasscode;
      loginoplst.add(loginOp);
      passSetUp = true;
    });
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
                )));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = password == enteredPasscode;
    //bool isValid = widget.password == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });
      Navigator.pushNamed(context, '/');
    }
  }

  _onPasscodeCancelled() {}

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loginDao = Provider.of<AppDatabase>(context).loginOperationDao;

    loginDao.getAllLoginOperations().then((lst) {
      loginoplst = lst;
    });
    if (loginoplst == null || loginoplst.isEmpty) {
      password = null;
    } else {
      password = loginoplst[0].pass;
    }

    return RaisedButton(
        child: Wrap(spacing: 12, children: <Widget>[
          Text('Pin'),
          Icon(Icons.keyboard),
        ]),
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PasscodeScreen(
                        title: (password == null)
                            ? 'Set up the App Passcode'
                            : 'Enter App Passcode',
                        circleUIConfig: CircleUIConfig(
                            borderColor: Colors.blue,
                            fillColor: Colors.blue,
                            circleSize: 30),
                        keyboardUIConfig: KeyboardUIConfig(
                            digitBorderWidth: 2, primaryColor: Colors.blue),
                        passwordEnteredCallback: (password == null)
                            ? _onNewPassEntered
                            : _onPasscodeEntered,
                        cancelLocalizedText: 'Cancel',
                        deleteLocalizedText: 'Delete',
                        shouldTriggerVerification: _verificationNotifier.stream,
                        backgroundColor: Colors.black.withOpacity(0.8),
                        cancelCallback: _onPasscodeCancelled,
                      )));
        });
  }
}

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
  LoginOperationDao loginDao;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  List<LoginOperation> loginoplst;
  String password;

  bool isAuthenticated = false;

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
      //setState(() {
      //  _isAuthenticating = true;
      //  _authorized = 'Authenticating';
      //});
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      //setState(() {
      //  _isAuthenticating = false;
      //  _authorized = 'Authenticating';
      //});
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    _authorized = message;
    if (authenticated) {
      if (loginoplst.isEmpty) {
        final loginOp = LoginOperation(id: 1, type: 1, pass: "000000");
        loginDao.insertLoginOperation(loginOp).then((_) {});
        setState(() {
          _authorized = message;
          loginoplst.add(loginOp);
        });
        Navigator.pushNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loginDao = Provider.of<AppDatabase>(context).loginOperationDao;

    loginDao.getAllLoginOperations().then((lst) {
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
              SetPinButton(),
            ] else ...[
              SetPinButton()
            ]
          ])));
    } else if (_authorized != 'Not Authorized') {
      rt = Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
            Image.asset('images/logo.png'),
            Text('Hi there, we\'re +PlusTime'),
            Text('Helping you keeping track of your time.'),
            if (loginoplst[0].type == 0) ...[SetPinButton()]
          ])));
      // 0 - pass, 1 - fingerprint
      if (loginoplst[0].type == 1) {
        _authenticate().then((_) {
          if (_authorized == 'Not Authorized') {
            Navigator.pushNamed(context, '/');
          }
        });
      }
    }
    return rt;
  }
}
