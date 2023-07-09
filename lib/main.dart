import 'package:flutter/material.dart';
import 'package:is_shopping/emoji_dictionary_eng.dart';
import 'package:is_shopping/shopping_item.dart';
import 'package:is_shopping/item_storage.dart';

final myController = TextEditingController();

void main() => runApp(MaterialApp(
      home: const MainScreenDisplayer(),
      theme: ThemeData(
          fontFamily: 'Segoe UI',
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xff5fd068),
              onPrimary: Color(0xff4B8673),
              secondary: Color(0xffFD5D6A),
              onSecondary: Color(0xff7F8FF5),
              error: Color.fromARGB(255, 255, 0, 0),
              onError: Color.fromARGB(255, 255, 0, 0),
              background: Color(0xffF6FBF4),
              onBackground: Color(0xffF3F3F3),
              surface: Color.fromARGB(255, 255, 0, 0),
              onSurface: Color.fromARGB(255, 255, 0, 0))),
    ));

class MainScreenDisplayer extends StatefulWidget {
  const MainScreenDisplayer({super.key});

  @override
  MainScreen createState() => MainScreen();
}

class MainScreen extends State<MainScreenDisplayer> {
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

  Widget shoppingItemTemplate(BuildContext context, ShoppingItem shoppingItem) {
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
          child: Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        shoppingItem.emoji,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shoppingItem.itemName,
                            style: TextStyle(
                              color: const Color(0xFF1E1E1E),
                              decoration: shoppingItem.isChecked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontFamily: "Manrope",
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: const Text(
                              'Added: 2036. Aug. 12.',
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 12,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 3),
                            child: const Text(
                              '3 pcs',
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 12,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.50, color: Color(0xFF1E1E1E)),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return BorderSide(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary);
                            }
                            return const BorderSide(
                                width: 1, color: Colors.black);
                          },
                        ),
                        value: shoppingItem.isChecked,
                        onChanged: (value) => setItemToChecked(shoppingItem)),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "IsShopping",
          style: TextStyle(
              fontFamily: "Manrope",
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              color: Colors.black,
              icon: const Icon(Icons.delete_forever),
              onPressed: () => setState(() {
                    shoppingList
                        .removeWhere((element) => element.isChecked == true);
                    storeShoppingItems(shoppingList);
                  })),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: shoppingList
              .map(
                  (shoppingItem) => shoppingItemTemplate(context, shoppingItem))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showAddDialog();
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }

  TextEditingController controller = TextEditingController();
  Future showAddDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("✅ Add new item"),
          content: TextFormField(
              autofocus: true,
              decoration: const InputDecoration(hintText: "Do Shopping 🛒"),
              controller: controller,
              style: const TextStyle(fontFamily: "Manrope")),
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
                        content: Text("Item name can't be empty",
                            style: TextStyle(fontFamily: "Manrope")),
                      ));
                    }
                  });
                },
                child:
                    const Text("Add", style: TextStyle(fontFamily: "Manrope")))
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
    storeShoppingItems(shoppingList);
  }

  Future<void> initializeShoppingList() async {
    List<ShoppingItem> retrievedItems = await retrieveShoppingItems();
    setState(() {
      shoppingList = retrievedItems;
    });
  }

  void _showContextMenu(BuildContext context, ShoppingItem shoppingItem) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Size overlaySize = overlay.size;
    final Offset topLeft = overlay.localToGlobal(Offset.zero);
    final Offset bottomRight =
        topLeft + Offset(overlaySize.width, overlaySize.height);

    final double dx = _longPressPosition.dx.clamp(topLeft.dx, bottomRight.dx);
    final double dy = _longPressPosition.dy.clamp(topLeft.dy, bottomRight.dy);

    final double distanceToTopLeft = (_longPressPosition - topLeft).distance;
    final double distanceToTopRight = Offset(dx - bottomRight.dx, 0).distance;

    final List<double> distances = [
      distanceToTopLeft,
      distanceToTopRight,
    ];

    final int closestCornerIndex = distances.indexOf(distances
        .reduce((minValue, value) => minValue > value + 48 ? value : minValue));

    const Radius cMenuCorner = Radius.circular(15.0);

    final borderRadius = BorderRadius.only(
      topLeft: closestCornerIndex == 0 ? Radius.zero : cMenuCorner,
      topRight: closestCornerIndex == 1 ? Radius.zero : cMenuCorner,
      bottomLeft: cMenuCorner,
      bottomRight: cMenuCorner,
    );

    final selectedOption = await showMenu(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      context: context,
      position: RelativeRect.fromLTRB(
        dx,
        dy,
        bottomRight.dx - dx,
        bottomRight.dy - dy,
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

    if (selectedOption == 'edit') {
      updateItemDialog(shoppingItem);
    } else if (selectedOption == 'delete') {
      setState(() {
        shoppingList.remove(shoppingItem);
      });
      storeShoppingItems(shoppingList);
    }
  }

  void updateItemDialog(ShoppingItem item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String editedText = '';

        return Builder(
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Edit Item ✏️'),
              content: TextField(
                onChanged: (value) {
                  editedText = value;
                },
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontFamily: "Manrope"),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Save',
                    style: TextStyle(fontFamily: "Manrope"),
                  ),
                  onPressed: () {
                    setState(() {
                      item = updateItem(item, editedText);
                    });
                    Navigator.of(context).pop();
                    storeShoppingItems(shoppingList);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  ShoppingItem updateItem(ShoppingItem item, String editedText) {
    item.emoji =
        checkItemForEmoji((ShoppingItem(itemName: editedText, emoji: '')))
            .emoji;
    item.itemName = editedText;

    return item;
  }
}
