import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrendingEvent extends StatefulWidget {
  final String url = "https://firebasestorage.googleapis.com/v0/b/meat-a8354.appspot.com";

  final String photoUrl;
  final String eventName;
  final String eventCity;
  final String eventDescription;
  final String hostName;
  final String eventId;
  //final String rating;
  final String profilePicUrl;
  final VoidCallback onTap;
  final String totalPlaces;

  TrendingEvent({
    Key key,
    @required this.photoUrl,
    @required this.eventName,
    @required this.eventCity,
    @required this.eventDescription,
    @required this.hostName,
    @required this.eventId,
    //@required this.rating,
    @required this.profilePicUrl,
    @required this.onTap,
    @required this.totalPlaces,
  })
      : super(key: key);

  @override
  _TrendingEventState createState() => _TrendingEventState();
}


class _TrendingEventState extends State<TrendingEvent> {

  Widget _buildLens(){
    if(widget.totalPlaces != ' ') {
      return Icon(Icons.lens, color: Colors.green, size: 15,);
    }
    else {
      return Icon(Icons.lens, color: Colors.red, size: 15,);
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ,
      child: Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: ScreenUtil.instance.setHeight(800),
        width: ScreenUtil.instance.setWidth(1080),
        child: Card(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil.instance.setHeight(600),
                    width: ScreenUtil.instance.setWidth(1080),
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

                  Positioned(
                    top: 30.0,
                    right: 16.0,
                    child: Container(
                      child: _buildLens(),
                    )
                  ),



                  Positioned(
                    top: 6.0,
                    left: 6.0,
                    child: Row(
                      children: <Widget> [
                        Card(
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(ScreenUtil.instance.setWidth(100))),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child:CircleAvatar(
                              radius: ScreenUtil.instance.setWidth(80),
                              backgroundImage: widget.profilePicUrl== '' ? AssetImage('assets/images/user.png') : NetworkImage(widget.profilePicUrl),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                         Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                           child: Padding(
                            padding: EdgeInsets.only(right: ScreenUtil.instance.setWidth(20), left: ScreenUtil.instance.setWidth(20)),
                             child: Text(
                              "${widget.hostName}",
                               style: TextStyle(
                                 fontSize: ScreenUtil.getInstance().setSp(50),
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
                      fontSize: ScreenUtil.instance.setSp(42.0),
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              SizedBox(height: ScreenUtil.instance.setHeight(5.0)),

              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.eventCity}",
                    style: TextStyle(
                      fontSize: ScreenUtil.instance.setSp(40.0),
                      fontWeight: FontWeight.w300,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                      fontSize: ScreenUtil.instance.setSp(30.0)
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    ),
    );

  }
}