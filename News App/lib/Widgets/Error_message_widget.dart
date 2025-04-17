import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Oops, There was an error :( Please,try again later!',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
