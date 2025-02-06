import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  Category({required this.text, required this.color,this.onTap});
  String? text;
  Color? color;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        height: 65,
        width: double.infinity,
        color: color,
        child: Text(text!, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
