import 'package:app/Pages/Home_Page.dart';
import 'package:flutter/material.dart';

class SciencePage extends StatelessWidget {
  const SciencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(category: "science");
  }
}