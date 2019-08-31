import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/host_page_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class EventRoute extends StatefulWidget {

  final String eventId;

  EventRoute({this.eventId});

  @override
  createState() => _EventRouteState();
}

class _EventRouteState extends State<EventRoute> {

  DocumentSnapshot document;
  bool downloaded = false;
  String _userId;

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

  _navigateToHostPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HostRoute(userId: _userId)));
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
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(height: ScreenUtil.instance.setHeight(30)),


                    Text(
                      "document['eventDate']",//qui non riesco a ritornare la data
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40),
                        fontWeight: FontWeight.w600,
                      ),
                    ),


                    SizedBox(height: ScreenUtil.instance.setHeight(30)),


                    Text(
                      "Total places:  " + document['totalPlaces'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40),
                        fontWeight: FontWeight.w600
                      ),
                    ),


                    SizedBox(height: ScreenUtil.instance.setHeight(30)),


                    Text(
                      document['eventDescription'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40),
                        fontWeight: FontWeight.w600,
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
                      onPressed: () {
                        setState(() {
                          _userId = document['hostId'];
                        });
                        _navigateToHostPage();
                      },
                      color: Colors.white,
                      elevation: 0,
                      child: CircleAvatar(
                        radius: ScreenUtil.instance.setWidth(150),
                        backgroundImage: document['profilePicURL']== '' ? AssetImage('assets/images/user.png')
                            : NetworkImage(document['profilePicURL']),
                        backgroundColor: Colors.white,
                      ),

                    ),),


                    SizedBox(height: ScreenUtil.instance.setHeight(30)),

                    Center(
                      child:Text(
                      document['hostName'] + "  " + document['hostSurname'],
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(40)
                      ),
                    ),),
                    
                  ],
                ),
              ),


                  SizedBox(height: ScreenUtil.instance.setHeight(50)),


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
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.people),
                                      ),
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    onPressed: () => Navigator.pop(context),//qui si deve fare il decremento
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

              SizedBox(height: ScreenUtil.instance.setHeight(100)),

            ],
          )
        ],
      );
    }




}
