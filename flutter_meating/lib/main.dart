import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/root_route.dart';
import 'package:flutter_meating/utils/authentication.dart';

void main() {
  runApp(
    new MaterialApp(
      home: new RootRoute(auth: new Authentication())
    )
  );
}