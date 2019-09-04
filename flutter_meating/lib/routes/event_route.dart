import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/host_page_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_meating/utils/booking.dart';
import 'package:flutter_meating/utils/authentication.dart';


class EventRoute extends StatefulWidget {

  final String eventId;
  final bool bookable;

  EventRoute({this.eventId, this.bookable});

  @override
  createState() => _EventRouteState();
}

class _EventRouteState extends State<EventRoute> {

  DocumentSnapshot document;

  bool downloaded = false;
  bool _showBookingSuccessful = false;
  bool userDifferent = false;

  Timestamp timestamp;
  DateTime date;
  String _hostId, currentUser;

  final auth = Authentication();


  TextEditingController _textPeopleController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    getEvent();
    return Scaffold(
      appBar: AppBar(
        title: downloaded ? Text(document['eventName']) : Text('Nome evento'),
        elevation: 0.0,
      ),
      body: downloaded ? buildDetailEvent() : Center(child:CircularProgressIndicator()),
      floatingActionButton: widget.bookable && userDifferent ? Container(
        height: ScreenUtil.instance.setHeight(140),
        width: ScreenUtil.instance.setWidth(500),
        child:RaisedButton(

        color: Color(0xFFEE6C4D),
        onPressed: () {
          print(_hostId);
          print(currentUser);
          Alert(
              context: context,
              title: "Book your place",
              content: Column(
                children: <Widget>[
                  Text(
                      "How many people will come with you?"
                  ),
                  TextField(
                    controller: _textPeopleController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.people),
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () => _bookEvent(int.parse(_textPeopleController.text)),
                  color: Color(0xFFEE6C4D),
                  child: Text(
                    "Book",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20 ),
                  ),
                )
              ]).show();
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text('Book',
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getInstance().setSp(60),
          ),),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      ),) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void getEvent() async {
    Firestore.instance.collection('events').document(widget.eventId).get().then((result) {
      document = result;
      timestamp = document['eventDate'];
      date = new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
      setState(() {
        downloaded = true;
      });
    });
  }

  _navigateToHostPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HostRoute(userId: _hostId)));
  }

  _resetMainPage() {
    Navigator.pop(context);
  }

  Widget buildDetailEvent() {
      return Stack(
        children: <Widget>[


          ListView(

            children: <Widget>[


              Container(
                height: ScreenUtil.instance.setHeight(500),
                width: ScreenUtil.instance.setWidth(200),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: downloaded ? Image.network(
                        document["photoURL"],
                        height: ScreenUtil.instance.setHeight(600),
                        width: ScreenUtil.instance.setWidth(1080),
                        fit: BoxFit.cover,
                      ) : Text("photo"),
                    ),


                  ],
                ),
              ),

              SizedBox(height: ScreenUtil.instance.setHeight(50)),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(height: ScreenUtil.instance.setHeight(30)),


                    Text(
                      DateFormat.yMMMMd().format(date) + ' at ' + DateFormat.Hm().format(date),//qui non riesco a ritornare la data
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontWeight: FontWeight.w600,
                      ),
                    ),


                    SizedBox(height: ScreenUtil.instance.setHeight(30)),


                    Text(
                      document['placesAvailable'].toString() + " places available out of " + document['totalPlaces'].toString(),
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontWeight: FontWeight.w600
                      ),
                    ),


                    SizedBox(height: ScreenUtil.instance.setHeight(120)),


                    Text(
                      document['eventDescription'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(42),
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    
                    SizedBox(height: ScreenUtil.instance.setHeight(80)),
                    
                    Center(
                      child: Text(
                      "Host",
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),),

                    SizedBox(height: ScreenUtil.instance.setHeight(40)),

                  Center(
                      child: RaisedButton(
                      onPressed: () => _navigateToHostPage(),
                      color: Colors.white,
                      elevation: 0,
                      child: CircleAvatar(
                        radius: ScreenUtil.instance.setWidth(150),
                        backgroundImage: document['profilePicURL']== '' ? AssetImage('assets/images/user.png')
                            : NetworkImage(document['profilePicURL']),
                        backgroundColor: Colors.white,
                      ),

                    ),),


                    SizedBox(height: ScreenUtil.instance.setHeight(40)),

                    Center(
                      child:Text(
                      document['hostName'] + " " + document['hostSurname'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40)
                      ),
                    ),),
                    
                  ],
                ),
              ),


                  SizedBox(height: ScreenUtil.instance.setHeight(100)),




                  /*


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil.instance.setHeight(200) ,
                        width: ScreenUtil.instance.setWidth(200),
                        padding: EdgeInsets.only(left: 20),
                        child: RawMaterialButton(
                          shape: CircleBorder(),
                          onPressed: () {},// qui quando uno clicca si deve aggiungere l'evento ai preferiti
                          fillColor: Colors.white,
                          child: Center(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red[700],
                                size: ScreenUtil.instance.setWidth(90),
                              )
                          ),
                        ),
                      ),

                      Container(
                        height: ScreenUtil.instance.setHeight(200) ,
                        width: ScreenUtil.instance.setWidth(200),
                        padding: EdgeInsets.only(right: 20),
                        child: RawMaterialButton(
                          shape: CircleBorder(),
                          onPressed: () {
                            Alert(
                                context: context,
                                title: "BOOK YOUR PLACE",
                                content: Column(
                                  children: <Widget>[
                                    Text(
                                      "Insert how many people will participate with you at the event"
                                    ),
                                    TextField(
                                      controller: _textPeopleController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.people),
                                      ),
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    //
                                    //
                                    // Decrementare persone
                                    //
                                    //
                                    //
                                    onPressed: () => _bookEvent(int.parse(_textPeopleController.text)),
                                    color: Color(0xFFEE6C4D),
                                    child: Text(
                                      "BOOK",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20 ),
                                    ),
                                  )
                                ]).show();
                          },

                          fillColor: Color(0xFFEE6C4D),
                          child: Center(
                            child: Text("Book", style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.getInstance().setSp(50),
                            ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),


                  */

              SizedBox(height: ScreenUtil.instance.setHeight(200)),

            ],
          ),

          _showBookingSuccessful ? AlertDialog(
                                    title: Text("Booking Successful", style: TextStyle(color: Colors.red[900],),),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Ok"),
                                        onPressed: _resetMainPage,
                                      ),
                                    ],
                                  ) : Container(),
        ],
      );
    }

    _bookEvent (int placesBooked) {

      final Booking booking = new Booking();

      booking.bookEvent(widget.eventId, placesBooked, document['photoURL'], document['profilePicURL'],
          document['hostName'], document['eventName'], document['eventCity'], document['eventDate']);

      Navigator.pop(context);

      setState(() {
        _showBookingSuccessful = true;
      });

    }


  getCurrentUser() async {
    await auth.getCurrentUser().then((currUser) {
      setState(() {
        _hostId = document['hostId'];
        currentUser = currUser;
        userDifferent = _hostId != currUser;
      });
    });
  }




}
