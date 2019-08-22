import 'package:flutter/material.dart';

class TrendingEvent extends StatefulWidget {
  final String url = "https://firebasestorage.googleapis.com/v0/b/meat-a8354.appspot.com";

  final String photoUrl;
  final String eventName;
  final String eventCity;
  final String eventDescription;
  final String hostName;
  //final String rating;
  final String profilePicUrl;
  final VoidCallback onTap;

  TrendingEvent({
    Key key,
    @required this.photoUrl,
    @required this.eventName,
    @required this.eventCity,
    @required this.eventDescription,
    @required this.hostName,
    //@required this.rating,
    @required this.profilePicUrl,
    @required this.onTap,
  })
      : super(key: key);

  @override
  _TrendingEventState createState() => _TrendingEventState();
}

class _TrendingEventState extends State<TrendingEvent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ,
      child: Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height/2.5,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height/3.5,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: widget.photoUrl == '' ? Container() : Image.network(
                        widget.photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),


                  /*Positioned(  da aggiungere al db, finto o fare una funzione che calcoli la media tra le recensioni
                    top: 6.0,
                    right: 6.0,
                    child: Card(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow[200],
                              size: 10,
                            ),

                            Text(
                              " ${widget.rating} ",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/


                  Positioned(
                    top: 6.0,
                    left: 6.0,
                    child: Row(
                      children: <Widget> [
                        Card(
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(25.0)),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child:CircleAvatar(
                              radius: 20.0,
                              backgroundImage: widget.profilePicUrl== '' ? AssetImage('assets/images/user.png') : NetworkImage(widget.profilePicUrl),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                         Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                           child: Padding(
                            padding: EdgeInsets.all(4.0),
                             child: Text(
                              "${widget.hostName}",
                               style: TextStyle(
                                 fontSize: 15,
                                ),
                              )
                            ),

                        ),
                    ],
                  ),
                  )
                ],
              ),

              SizedBox(height: 7.0),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.eventName}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              SizedBox(height: 5.0),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.eventCity}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "More Details: ${widget.eventDescription}..>",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    ),
    );
  }
}