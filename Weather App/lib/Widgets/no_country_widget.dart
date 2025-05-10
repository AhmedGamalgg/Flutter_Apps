import 'package:flutter/material.dart';

class NoCountryWidget extends StatelessWidget {
  const NoCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "There is no weather 😞 Start",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          Text(
            'Searching now 🔍',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
