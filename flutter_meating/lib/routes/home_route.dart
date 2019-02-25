import 'package:flutter/material.dart';
import 'package:flutter_meating/utils/authentication.dart';
import 'explore_route.dart';
import 'inbox_route.dart';
import 'profile_route.dart';

class HomeRoute extends StatefulWidget {

  HomeRoute({Key key, this.userId, this.auth, this.onSignedOut})
      : super(key: key);

  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _HomeRouteState(currentUserId: userId);

}

class _HomeRouteState extends State<HomeRoute> {

  final String currentUserId;
  int _currentIndex = 0;

  _HomeRouteState({this.currentUserId});



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

  Widget showRouteByIndex() {
    switch(_currentIndex) {
      case 0:
        return ExploreRoute();
      case 1:
        return InboxRoute(userId: currentUserId,);
      case 2:
        return ProfileRoute();
      default:
        print("Out of index!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: showRouteByIndex(),
      floatingActionButton: new RaisedButton(
        child: Text("Sign Out"),
          onPressed: () {
            widget.auth.signOut();
            widget.onSignedOut();
          }),
    );
  }
}