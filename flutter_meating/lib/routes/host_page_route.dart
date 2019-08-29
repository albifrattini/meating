import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HostRoute extends StatefulWidget {

  final String userId;

  HostRoute({this.userId});

  @override
  State<StatefulWidget> createState() => _HostRouteState();

}

class _HostRouteState extends State<HostRoute>{

  String name, surname, photoUrl, biography;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users')
                  .where('userId', isEqualTo: widget.userId)
                  .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {
                    DocumentSnapshot user = snapshot.data;
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
    return ListView(
      children: <Widget>[

        Center(
          child: Card(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(25.0)),
            child: Padding(
              padding: EdgeInsets.all(4.0),
                child:CircleAvatar(
                  radius: 40.0,
                  backgroundImage: photoUrl== '' ? AssetImage('assets/images/user.png')
                    : NetworkImage(photoUrl),
                  backgroundColor: Colors.white,
                ),
            ),
          ),
        ),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "$name",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            )
          ),
        ),

        FlatButton(
          onPressed: (){}, //aggiungere che quando clicchi manda al conversazione
          color: Color(0xFFEE6C4D),
          textColor: Colors.white,
          child: Text(
            "Contact",
            style: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(40)
        ),
        ),
        ),

      Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "$biography",
          style: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(30)
          ),
        ),
      ),
    )

  ],

  );


  }


}