import 'package:app/Models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel item;
  const CategoryItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onPress,
      child: Container(
        width: 170,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(item.image),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken)),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
            child: Text(
          item.name,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
