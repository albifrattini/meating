import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/create_event_screen.dart';

class MyEventsRoute extends StatefulWidget {

  final String userId, name, surname, photoURL;

  MyEventsRoute({this.userId, this.name, this.surname, this.photoURL});

  @override
  createState() => _MyEventsRouteState();
}

class _MyEventsRouteState extends State<MyEventsRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, actions: <Widget>[
        IconButton(icon: Icon(Icons.add, size: 30.0,), onPressed: _navigateToCreateEventScreen, color: Colors.white,),
        Container(width: 15.0,),
      ],),
    );
  }

  _navigateToCreateEventScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEventScreen(
      userId: widget.userId,
      name: widget.name,
      surname: widget.surname,
      profilePicURL: widget.photoURL,
    )));
  }

}