import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/create_event_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
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

    itemBuilt = false;
    final eventId = document['eventId'];
    // var hostName, eventName, eventCity, eventDescription, photoUrl, profilePicUrl;
    TrendingEvent trendingEvent;

    Firestore.instance.collection('events').document(eventId).get().then((result) {
      /*
      hostName = result['hostName'];
      eventName = result['eventName'];
      eventCity = result['eventCity'];
      eventDescription = result['eventDescription'];
      photoUrl = result['photoURL'];
      profilePicUrl = result['profilePicURL'];
      */
      trendingEvent = new TrendingEvent(photoUrl: result['photoURL'], eventName: result['eventName'], eventCity: result['eventCity'],
          eventDescription: result['eventDescription'], hostName: result['hostName'], eventId: eventId,
          profilePicUrl: result['profilePicURL']);
    });


    return trendingEvent != null ? Container(
      padding: EdgeInsets.only(bottom: 15.0, left: 8.0, right: 8.0),
      child: trendingEvent,
    ) : Container();
  }


}