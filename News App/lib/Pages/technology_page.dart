import 'package:app/Pages/Home_Page.dart';
import 'package:flutter/material.dart';

class TechnologyPage extends StatelessWidget {
  const TechnologyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(category: "technology");
  }
}
