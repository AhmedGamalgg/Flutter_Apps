import 'package:app/Models/category_model.dart';
import 'package:app/Widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoryListview extends StatelessWidget {
  List<CategoryModel> itemList;
  CategoryListview({
    super.key,
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          itemList[index].onPress = () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => itemList[index].page(),
              ),
            );
          };
          return CategoryItem(item: itemList[index]);
        },
      ),
    );
  }
}
