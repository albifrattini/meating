import 'package:flutter/material.dart';
import 'package:flutter_meating/utils/authentication.dart';
import 'explore_route.dart';
import 'chat_route.dart';
import 'profile_route.dart';

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

  int _currentIndex = 0;
  final List<Widget> _routes = [
    ExploreRoute(),
    ChatRoute(),
    ProfileRoute()
  ];

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text("Inbox"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile"),
          ),
        ]
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: _routes[_currentIndex],
      floatingActionButton: new RaisedButton(
        child: Text("Sign Out"),
          onPressed: () {
            widget.auth.signOut();
            widget.onSignedOut();
          }),
    );
  }
}