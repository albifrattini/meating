import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

//classe da eliminare

class EventCard extends StatelessWidget {

  final String url = "https://firebasestorage.googleapis.com/v0/b/meat-a8354.appspot.com";


  final String photoURL;
  final String profilePicURL;
  final String hostName;
  final String eventName;
  final String eventDescription;
  final VoidCallback onTap;

  EventCard({
    @required this.hostName,
    @required this.eventName,
    @required this.eventDescription,
    @required this.photoURL,
    @required this.profilePicURL,
    @required this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            )
          ]
        ),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 200.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), bottomLeft: Radius.circular(20.0)),
                    child: photoURL == '' ? Container() : Image.network(photoURL, fit: BoxFit.cover,),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30.0, left: 70.0),
                      child: Text(hostName, style: TextStyle(fontSize: 24.0)),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0, left: 70.0),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 100.0,
                            maxWidth: 100.0,
                            minHeight: 30.0,
                            maxHeight: 100.0,
                          ),
                          child: AutoSizeText(
                            eventName,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                            minFontSize: 20.0,
                            maxLines: 2,
                            maxFontSize: 30.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ),
                    ),
                    Container(height: 15.0,),
                    Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(maxWidth: 170.0),
                      padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                      child: Text(eventDescription, maxLines: 2, style: TextStyle(fontSize: 14.0), overflow: TextOverflow.ellipsis,),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(width: 120.0),
                Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 80.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: profilePicURL == '' ? AssetImage('assets/images/user.png') : NetworkImage(profilePicURL),
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}