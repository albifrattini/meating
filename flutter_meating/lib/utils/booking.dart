import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/utils/authentication.dart';

abstract class BaseBooking {
  void bookEvent(String bookingEventId, int placesBooked);
}

class Booking implements BaseBooking {

  String eventId;
  final auth = Authentication();

  void bookEvent(String bookingEventId, int placesBooked) async {

    var bookingUserId = await auth.getCurrentUser();

    final String bookingId = bookingUserId + '-' + bookingEventId;
    eventId = bookingEventId;

    Firestore.instance.collection('bookings').document(bookingId)
              .setData({
                'bookerId': bookingUserId,
                'eventId': bookingEventId,
                'placesBooked': placesBooked,
                'timestamp': DateTime.now().millisecondsSinceEpoch
              });

    _reducePlacesAvailable(placesBooked);

  }

  _reducePlacesAvailable(int placesToReduce) async {

    Firestore.instance.collection('events').document(eventId).get().then((document) {

      // TODO: problemi di conversione
      int placesAvailable = int.parse(document['placesAvailable']);
      placesAvailable = placesAvailable - placesToReduce;

      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
            Firestore.instance.collection('events').document(eventId),
            {
              'placesAvailable' : placesAvailable,
            }
        );
      });

    });

  }

}