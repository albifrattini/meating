import 'package:flutter/material.dart';
import 'package:flutter_meating/utils/authentication.dart';

class HomeRoute extends StatefulWidget {

  HomeRoute({Key key, this.userId, this.auth, this.onSignedOut})
      : super(key: key);

  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _HomeRouteState();

}

class _HomeRouteState extends State<HomeRoute> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new RaisedButton(
        child: Text("Sign Out"),
          onPressed: () {
            widget.auth.signOut();
            widget.onSignedOut();
          }),
    );
  }
}