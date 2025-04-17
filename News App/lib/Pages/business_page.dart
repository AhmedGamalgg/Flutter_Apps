import 'package:app/Pages/Home_Page.dart';
import 'package:flutter/material.dart';

class BusinessPage extends StatelessWidget {
  const BusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(
      category: "business",
    );
  }
}
