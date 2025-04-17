import 'package:app/Pages/Home_Page.dart';
import 'package:flutter/material.dart';

class EntertainmentPage extends StatelessWidget {
  const EntertainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(category: "entertainment");
  }
}
