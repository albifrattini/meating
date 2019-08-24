import 'package:flutter/material.dart';
import 'package:flutter_meating/utils/authentication.dart';
import 'package:flutter_meating/routes/login_signup_route.dart';
import 'package:flutter_meating/routes/home_route.dart';

enum AuthenticationStatus {
  NOT_DETERMINED,
  LOGGED_IN,
  NOT_LOGGED_IN
}

class RootRoute extends StatefulWidget {

  final BaseAuth auth;

  RootRoute({this.auth});

  @override
  State<StatefulWidget> createState() => _RootRouteState();

}

class _RootRouteState extends State<RootRoute> {

  AuthenticationStatus authenticationStatus = AuthenticationStatus.NOT_DETERMINED;
  String _userId = "";

  // After overriding this method, there will be a request to Firebase server through the application.
  // If (there is a user logged in): assign the ID from the server to the variable _userId
  // Else: the application understands there is no one logged in
  // In both cases setState is called and so Widget build is called to present the right Route (Login or Home),
  // depending on AuthenticationStatus
  // IMPORTANT: using function.then() is like putting 'async' after function name and 'await' before
  // value to be returned, but in this case we use then because we don't put 'async' after initState()
  // that is a function already defined in every class that extends a Stateful/lessWidget.
  // See LoginSignupRoute for 'async-await' example.
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((userUid) {
      setState(() {
        if (userUid != null) {
          _userId = userUid;
        }
        authenticationStatus = userUid == null ? AuthenticationStatus.NOT_LOGGED_IN : AuthenticationStatus.LOGGED_IN;
      });
    });
  }

  // VoidCallback performed when the user taps on 'Login' button in LoginSignupRoute.
  void _onSignedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.toString();
      });
    });
    setState(() {
      authenticationStatus = AuthenticationStatus.LOGGED_IN;
    });
  }

  // VoidCallback performed when the user taps on 'SignOut' button in HomeRoute.
  void _onSignedOut() {
    setState(() {
      authenticationStatus = AuthenticationStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  // Returns  a ProgressIndicator while waiting for AuthenticationStatus to be either
  // .LOGGED_IN or .NOT_LOGGED_IN.
  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authenticationStatus) {
      // Happens when initState is waiting for .getCurrentUser() async answer. Normally shouldn't take long.
      case AuthenticationStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      // Happens when .getCurrentUser() finds a logged in user or when the Login has succeeded
      // in LoginSignupRoute. Redirects the user to the HomeRoute.
      case AuthenticationStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomeRoute(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        } else return _buildWaitingScreen();
        break;
      // Happens when .getCurrentUser() didn't find any user currently logged in and will redirect
      // the user to the LoginSignupRoute.
      case AuthenticationStatus.NOT_LOGGED_IN:
        return new LoginSignUpRoute(
          auth: widget.auth,
          onSignedIn: _onSignedIn,
        );
        break;
      default:
        return _buildWaitingScreen();
        break;
    }
  }

}