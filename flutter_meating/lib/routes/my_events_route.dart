import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/create_event_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/ui/trending_event_card.dart';
import 'package:flutter_meating/routes/event_route.dart';

class MyEventsRoute extends StatefulWidget {

  final String userId, name, surname, photoURL;

  MyEventsRoute({this.userId, this.name, this.surname, this.photoURL});

  @override
  createState() => _MyEventsRouteState();
}

class _MyEventsRouteState extends State<MyEventsRoute> {

  String _id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
        IconButton(icon: Icon(Icons.add, size: 30.0,), onPressed: _navigateToCreateEventScreen, color: Colors.white,),
        Container(width: 15.0,),
      ],),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('events')
              .where('hostId', isEqualTo: widget.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Container(); //Center(child: CircularProgressIndicator(),);
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.all(10.0),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0, left: 8.0, right: 8.0),
      child: TrendingEvent(
        hostName: document['hostName'],
        eventName: document['eventName'],
        eventCity: document['eventCity'],
        eventDescription: document['eventDescription'],
        photoUrl: document['photoURL'],
        profilePicUrl: document['profilePicURL'],
        eventDate : document['eventDate'],
        onTap: () {
          setState(() {
            _id = document['eventId'];
          });
          _navigateToEvent();
        },
      ),
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

  _navigateToEvent() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventRoute(eventId: _id, bookable: false,)));
  }

}