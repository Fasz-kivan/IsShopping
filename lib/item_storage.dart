import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'shopping_item.dart';

Future<void> storeShoppingItems(List<ShoppingItem> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<Map<String, dynamic>> serializedItems = items.map((item) {
    return {
      'itemName': item.itemName,
      'emoji': item.emoji,
      'isChecked': item.isChecked,
      'addedAt': item.addedAt.toString(),
      'count': item.count
    };
  }).toList();

  await prefs.setString('shoppingItems', jsonEncode(serializedItems));
}

Future<List<ShoppingItem>> retrieveShoppingItems() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? serializedItems = prefs.getString('shoppingItems');

  if (serializedItems != null) {
    List<dynamic> decodedItems = jsonDecode(serializedItems);

    List<ShoppingItem> items = decodedItems.map((item) {
      return ShoppingItem(
          itemName: item['itemName'],
          emoji: item['emoji'],
          isChecked: item['isChecked'],
          addedAt: DateTime.parse(item['addedAt']),
          count: item['count']);
    }).toList();

    return items;
  }

  return [];
}
