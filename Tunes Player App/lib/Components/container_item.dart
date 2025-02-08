import 'package:app/Models/color_Model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ContainerItem extends StatelessWidget {
  final ColorModel model;
  final player = AudioPlayer();
  ContainerItem({required this.model});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          player.play(AssetSource(model.audio));
        },
        child: Container(
          color: model.color,
        ),
      ),
    );
  }
}
