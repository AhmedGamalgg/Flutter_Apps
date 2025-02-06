import 'package:app/Components/Numbers_Rows.dart';
import 'package:app/Models/Numbers.dart';
import 'package:flutter/material.dart';

class PhrasesPage extends StatelessWidget {
  List<itemModel> numbers = [
    itemModel(
      secondWord: 'What is your name?',
      firstWord: 'O-namae wa nan desu ka?',
      audio: 'sounds/phrases/what_is_your_name.wav',
    ),
    itemModel(
        secondWord: 'How are you feeling?',
        firstWord: 'O-genki desu ka?',
        audio: 'sounds/phrases/how_are_you_feeling.wav'),
    itemModel(
      secondWord: 'Are you coming?',
      firstWord: 'Kimasu ka?',
      audio: 'sounds/phrases/are_you_coming.wav',
    ),
    itemModel(
      secondWord: 'I love anime',
      firstWord: 'Anime ga daisuki desu',
      audio: 'sounds/phrases/i_love_anime.wav',
    ),
    itemModel(
      secondWord: 'I love programming',
      firstWord: 'Puroguramingu ga daisuki desu',
      audio: 'sounds/phrases/i_love_programming.wav',
    ),
    itemModel(
      secondWord: 'Programming is easy',
      firstWord: 'Puroguramingu wa kantan desu',
      audio: 'sounds/phrases/programming_is_easy.wav',
    ),
    itemModel(
      secondWord: 'Where are you going?',
      firstWord: 'Doko ni ikimasu ka?',
      audio: 'sounds/phrases/where_are_you_going.wav',
    ),
    itemModel(
      secondWord: 'Yes I am coming',
      firstWord: 'Hai, watashi wa kimasu',
      audio: 'sounds/phrases/yes_im_coming.wav',
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
              numbers[index], Colors.cyan, Color(0xfffff6dc), false);
        },
      ),
      backgroundColor: Colors.cyan,
    );
  }
}
