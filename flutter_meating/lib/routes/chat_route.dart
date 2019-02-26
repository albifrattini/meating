import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatRoute extends StatelessWidget {

  final String recipientId;
  final String userId;

  ChatRoute({@required this.recipientId, @required this.userId});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Chat',
        ),
        centerTitle: true,
      ),
      body: new ChatScreen(
        recipientId: recipientId,
        userId: userId,
      ),
    );
  }

}

class ChatScreen extends StatefulWidget {

  final String recipientId;
  final String userId;

  ChatScreen({@required this.recipientId, @required this.userId});

  @override
  State<StatefulWidget> createState() => _ChatScreenState(recipientId: recipientId, userId: userId);

}

class _ChatScreenState extends State<ChatScreen> {

  String recipientId;
  String userId;
  String groupChatId;

  var listMessage;

  final ScrollController listScrollController = new ScrollController();
  final TextEditingController textController = new TextEditingController();
  // is used to Focus on something when it has been tapped. In this case we are using
  // FocusNode to let the program focus on the TextField when the user taps on it.
  // !! FocusNodes are LONG-LIVED OBJECTS, i.e. we need to manage the lifecyle using a State
  // class. We need to create the instance and then dispose at the end of the usage.
  // Used when you want to focus on the TextField (in this case) when something is tapped.
  final FocusNode focusNode = new FocusNode();



  _ChatScreenState({@required this.recipientId, @required this.userId});

  @override
  void initState() {
    super.initState();

    groupChatId = '';

    getGroupChatId();
  }

  getGroupChatId() {
    if(userId.hashCode <= recipientId.hashCode) {
      groupChatId = '$userId-$recipientId';
    } else {
      groupChatId = '$recipientId-$userId';
    }
    setState(() {});
  }

  void onSendMessage(String content, String type) {
    if (content.trim() != '') {
      textController.clear();

      var documentReference = Firestore.
                              instance.
                              collection('messages').
                              document(groupChatId).
                              collection(groupChatId).
                              document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'senderId' : userId,
            'recipientId' : recipientId,
            'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
            'content' : content,
            'type' : type
          }
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['senderId'] == userId) {
      return Row(
        children: <Widget>[
          document['type'] == 'text'
          ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Colors.white, fontSize: 17.0),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: Color(0xFFEE6C4D), borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
              : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document['type'] == 'text'
                ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.black, fontSize: 17.0),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(),
              ],
            ),
            isLastMessageLeft(index)
            ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(document['timestamp']))),
                style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index-1]['senderId'] == userId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index-1]['senderId'] != userId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            buildListMessage(),
            buildInput(),
          ],
        ),
        buildLoading(),
      ],
    );
  }

  Widget buildLoading() {
    return Container();
  }

  Widget buildListMessage() {
    return Flexible(
        child: groupChatId == ''
            ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),),)
            : StreamBuilder(
                stream: Firestore.
                        instance.
                        collection('messages').
                        document(groupChatId).
                        collection(groupChatId).
                        orderBy('timestamp', descending: true).
                        limit(20).
                        snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {
                    listMessage = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
        ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 17.0),
                controller: textController,
                // InputDecoration.collapsed is defining an InputDecoration of the same size
                // of the input field.
                decoration: InputDecoration.collapsed(hintText: 'Type something...', hintStyle: TextStyle(color: Colors.grey)),
                // FocusNode look above.
                focusNode: focusNode,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => onSendMessage(textController.text, 'text'),
              ),
            ),
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

}