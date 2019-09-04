import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chat_route.dart';
import 'package:flutter_meating/utils/authentication.dart';
import 'package:flutter_meating/routes/review_route.dart';

class HostRoute extends StatefulWidget {

  final String userId;

  HostRoute({this.userId});

  @override
  State<StatefulWidget> createState() => _HostRouteState();

}

class _HostRouteState extends State<HostRoute>{

  String name, surname, receiverPhotoUrl, biography, currentUser, otherUserName, otherUserId, otherUserSurname, senderPhotoURL;

  final auth = Authentication();

  bool userDifferent;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      floatingActionButton: userDifferent == true ? Container(
        height: ScreenUtil.instance.setHeight(100),
        width: ScreenUtil.instance.setWidth(500),
        child:RaisedButton(

        onPressed: () => _navigateToChat(),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
        color: Color(0xFFEE6C4D),
        child: Text('Contact',
            style: TextStyle(
              color: Colors.white
        ),),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      ) ,): null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users')
                  .document(widget.userId)
                  .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {
                    var user = snapshot.data;
                    name = user['name'];
                    surname = user['surname'];
                    receiverPhotoUrl = user['photoURL'];
                    biography = user['biography'];
                    return _buildProfileView();
                      }
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(){

    getCurrentUser();

    return ListView(
           children: <Widget>[

             SizedBox(height: ScreenUtil.instance.setHeight(100)),

        Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: ScreenUtil.instance.setWidth(300),
                  backgroundImage: receiverPhotoUrl == '' ? AssetImage('assets/images/user.png')
                   : NetworkImage(receiverPhotoUrl),
                  //backgroundImage: AssetImage('assets/images/cibo.jpg'),
                  backgroundColor: Colors.white,
                ),
            ),
          ),
        ),


             SizedBox(height: ScreenUtil.instance.setHeight(50)),


        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Center(
            child: Text(
              "$name" + " " + "$surname",
              style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(50),
                fontWeight: FontWeight.w400,
              ),
            )
          ),
        ),

             SizedBox(height: ScreenUtil.instance.setHeight(50)),


             Container(
               padding: EdgeInsets.all(20),
               child: Text(
                 "Who I am",
                 style: TextStyle(
                     fontSize: ScreenUtil.getInstance().setSp(60),
                     fontWeight: FontWeight.w400,
                 ),
               ),

             ),


             Container(
                 padding: EdgeInsets.all(20),
                 child: Text(
                   "$biography",
                   style: TextStyle(
                       fontSize: ScreenUtil.getInstance().setSp(42)
                   ),
                 ),

             ),


             SizedBox(height: ScreenUtil.instance.setHeight(30)),

             userDifferent == true ? Container(
               padding: EdgeInsets.all(50),
               child: MaterialButton(
                 onPressed: () => _navigateToReviewPage(),
                 color: Colors.white,
                 elevation: 0,
                 shape: StadiumBorder(
                   side: BorderSide(
                     color: Color(0xFFEE6C4D),
                     style: BorderStyle.solid
                   )
                 ),
                 minWidth: ScreenUtil.instance.setWidth(100),
                 height: ScreenUtil.instance.setHeight(100),
                 child: Text(
                   "Leave a review",
                   style: TextStyle(
                       color: Color(0xFFEE6C4D),
                       fontSize: ScreenUtil.getInstance().setSp(50) ),
                 ),
               ),
             ) : Container(),

             Container(

               child: StreamBuilder(
                 stream: Firestore.instance.collection('reviews')
                     .where('reviewUserId', isEqualTo: widget.userId)
                     .snapshots(),
                 builder: (context, snapshot) {
                   if (!snapshot.hasData) {
                     return Center(child: CircularProgressIndicator(),);
                   } else {
                     return ListView.builder(
                       scrollDirection: Axis.vertical,
                       shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                       itemBuilder: (context, index) =>
                           buildReview(index, snapshot.data.documents[index]),
                       itemCount: snapshot.data.documents.length,
                       padding: EdgeInsets.all(10.0),
                     );
                   }
                 },
               ),
             ),
             SizedBox(height: ScreenUtil.instance.setHeight(100)),


             /*
             userDifferent == true ? Container(
                padding: EdgeInsets.all(50),
                child: MaterialButton(
                         onPressed: () => _navigateToChat(),//qui si deve fare il collegamento al messaggio col tipo
                         color: Color(0xFFEE6C4D),
                         elevation: 5,
                         shape: StadiumBorder(),
                         minWidth: ScreenUtil.instance.setWidth(100),
                         height: ScreenUtil.instance.setHeight(120),
                         child: Text(
                           "Contact",
                           style: TextStyle(
                               color: Colors.white,
                                 fontSize: ScreenUtil.getInstance().setSp(50) ),
                         ),
                      ),
              ) : Container(),
              */


           ],

  );


  }

  _navigateToReviewPage() {

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReviewRoute(reviewerId: currentUser,
            reviewerName: otherUserName, reviewerPhotoURL: senderPhotoURL,
            reviewUserId: widget.userId, reviewUserName: name))
    );

  }

  _navigateToChat() {

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection('chat').document(currentUser + DateTime.now().millisecondsSinceEpoch.toString()),
          {
            'currentUserId' : currentUser,
            'otherUserName' : name,
            'otherUserId': widget.userId,
            'otherUserSurname' : surname,
            'photoURL' : receiverPhotoUrl,
          }
      );
    });


    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection('chat').document(widget.userId + DateTime.now().millisecondsSinceEpoch.toString()),
          {
            'currentUserId' : widget.userId,
            'otherUserName' : otherUserName,
            'otherUserId': otherUserId,
            'otherUserSurname' : otherUserSurname,
            'photoURL' : senderPhotoURL,
          });
    });

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatRoute(userId: currentUser, recipientId: widget.userId, recipientName: name))
    );

  }

  getCurrentUser() async {

    await auth.getCurrentUser().then((currUser) {

      setState(() {
        currentUser = currUser;
        userDifferent = widget.userId != currUser;
      });

    });


    Firestore.instance.collection('users').document(currentUser).get().then((document) {

      otherUserName = document['name'];
      otherUserId = document['userId'];
      otherUserSurname = document['surname'];
      senderPhotoURL = document['photoURL'];

    });


  }

  Widget buildReview(int index, DocumentSnapshot document) {
    return new Padding(padding: new EdgeInsets.all(5.0),
        child: new Card(
          elevation: 0.0,
          color: Colors.transparent,
          child: new Column(
            children: <Widget>[
              Row(
                  children: <Widget> [
                    Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(ScreenUtil.instance.setWidth(100))),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child:CircleAvatar(
                          radius: ScreenUtil.instance.setWidth(80),
                          backgroundImage: document['reviewerPhotoURL'] == '' ? AssetImage('assets/images/user.png') : NetworkImage(document['reviewerPhotoURL']),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0),),
                          child: Padding(
                              padding: EdgeInsets.only(right: ScreenUtil.instance.setWidth(20), left: ScreenUtil.instance.setWidth(20)),
                              child: Text(
                                document['reviewerName'],
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(50),
                                ),
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Icon(
                                index <= document['reviewRate'] ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Text(
                  document['reviewDescription'],
                  style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(42),
                  ),
                ),
              ),

              SizedBox(height: ScreenUtil.instance.setHeight(100.0)),
            ],
          ),
        )
    );
  }


}

