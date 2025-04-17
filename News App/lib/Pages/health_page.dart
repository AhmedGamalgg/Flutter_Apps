import 'package:app/Pages/Home_Page.dart';
import 'package:flutter/material.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(category: "health");
  }
}