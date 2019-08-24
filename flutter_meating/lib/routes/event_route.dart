import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventRoute extends StatefulWidget {

  final String eventId;

  EventRoute({this.eventId});

  @override
  createState() => _EventRouteState();

}

class _EventRouteState extends State<EventRoute> {

  DocumentSnapshot document;
  bool downloaded = false;

  @override
  Widget build(BuildContext context) {
    getEvent();
    return Scaffold(
      appBar: AppBar(
        title: downloaded ? Text(document['eventName']) : Text('Nome evento'),
        elevation: 0.0,
      ),
      body: downloaded ? buildDetailEvent() : CircularProgressIndicator(),
    );
  }

  Widget buildDetailEvent() {
    return ListView(
      children: <Widget>[
        Text(document['eventName']),
        Text(document['eventCity']),
        Text(document['hostName']),
        Text(document['eventDescription']),
        Text(document['photoURL']),
      ],
    );
  }

  void getEvent() async {
    Firestore.instance.collection('events').document(widget.eventId).get().then((result) {
      document = result;
      setState(() {
        downloaded = true;
      });
    });
  }

}