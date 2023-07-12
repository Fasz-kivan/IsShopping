class ShoppingItem {
  String itemName;
  String emoji;
  bool isChecked;
  DateTime addedAt;
  int? count;

  ShoppingItem(
      {required this.itemName,
      required this.emoji,
      this.isChecked = false,
      required this.addedAt,
      required this.count});
}
