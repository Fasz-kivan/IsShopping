import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).colorScheme.primary);
    initializeShoppingList();
  }

  Widget shoppingItemTemplate(BuildContext context, ShoppingItem shoppingItem) {
    String formattedDate = DateFormat.MMMEd().format(shoppingItem.addedAt);

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
              margin: const EdgeInsets.fromLTRB(15, 15 / 2, 15, 15 / 2),
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
                    child: Transform.translate(
                      offset: const Offset(0, 4),
                      child: Center(
                        child: Text(
                          shoppingItem.emoji,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
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
                            child: Text(
                              "Added: $formattedDate",
                              style: const TextStyle(
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
    String username = "Naara";
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Morning';
      }
      if (hour < 17) {
        return 'Afternoon';
      }
      return 'Evening';
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: IconButton(
                icon: const Icon(Icons.checklist),
                onPressed: () => setState(() {
                  bool flipValue;
                  if (shoppingList
                      .every((element) => element.isChecked == true)) {
                    flipValue = false;
                  } else {
                    flipValue = true;
                  }

                  for (var item in shoppingList) {
                    item.isChecked = flipValue;
                    storeShoppingItems(shoppingList);
                  }
                }),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () => setState(() {
                  shoppingList
                      .removeWhere((element) => element.isChecked == true);
                  storeShoppingItems(shoppingList);
                }),
                iconSize: 24,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 2,
          child: const Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              showAddDialog();
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            height: double.infinity,
            width: double.infinity,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 55),
                child: Text(
                  "Good ${greeting()}, $username",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            top: 150, // Adjust the top padding as needed
            child: Container(
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.background,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    const Text(
                      'Shopping List',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                        height:
                            10), // Add spacing between the text and shopping items
                    ...shoppingList
                        .map((shoppingItem) =>
                            shoppingItemTemplate(context, shoppingItem))
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                style: const ButtonStyle(),
                onPressed: () {
                  setState(() {
                    if (controller.text.isNotEmpty) {
                      addItemToList(
                        ShoppingItem(
                            itemName: controller.text,
                            emoji: '',
                            addedAt: DateTime.now(),
                            count: 1),
                      );
                      controller.text = '';
                    } else {
                      Navigator.of(context).pop();
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
      emojiFound = emojiRegex.firstMatch(item.itemName).toString();

      return ShoppingItem(
          itemName: item.itemName
              .replaceAll(emojiRegex, '')
              .trim()
              .replaceAll(RegExp(' {2,}'), ' '),
          emoji: emojiFound,
          addedAt: item.addedAt);
    }

    EmojiDictionaryEng().dictionary.forEach((key, value) {
      if (item.itemName.toLowerCase().contains(key)) {
        emojiFound = value;
      }
    });

    return ShoppingItem(
        itemName: item.itemName.replaceAll(RegExp(' {2,}'), ' '),
        emoji: emojiFound == '' ? '🛒' : emojiFound,
        addedAt: item.addedAt);
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
    final selectedOption = await showMenu(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                      if (controller.text.isNotEmpty) {
                        item = updateItem(item, editedText);
                        controller.text = '';

                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          content: const Text("Item name unchanged",
                              style: TextStyle(
                                  fontFamily: "Manrope",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900)),
                        ));
                      }
                    });
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
    item.emoji = checkItemForEmoji((ShoppingItem(
            itemName: editedText, emoji: '', addedAt: item.addedAt)))
        .emoji;
    item.itemName = editedText;

    return item;
  }
}
