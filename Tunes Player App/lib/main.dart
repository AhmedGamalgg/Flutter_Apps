
import 'package:app/Pages/home_Page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TuneApp());
}

class TuneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
