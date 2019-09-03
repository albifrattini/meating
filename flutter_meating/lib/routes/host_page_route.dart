import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chat_route.dart';
import 'package:flutter_meating/utils/authentication.dart';

class HostRoute extends StatefulWidget {

  final String userId;

  HostRoute({this.userId});

  @override
  State<StatefulWidget> createState() => _HostRouteState();

}

class _HostRouteState extends State<HostRoute>{

  String name, surname, photoUrl, biography, currentUser, otherUserName, otherUserId, otherUserSurname, photoURL;

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
      floatingActionButton: userDifferent == true ? FloatingActionButton.extended(
        backgroundColor: Color(0xFFEE6C4D),
        onPressed: () => _navigateToChat(),
        isExtended: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text('Contact'),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    photoUrl = user['photoURL'];
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
                  backgroundImage: photoUrl== '' ? AssetImage('assets/images/user.png')
                   : NetworkImage(photoUrl),
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
                fontSize: ScreenUtil.getInstance().setSp(40),
                fontWeight: FontWeight.w500,
              ),
            )
          ),
        ),

             SizedBox(height: ScreenUtil.instance.setHeight(50)),


             Container(
               padding: EdgeInsets.all(20),
               child: Text(
                 "Somethig about me:",
                 style: TextStyle(
                     fontSize: ScreenUtil.getInstance().setSp(40),
                     fontWeight: FontWeight.w300,
                 ),
               ),

             ),

             SizedBox(height: ScreenUtil.instance.setHeight(10)),


             Container(
                 padding: EdgeInsets.all(20),
                 child: Text(
                   "$biography",
                   style: TextStyle(
                       fontSize: ScreenUtil.getInstance().setSp(40)
                   ),
                 ),

             ),


             SizedBox(height: ScreenUtil.instance.setHeight(30)),

             Container(
               padding: EdgeInsets.all(50),
               child: MaterialButton(
                 onPressed: () => print('Tapped'),
                 color: Color(0xFFEE6C4D),
                 elevation: 5,
                 shape: StadiumBorder(),
                 minWidth: ScreenUtil.instance.setWidth(100),
                 height: ScreenUtil.instance.setHeight(100),
                 child: Text(
                   "Leave a review",
                   style: TextStyle(
                       color: Colors.white,
                       fontSize: ScreenUtil.getInstance().setSp(50) ),
                 ),
               ),
             ),

             Container(
               child: StreamBuilder(
                 stream: Firestore.instance.collection('reviews')
                     .where('reviewUserId', isEqualTo: widget.userId)
                     .orderBy('reviewDate')
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

  _navigateToChat() {

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection('chat').document(currentUser + '-UserReceiver'),
          {
            'currentUserId' : currentUser,
            'otherUserName' : name,
            'otherUserId': widget.userId,
            'otherUserSurname' : surname,
            'photoURL' : photoUrl,
          }
      );
    });


    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection('chat').document(widget.userId + '-UserSender'),
          {
            'currentUserId' : widget.userId,
            'otherUserName' : otherUserName,
            'otherUserId': otherUserId,
            'otherUserSurname' : otherUserSurname,
            'photoURL' : photoURL,
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
      photoURL = document['photoURL'];

    });


  }

  Widget buildReview(int index, DocumentSnapshot document) {
    return new Padding(padding: new EdgeInsets.all(10.0),
        child: new Card(
          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(
                    "Name :"
                ),
                subtitle: new Text(
                    "Decription : You may go now!!"
                ),
              ),
            ],
          ),
        )
    );
  }


}