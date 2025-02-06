import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../Models/Numbers.dart';

class NumbersRows extends StatelessWidget {
  final itemModel number;
  final Color color;
  final Color imageColor;
  final bool hasimage;
  const NumbersRows(this.number, this.color, this.imageColor, this.hasimage);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 60,
      child: Row(
        children: [
          hasimage
              ? Container(
                  color: imageColor,
                  child: Image.asset(number.image!),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number.firstWord!,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  number.secondWord!,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                final player = AudioPlayer();
                player.play(AssetSource(number.audio));
              },
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
