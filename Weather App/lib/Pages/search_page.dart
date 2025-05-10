import 'package:flutter/material.dart';
import 'package:myapp/Widgets/Search_TextField.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search City',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        child: Search_TextField(),
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 228, 228, 228)),
      ),
    );
  }
}
