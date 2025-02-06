import 'package:app/Components/Numbers_Rows.dart';
import 'package:app/Models/Numbers.dart';
import 'package:flutter/material.dart';

class ColorsPage extends StatelessWidget {
  List<itemModel> colorItems = [
    itemModel(
      secondWord: 'Black',
      firstWord: 'Kuro',
      image: 'assets/images/colors/color_black.png',
      audio: 'sounds/colors/black.wav',
    ),
    itemModel(
        secondWord: 'Brown',
        firstWord: 'Chairo',
        image: 'assets/images/colors/color_brown.png',
        audio: 'sounds/colors/brown.wav'),
    itemModel(
      secondWord: 'Dusty Yellow',
      firstWord: 'Kona iro no kiiro',
      image: 'assets/images/colors/color_dusty_yellow.png',
      audio: 'sounds/colors/dusty yellow.wav',
    ),
    itemModel(
      secondWord: 'Gray',
      firstWord: 'Haiiro',
      image: 'assets/images/colors/color_gray.png',
      audio: 'sounds/colors/gray.wav',
    ),
    itemModel(
      secondWord: 'Green',
      firstWord: 'Midori',
      image: 'assets/images/colors/color_green.png',
      audio: 'sounds/colors/green.wav',
    ),
    itemModel(
      secondWord: 'Red',
      firstWord: 'aka',
      image: 'assets/images/colors/color_red.png',
      audio: 'sounds/colors/red.wav',
    ),
    itemModel(
      secondWord: 'White',
      firstWord: 'shiro',
      image: 'assets/images/colors/color_white.png',
      audio: 'sounds/colors/white.wav',
    ),
    itemModel(
      secondWord: 'Yellow',
      firstWord: 'Kiiro',
      image: 'assets/images/colors/yellow.png',
      audio: 'sounds/colors/yellow.wav',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Colors',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: colorItems.length,
        itemBuilder: (context, index) {
          return NumbersRows(colorItems[index], Colors.purple, Colors.purple, true);
        },
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
}
