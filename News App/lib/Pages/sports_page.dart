import 'package:app/Pages/Home_Page.dart';
import 'package:flutter/material.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(category: "sports");
  }
}