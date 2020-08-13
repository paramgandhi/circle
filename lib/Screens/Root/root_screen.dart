import 'package:circle/Screens/Home/main_screen.dart';
import 'package:circle/Screens/Splash/splash_screen.dart';
import 'package:circle/Screens/Welcome/welcome_screen.dart';
import 'package:circle/Services/Authentication/authentication.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
// Widget _Splash = new SplashScreen();

class RootScreen extends StatefulWidget {
  RootScreen({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  // CloudDB cloudDB;
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
    Navigator.pop(context);
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return new SplashScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new WelcomeScreen(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        // return new WelcomeScreen();
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new MainScreen(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
          // return new HomeScreen();
        } else
          return new SplashScreen();
        break;
      default:
        return new SplashScreen();
    }
  }
}
