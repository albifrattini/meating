import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseBooking {
  Future<String> bookEvent(String bookingUserId, String bookingEventId, int placesBooked);
}

class Booking implements BaseBooking {

  String eventId;

  Future<String> bookEvent(String bookingUserId, String bookingEventId, int placesBooked) async {

    final String bookingId = bookingUserId + bookingEventId;
    eventId = bookingEventId;

    Firestore.instance.collection('bookings').document(bookingId)
              .setData({
                'userId': bookingUserId,
                'eventId': bookingEventId,
                //'placesBooked': placesBooked,
                'timestamp': DateTime.now().millisecondsSinceEpoch
              });

    _reducePlacesAvailable();

  }

  _reducePlacesAvailable() async {

    Firestore.instance.collection('events').document(eventId).get().then((document) {

      final int placesAvailable = document['placesAvailable'];

      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
            Firestore.instance.collection('events').document(eventId),
            {
              'placesAvailable' : placesAvailable - 1,
            }
        );
      });

    });

  }

}