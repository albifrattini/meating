import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


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



  void getEvent() async {
    Firestore.instance.collection('events').document(widget.eventId).get().then((result) {
      document = result;
      setState(() {
        downloaded = true;
      });
    });
  }

  Widget buildDetailEvent() {
      return Stack(
        children: <Widget>[
          ListView(

            children: <Widget>[

              SizedBox( height: ScreenUtil.instance.setHeight(10)),

              Container(
                height: ScreenUtil.instance.setHeight(500),
                width: ScreenUtil.instance.setWidth(200),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.asset('assets/images/ciboo.jpg',
                      height: ScreenUtil.instance.setHeight(1920),
                      width: ScreenUtil.instance.setWidth(1080),
                      fit: BoxFit.cover,
                      ),
                    ),


                  ],
                ),
              ),

              SizedBox(height: ScreenUtil.instance.setHeight(50)),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      document['eventName'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(50),
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: ScreenUtil.instance.setHeight(10)),

                    /*Text(

                      DateFormat.yMMMMd().format(document['eventDate']) + ' - ' + DateFormat.Hm().format(document['eventDate']),
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(27),
                        fontWeight: FontWeight.w600,
                      ),
                    ),*/

                    SizedBox(height: ScreenUtil.instance.setHeight(30)),

                    Text(
                      "Total places:  " + document['totalPlaces'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40),
                      ),
                    ),

                    SizedBox(height: ScreenUtil.instance.setHeight(30)),

                    Text(
                      document['eventDescription'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Host",
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                  ],
                ),
              ),
                  
                  SizedBox(height: ScreenUtil.instance.setHeight(100)),



                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: FloatingActionButton(
                        onPressed: (){},
                        backgroundColor: Colors.white,
                        child: Center(
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red[700],
                              size: 35,
                            )
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: ScreenUtil.instance.setHeight(50)),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: FloatingActionButton(
                        onPressed: (){},
                        backgroundColor: Color(0xFFEE6C4D),
                        child: Center(
                          child: Text("Book", style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(40),
                          ),
                          ),
                        ),
                      ),
                    ),
                  ),

            ],
          )
        ],
      );
    }


}
