import 'package:flutter/material.dart';

class ChatRoute extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _ChatRouteState();

}

class _ChatRouteState extends State<ChatRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Chat", style: TextStyle(fontSize: 32.0),),
        elevation: 0.0,
      ),
    );
  }

}