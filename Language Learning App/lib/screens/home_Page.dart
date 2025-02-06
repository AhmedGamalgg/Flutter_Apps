import 'package:app/Components/Category_item.dart';
import 'package:app/screens/colors_Page.dart';
import 'package:app/screens/family_Page.dart';
import 'package:app/screens/numbers_Page.dart';
import 'package:app/screens/phrases_Page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0XFFFEF6D8),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Toku'),
      ),
      body: Column(
        children: [
          Category(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => numbers_Page()));
            },
            text: 'Numbers',
            color: Colors.orange,
          ),
          Category(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FamilyPage()));
            },
            text: 'Family Members',
            color: Colors.green,
          ),
          Category(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ColorsPage()));
            },
            text: 'Colors',
            color: Colors.purple,
          ),
          Category(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PhrasesPage()));
            },
            text: 'Phrases',
            color: Colors.cyan,
          )
        ],
      ),
    );
  }
}
