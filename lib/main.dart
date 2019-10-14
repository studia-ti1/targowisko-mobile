import 'package:flutter/material.dart';

const _appName = "Targowisko";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      theme: ThemeData.dark().copyWith(),
      home: Container(),
    );
  }
}
