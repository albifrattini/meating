import 'package:flutter/material.dart';

class CityFilteringScreen extends StatefulWidget {

  @override
  createState() => _CityFilteringScreenState();
}

class _CityFilteringScreenState extends State<CityFilteringScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(icon: Icon(Icons.clear), onPressed: () => Navigator.pop(context, "ciao")),
    );
  }

}