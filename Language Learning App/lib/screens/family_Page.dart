import 'package:app/Components/Numbers_Rows.dart';
import 'package:app/Models/Numbers.dart';
import 'package:flutter/material.dart';

class FamilyPage extends StatelessWidget {
  List<itemModel> familyMembers = [
    itemModel(
      secondWord: 'Father',
      firstWord: 'Chichioya',
      image: 'assets/images/family_members/family_father.png',
      audio: 'sounds/family_members/father.wav',
    ),
    itemModel(
        secondWord: 'Daughter',
        firstWord: 'Musume',
        image: 'assets/images/family_members/family_daughter.png',
        audio: 'sounds/family_members/daughter.wav'),
    itemModel(
      secondWord: 'Grand Father',
      firstWord: 'ojiisan',
      image: 'assets/images/family_members/family_grandfather.png',
      audio: 'sounds/family_members/grand father.wav',
    ),
    itemModel(
      secondWord: 'Mother',
      firstWord: 'Hahaoya',
      image: 'assets/images/family_members/family_mother.png',
      audio: 'sounds/family_members/mother.wav',
    ),
    itemModel(
      secondWord: 'Grand Mother',
      firstWord: 'obāsan',
      image: 'assets/images/family_members/family_grandmother.png',
      audio: 'sounds/family_members/grand mother.wav',
    ),
    itemModel(
      secondWord: 'Older Brother',
      firstWord: 'ani',
      image: 'assets/images/family_members/family_older_brother.png',
      audio: 'sounds/family_members/older_bother.wav',
    ),
    itemModel(
      secondWord: 'Older Sister',
      firstWord: 'ane',
      image: 'assets/images/family_members/family_older_sister.png',
      audio: 'sounds/family_members/older sister.wav',
    ),
    itemModel(
      secondWord: 'Son',
      firstWord: 'musuko',
      image: 'assets/images/family_members/family_son.png',
      audio: 'sounds/family_members/son.wav',
    ),
    itemModel(
      secondWord: 'Younger brother',
      firstWord: 'otōto',
      image: 'assets/images/family_members/family_younger_brother.png',
      audio: 'sounds/family_members/younger_brohter.wav',
    ),
    itemModel(
      secondWord: 'Younger Sister',
      firstWord: 'imōto',
      image: 'assets/images/family_members/family_younger_sister.png',
      audio: 'sounds/family_members/younger sister.wav',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Members',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        itemCount: familyMembers.length,
        itemBuilder: (context, index) {
          return NumbersRows(
            familyMembers[index],
            Colors.green,Color(0xfffff6dc),true
          );
        },
      ),
    );
  }
}
