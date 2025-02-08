import 'package:flutter/material.dart';

class ColorModel {
  final String audio;
  final Color color;
  const ColorModel({required this.audio, required this.color});
}

// List<ContainerItem> itemGenerator(List <ColorModel> itemModels) {
//     List<ContainerItem> emptyList = [];
//     for (var item in itemModels) {
//       emptyList.add(ContainerItem(model:item));
//     }
//     return emptyList;
//   }