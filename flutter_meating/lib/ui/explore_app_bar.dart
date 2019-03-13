import 'package:flutter/material.dart';




class ExploreAppBar extends StatelessWidget {

  final String title = "Find your city";
  final double barHeight = 90.0;
  final VoidCallback onTap;

  ExploreAppBar({this.onTap});


  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight + 20.0, left: 20.0, right: 20.0, bottom: 20.0),
      height: barHeight + statusBarHeight,
      width: double.infinity,
      color: Colors.transparent,
      child: MaterialButton(
        elevation: 4.0,
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            Container(width: 20.0,),
            Text(title)
          ],
        ),
        color: Colors.white,
        onPressed: onTap,
      ),
    );
  }
}