import 'package:app/Components/Numbers_Rows.dart';
import 'package:app/Models/Numbers.dart';
import 'package:flutter/material.dart';

class numbers_Page extends StatelessWidget {
  List<itemModel> numbers = [
    itemModel(
      secondWord: 'One',
      firstWord: 'Ichi',
      image: 'assets/images/numbers/number_one.png',
      audio: 'sounds/numbers/number_one_sound.mp3',
    ),
    itemModel(
        secondWord: 'Two',
        firstWord: 'Ni',
        image: 'assets/images/numbers/number_two.png',
        audio: 'sounds/numbers/number_two_sound.mp3'),
    itemModel(
      secondWord: 'Three',
      firstWord: 'San',
      image: 'assets/images/numbers/number_three.png',
      audio: 'sounds/numbers/number_three_sound.mp3',
    ),
    itemModel(
      secondWord: 'Four',
      firstWord: 'Shi',
      image: 'assets/images/numbers/number_four.png',
      audio: 'sounds/numbers/number_four_sound.mp3',
    ),
    itemModel(
      secondWord: 'Five',
      firstWord: 'Go',
      image: 'assets/images/numbers/number_five.png',
      audio: 'sounds/numbers/number_five_sound.mp3',
    ),
    itemModel(
      secondWord: 'Six',
      firstWord: 'Roku',
      image: 'assets/images/numbers/number_six.png',
      audio: 'sounds/numbers/number_six_sound.mp3',
    ),
    itemModel(
      secondWord: 'Seven',
      firstWord: 'Sebun',
      image: 'assets/images/numbers/number_seven.png',
      audio: 'sounds/numbers/number_seven_sound.mp3',
    ),
    itemModel(
      secondWord: 'Eight',
      firstWord: 'Hachi',
      image: 'assets/images/numbers/number_eight.png',
      audio: 'sounds/numbers/number_eight_sound.mp3',
    ),
    itemModel(
      secondWord: 'Nine',
      firstWord: 'Kyuu',
      image: 'assets/images/numbers/number_nine.png',
      audio: 'sounds/numbers/number_nine_sound.mp3',
    ),
    itemModel(
      secondWord: 'Ten',
      firstWord: 'Juu',
      image: 'assets/images/numbers/number_ten.png',
      audio: 'sounds/numbers/number_ten_sound.mp3',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Numbers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          return NumbersRows(
            numbers[index],
            Colors.orange,Color(0xfffff6dc),true
          );
        },
      ),
    );
  }
}
