

class CategoryModel {
  final String name;
  final String image;
  Function()? onPress;
  Function page;
  CategoryModel({required this.name, required this.image, this.onPress, required this.page});
}