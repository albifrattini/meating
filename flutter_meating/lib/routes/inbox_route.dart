import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chat_route.dart';

class InboxRoute extends StatefulWidget {

  final String userId;

  InboxRoute({this.userId});

  @override
  State<StatefulWidget> createState() => _InboxRouteState(currentUserId: userId);

}

class _InboxRouteState extends State<InboxRoute> {

  final String currentUserId;

  _InboxRouteState({this.currentUserId});

  Widget _buildListChats() {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: StreamBuilder(
          stream: Firestore.instance.collection('chat').where('currentUserId', isEqualTo: currentUserId).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
          }
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if(document['currentUserId'] != currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: ScreenUtil.instance.setWidth(80),
                        backgroundImage: document['photoURL'] == '' ? null : NetworkImage(document['photoURL']),
                        backgroundColor: Color(0xFF0C6291),
                        child: document['photoURL'] == '' ? Text(document['otherUserName'][0]+document['otherUserSurname'][0]) : null,
                      ),
                      Container(width: 20.0,),
                      Text(
                        "${document['otherUserName']} ${document['otherUserSurname']}",
                        style: TextStyle(color: Colors.black, fontSize: ScreenUtil.getInstance().setSp(40)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatRoute(userId: currentUserId, recipientId: document['otherUserId'], recipientName: document['otherUserName']))
            );
          },
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        ),
        // margin: EdgeInsets.only(top: 5.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Inbox"),
        elevation: 0.0,
      ),
      body: _buildListChats(),
    );
  }

}