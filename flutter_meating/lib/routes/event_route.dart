import 'package:flutter/material.dart';

class EventRoute extends StatefulWidget {

  final String eventId;

  EventRoute({this.eventId});

  @override
  createState() => _EventRouteState();

}

class _EventRouteState extends State<EventRoute> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ciao"),),
    );
  }
}