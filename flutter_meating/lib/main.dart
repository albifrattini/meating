import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/root_route.dart';
import 'package:flutter_meating/utils/authentication.dart';

final ThemeData meatingTheme = ThemeData(
  primaryColor: Color(0xFFEE6C4D),
  canvasColor: Color(0xFFFBFEF9),
  buttonColor: Color(0xFFEE6C4D)
);



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(

    new MaterialApp(
      theme: meatingTheme,
      home: new RootRoute(auth: new Authentication())
    )
  );
}