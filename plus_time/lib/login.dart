import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:plus_time/data/moor_database.dart';
import 'package:plus_time/home.dart';
import 'package:plus_time/services/load_calendars.dart';
import 'package:plus_time/services/locationService.dart';
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

  bool _isLoading = true;
  void _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _onLoading();
  }

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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(Provider.of<ProjectsInfo>(context))));
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
      setState(() {
        _isLoading = false;
      });
    });
    if (loginoplst == null || loginoplst.isEmpty) {
      password = null;
    } else {
      password = loginoplst[0].pass;
    }

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return FloatingActionButton.extended(
          heroTag: "btn2",
          icon: Icon(Icons.keyboard),
          label: Text("Pin"),
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
                          shouldTriggerVerification:
                              _verificationNotifier.stream,
                          backgroundColor: Colors.black.withOpacity(0.8),
                          cancelCallback: _onPasscodeCancelled,
                        )));
          });
    }
  }
}

class Login extends StatefulWidget {
  Login({Key key, this.locationService}) : super(key: key);
  final LocationService locationService;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool passSetUp = false;
  LoginOperationDao loginDao;
  AccessesGivenDao permsDao;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  List<LoginOperation> loginoplst;
  List<AccessGivenEntry> permlist;
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
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Home(Provider.of<ProjectsInfo>(context))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loginDao = Provider.of<AppDatabase>(context).loginOperationDao;
    permsDao = Provider.of<AppDatabase>(context).accessesGivenDao;
    loginDao.getAllLoginOperations().then((lst) {
      loginoplst = lst;
    });
    permsDao.getAllAccessesGivens().then((perms) async {
      for (AccessGivenEntry perm in perms) {
        if (perm.typeOfAccess == "location" && perm.granted) {
          widget.locationService.getUserLocation().then((_) {});
        }
      }
    });

    Widget rt = Scaffold();
    if (loginoplst == null || loginoplst.isEmpty) {
      if (_canCheckBiometrics == null) {
        _checkBiometrics().then((_) {
          if (_canCheckBiometrics) {
            _getAvailableBiometrics().then((_) {});
          }
        });
      }
      rt = Scaffold(
          body: Center(
              child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Image.asset('assets/calendar(3).jpg'),
                ),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Hi there, we\'re +PlusTime",
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Helping you keeping track of your time",
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 70.0, bottom: 10.0),
          child: Text(
            "Login using: ",
            style: Theme.of(context).textTheme.subtitle,
            textAlign: TextAlign.center,
          ),
        ),
        if (_availableBiometrics != null &&
            _availableBiometrics.length != 0) ...[
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: FloatingActionButton.extended(
                  heroTag: "btn1",
                  icon: Icon(Icons.fingerprint),
                  label: Text("Biometrics"),
                  onPressed: _authenticate)),
          new Padding(padding: EdgeInsets.all(10.0), child: SetPinButton()),
        ] else ...[
          new Padding(padding: EdgeInsets.all(10.0), child: SetPinButton())
        ]
      ])));
    } else if (_authorized == 'Not Authorized') {
      rt = Scaffold(
          body: Container(
              child: new Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                      child: Column(children: <Widget>[
                    if (loginoplst[0].type == 0) ...[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/pin.png'),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/fingerprint.jpg'),
                      ),
                    ],
                    Text(
                      'Hi there, we\'re +PlusTime',
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Helping you keeping track of your time',
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                    if (loginoplst[0].type == 0) ...[SetPinButton()]
                  ])))));
      // 0 - pass, 1 - fingerprint
      if (loginoplst[0].type == 1) {
        _authenticate().then((_) {
          if (_authorized != 'Not Authorized') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Home(Provider.of<ProjectsInfo>(context))));
          }
        });
      }
    }
    return rt;
  }
}
