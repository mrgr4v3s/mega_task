import 'package:flutter/material.dart';
import 'package:mega_task/ui/home_page.dart';
import 'package:mega_task/ui/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}