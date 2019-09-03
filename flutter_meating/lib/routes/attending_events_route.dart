import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/event_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/ui/trending_event_card.dart';

class AttendingEventsRoute extends StatefulWidget {

  final String userId, name, surname, photoURL;

  AttendingEventsRoute({this.userId, this.name, this.surname, this.photoURL});

  @override
  createState() => _AttendingEventsRouteState();
}

class _AttendingEventsRouteState extends State<AttendingEventsRoute> {

  bool itemBuilt = false;
  String _id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: Text('Attending'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('bookings')
              .where('bookerId', isEqualTo: widget.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
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
        eventDate: document['eventDate'],
        onTap: () {
          setState(() {
            _id = document['eventId'];
          });
          _navigateToEvent();
        },
      ),
    );

  }

  _navigateToEvent() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventRoute(eventId: _id, bookable: false,)));
  }


}