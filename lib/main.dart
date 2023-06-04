import 'package:flutter/material.dart';
import 'package:is_shopping/emoji_dictionary.dart';
import 'shopping_item.dart';

final myController = TextEditingController();

void main() => runApp(const MaterialApp(home: TextListDisplayer()));

class TextListDisplayer extends StatefulWidget {
  const TextListDisplayer({super.key});

  @override
  _TextListDisplayer createState() => _TextListDisplayer();
}

class _TextListDisplayer extends State<TextListDisplayer> {
  List<ShoppingItem> shoppingList = [
    ShoppingItem(itemName: "Milk", emoji: "🐄"),
    ShoppingItem(itemName: "Cheese", emoji: "🧀"),
    ShoppingItem(itemName: "Pizza", emoji: "🍕"),
  ];

  Widget shoppingItemTemplate(shoppingItem) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                  '${shoppingItem.itemName} ${shoppingItem.emoji}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.purple,
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("IsShopping"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: Column(
          children: shoppingList
              .map((shoppingItem) => shoppingItemTemplate(shoppingItem))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showAddDialog();
          });
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }

  TextEditingController controller = TextEditingController();
  Future showAddDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add new item ➕"),
          content: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
                hintText: "//TODO random item from past lists?"),
            controller: controller,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    if (controller.text.isNotEmpty) {
                      addItemToList(
                          ShoppingItem(itemName: controller.text, emoji: ''));
                      controller.text = '';
                    }
                  });
                },
                child: const Text("Add"))
          ],
        ),
      );

  void addItemToList(ShoppingItem item) {
    item.emoji = checkItemForEmoji(item);

    shoppingList.add(item);
    Navigator.of(context).pop();
  }

  String checkItemForEmoji(ShoppingItem item) {
    var emojiFound = '';
    var parser = EmojiParser();

    if (parser.getEmoji(item.itemName) != Emoji.None) {
      return parser.getEmoji(item.itemName).toString();
    }

    EmojiDictionary().dictionary.forEach((key, value) {
      if (item.itemName.toLowerCase().contains(key)) {
        emojiFound = value;
      }
    });

    return emojiFound;
  }
  }
}
