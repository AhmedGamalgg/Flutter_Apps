class itemModel {
  final String firstWord;
  final String secondWord;
  final String? image;
  final String audio;

  itemModel(
      {required this.firstWord,
      required this.secondWord,
      this.image,
      required this.audio});
}
