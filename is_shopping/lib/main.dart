import 'package:flutter/material.dart';
import 'shopping_item.dart';

final myController = TextEditingController();

void main() => runApp(MaterialApp(home: TextListDisplayer()));

class TextListDisplayer extends StatefulWidget {
  @override
  _TextListDisplayer createState() => _TextListDisplayer();
}

class _TextListDisplayer extends State<TextListDisplayer> {
  List<ShoppingItem> shoppingList = [
    ShoppingItem(itemText: "Milk", emoji: "🐄"),
    ShoppingItem(itemText: "Cheese", emoji: "🧀"),
    ShoppingItem(itemText: "Pizza", emoji: "🍕"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("IsShopping"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: shoppingList
              .map((shoppingItem) => Text(
                    '${shoppingItem.itemText} ${shoppingItem.emoji}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 70,
                        color: Colors.deepPurple),
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            shoppingList.add(ShoppingItem(itemText: "Cum", emoji: "🤍"));
          });
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
