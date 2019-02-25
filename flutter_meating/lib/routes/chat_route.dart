import 'package:flutter/material.dart';

class ChatRoute extends StatelessWidget {

  final String recipientId;

  ChatRoute({this.recipientId});

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
      ),
    );
  }

}

class ChatScreen extends StatefulWidget {

  final String recipientId;

  ChatScreen({this.recipientId});

  @override
  State<StatefulWidget> createState() => _ChatScreenState(recipientId: recipientId);

}

class _ChatScreenState extends State<ChatScreen> {

  String recipientId;

  _ChatScreenState({this.recipientId});

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
    return Container();
  }

  Widget buildInput() {
    return Container();
  }

}