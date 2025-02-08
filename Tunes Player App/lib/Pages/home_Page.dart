import 'package:app/Components/container_item.dart';
import 'package:app/Models/color_Model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<ColorModel> itemModels = const [
    ColorModel(audio: 'note1.wav', color: Colors.red),
    ColorModel(audio: 'note2.wav', color: Colors.orange),
    ColorModel(audio: 'note3.wav', color: Colors.yellow),
    ColorModel(audio: 'note4.wav', color: Colors.lightGreen),
    ColorModel(audio: 'note5.wav', color: Colors.green),
    ColorModel(audio: 'note6.wav', color: Colors.blue),
    ColorModel(audio: 'note7.wav', color: Colors.purple),
  ];
  // final List<ContainerItem> items = [
  //   ContainerItem(audio: 'note1.wav', color: Colors.black),
  //   ContainerItem(audio: 'note1.wav', color: Colors.red),
  //   ContainerItem(audio: 'note1.wav', color: Colors.yellow),
  //   ContainerItem(audio: 'note1.wav', color: Colors.black),
  //   ContainerItem(audio: 'note1.wav', color: Colors.amber),
  //   ContainerItem(audio: 'note1.wav', color: Colors.black),
  //   ContainerItem(audio: 'note1.wav', color: Colors.purple),
  //   ContainerItem(audio: 'note1.wav', color: Colors.black)
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 54, 70, 78),
          title: Text(
            'Flutter Tune',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
            children: itemModels
                .map(
                  (e) => ContainerItem(
                    model: e,
                  ),
                )
                .toList()));
  }
}
