import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/utils/authentication.dart';

abstract class BaseBooking {
  void bookEvent(String bookingEventId, int placesBooked, String photoUrl,
      String profilePicUrl, String hostName, String eventName, String eventCity, Timestamp eventDate);
}

class Booking implements BaseBooking {

  String eventId;
  final auth = Authentication();

  void bookEvent(String bookingEventId, int placesBooked, String photoUrl,
      String profilePicUrl, String hostName, String eventName, String eventCity, Timestamp eventDate) async {

    var bookingUserId = await auth.getCurrentUser();

    final String bookingId = bookingUserId + '-' + bookingEventId;
    eventId = bookingEventId;

    Firestore.instance.collection('bookings').document(bookingId)
              .setData({
                'bookerId': bookingUserId,
                'eventId': bookingEventId,
                'eventName': eventName,
                'eventDate' : eventDate,
                'eventCity': eventCity,
                'photoURL': photoUrl,
                'profilePicURL': profilePicUrl,
                'hostName': hostName,
                'placesBooked': placesBooked + 1,
                'timestamp': DateTime.now().millisecondsSinceEpoch
              });

    _reducePlacesAvailable(placesBooked);

  }

  _reducePlacesAvailable(int placesToReduce) async {

    Firestore.instance.collection('events').document(eventId).get().then((document) {

      var placesAvailable = document['placesAvailable'];
      placesAvailable = placesAvailable - placesToReduce - 1;

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