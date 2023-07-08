import 'package:flutter/material.dart';
import 'package:is_shopping/emoji_dictionary_eng.dart';
import 'shopping_item.dart';
import 'item_storage.dart';

final myController = TextEditingController();

void main() => runApp(const MaterialApp(home: MainScreenDisplayer()));

class MainScreenDisplayer extends StatefulWidget {
  const MainScreenDisplayer({super.key});

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreenDisplayer> {
  List<ShoppingItem> shoppingList = [];

  Offset _longPressPosition = Offset.zero;

  static final RegExp emojiRegex = RegExp(
    r'[\u{1F300}-\u{1F5FF}' // Miscellaneous Symbols and Pictographs
    r'\u{1F600}-\u{1F64F}' // Emoticons
    r'\u{1F680}-\u{1F6FF}' // Transport and Map Symbols
    r'\u{2600}-\u{26FF}' // Miscellaneous Symbols
    r'\u{2700}-\u{27BF}' // Dingbats
    r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols and Pictographs
    r'\u{1F1E0}-\u{1F1FF}' // Flags (iOS)
    r']',
    unicode: true,
  );

  @override
  void initState() {
    super.initState();
    initializeShoppingList();
  }

  Widget shoppingItemTemplate(ShoppingItem shoppingItem) {
    return Listener(
        onPointerDown: (_) {},
        child: GestureDetector(
          onTap: () {
            setItemToChecked(shoppingItem);
          },
          onLongPress: () {
            _showContextMenu(context, shoppingItem);
          },
          onLongPressStart: (details) {
            setState(() {
              _longPressPosition = details.globalPosition;
            });
          },
          child: Card(
            elevation: shoppingItem.isChecked ? 2 : 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Checkbox(
                    value: shoppingItem.isChecked,
                    onChanged: (value) => setItemToChecked(shoppingItem),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        shoppingItem.itemName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: shoppingItem.isChecked
                              ? Colors.grey
                              : Colors.purple,
                          decoration: shoppingItem.isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    shoppingItem.emoji,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            decoration: const InputDecoration(hintText: "Do Shopping 🛒"),
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
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Item name can't be empty"),
                      ));
                    }
                  });
                },
                child: const Text("Add"))
          ],
        ),
      );

  void addItemToList(ShoppingItem item) {
    item = checkItemForEmoji(item);

    shoppingList.add(item);
    Navigator.of(context).pop();

    storeShoppingItems(shoppingList);
  }

  ShoppingItem checkItemForEmoji(ShoppingItem item) {
    var emojiFound = '';

    if (item.itemName.contains(emojiRegex)) {
      for (var match in emojiRegex.allMatches(item.itemName)) {
        emojiFound += match.group(0).toString();
      }

      return ShoppingItem(
          itemName: item.itemName
              .replaceAll(emojiRegex, '')
              .trim()
              .replaceAll(RegExp(' {2,}'), ' '),
          emoji: emojiFound);
    }

    EmojiDictionaryEng().dictionary.forEach((key, value) {
      if (item.itemName.toLowerCase().contains(key)) {
        emojiFound = value;
      }
    });

    return ShoppingItem(
        itemName: item.itemName.replaceAll(RegExp(' {2,}'), ' '),
        emoji: emojiFound == '' ? '🛒' : emojiFound);
  }

  void setItemToChecked(ShoppingItem item) {
    setState(() {
      item.isChecked = !item.isChecked;
    });
  }

  Future<void> initializeShoppingList() async {
    List<ShoppingItem> retrievedItems = await retrieveShoppingItems();
    setState(() {
      shoppingList = retrievedItems;
    });
  }
  void _showContextMenu(BuildContext context, ShoppingItem shoppingItem) async {
    final selectedOption = await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        _longPressPosition.dx,
        _longPressPosition.dy,
        MediaQuery.of(context).size.width - _longPressPosition.dx,
        MediaQuery.of(context).size.height - _longPressPosition.dy,
      ),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Text('✏️ Edit'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('🗑️ Delete'),
        ),
      ],
    );

    // Handle the selected option
    if (selectedOption == 'edit') {
      updateItemDialog(shoppingItem);
    } else if (selectedOption == 'delete') {
      setState(() {
        shoppingList.remove(shoppingItem);
      });
      storeShoppingItems(shoppingList);
    }
  }
}
