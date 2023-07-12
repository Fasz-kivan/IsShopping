import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:is_shopping/emoji_dictionary_eng.dart';
import 'package:is_shopping/shopping_item.dart';
import 'package:is_shopping/item_storage.dart';
import 'package:is_shopping/user_storage.dart';

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
              onError: Color.fromARGB(255, 255, 116, 116),
              background: Color(0xffF6FBF4),
              onBackground: Color(0xffF3F3F3),
              surface: Color(0xFFF5DF99),
              onSurface: Color(0xFF404040))),
    ));

class MainScreenDisplayer extends StatefulWidget {
  const MainScreenDisplayer({super.key});

  @override
  MainScreen createState() => MainScreen();
}

class MainScreen extends State<MainScreenDisplayer> {
  List<ShoppingItem> shoppingList = [];
  String username = "";

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
    initShoppingList();
    initUsername();
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
              margin: const EdgeInsets.fromLTRB(10, 15 / 2, 10, 15 / 2),
              decoration: ShapeDecoration(
                color: shoppingItem.isChecked
                    ? Theme.of(context).colorScheme.onBackground
                    : Colors.white,
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
                              fontWeight: shoppingItem.isChecked
                                  ? FontWeight.w200
                                  : FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "Added: $formattedDate",
                              style: TextStyle(
                                color: const Color(0xFF808080),
                                fontSize: 12,
                                decoration: shoppingItem.isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontFamily: 'Manrope',
                                fontWeight: shoppingItem.isChecked
                                    ? FontWeight.w200
                                    : FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              shoppingItem.count == null
                                  ? ''
                                  : '${shoppingItem.count} pcs',
                              style: TextStyle(
                                color: const Color(0xFF808080),
                                fontSize: 12,
                                decoration: shoppingItem.isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontFamily: 'Manrope',
                                fontWeight: shoppingItem.isChecked
                                    ? FontWeight.w200
                                    : FontWeight.w700,
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
    String greeting() {
      var hour = DateTime.now().hour;
      if (username == '') {
        return 'Double tap here to set your username!';
      }
      if (hour < 12) {
        return 'Good Morning, ';
      }
      if (hour < 17) {
        return 'Good Afternoon, ';
      }
      return 'Good Evening, ';
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: BottomAppBar(
        height: 50,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
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
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: MediaQuery.of(context).viewPadding.top,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onDoubleTap: () {
                        setUsernameDialog();
                        storeUsername(username);
                      },
                      child: Text(
                        "${greeting()}$username",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
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
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 20),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Shopping List',
                                style: TextStyle(
                                  color: Color(0xFF1E1E1E),
                                  fontSize: 23,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                shoppingList.isEmpty
                                    ? 'Time to add some items! 🛒'
                                    : 'Tap and hold and item in the list to edit or delete it',
                                style: const TextStyle(
                                  color: Color(0xFFBFBFBF),
                                  fontSize: 12,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...shoppingList
                              .map((shoppingItem) =>
                                  shoppingItemTemplate(context, shoppingItem))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextEditingController itemcontroller = TextEditingController();
  TextEditingController qtycontroller = TextEditingController();
  Future showAddDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: Text("✅ Add new item",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.onSurface,
                      hintText: "Item name 🛒",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  controller: itemcontroller,
                  style: const TextStyle(fontFamily: "Manrope"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: "Quantiy 💯",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  controller: qtycontroller,
                  style: const TextStyle(fontFamily: "Manrope"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.secondary),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        textStyle: const MaterialStatePropertyAll(TextStyle(
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w900,
                            fontSize: 15)),
                        minimumSize:
                            const MaterialStatePropertyAll(Size(110, 50))),
                    onPressed: () {
                      itemcontroller.text = '';
                      qtycontroller.text = '';
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width < 350 ? 5 : 20),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        textStyle: const MaterialStatePropertyAll(TextStyle(
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w900,
                            fontSize: 15)),
                        minimumSize:
                            const MaterialStatePropertyAll(Size(110, 50))),
                    onPressed: () {
                      setState(() {
                        if (itemcontroller.text.isNotEmpty) {
                          addItemToList(
                            ShoppingItem(
                              itemName: itemcontroller.text,
                              emoji: '',
                              addedAt: DateTime.now(),
                              count: int.tryParse(qtycontroller.text),
                            ),
                          );
                          itemcontroller.text = '';
                          qtycontroller.text = '';
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Item name can't be empty ❌",
                                style: TextStyle(fontFamily: "Manrope"),
                              ),
                            ),
                          );
                        }
                      });
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  void addItemToList(ShoppingItem item) {
    item = checkItemForEmoji(item);
    shoppingList.add(item);
    storeShoppingItems(shoppingList);
  }

  ShoppingItem checkItemForEmoji(ShoppingItem item) {
    var emojiFound = '';

    if (item.itemName.contains(emojiRegex)) {
      for (var match in emojiRegex.allMatches(item.itemName)) {
        emojiFound = match.group(0).toString();
      } //TODO - unlock limitation of 1 emoji in a cleaner way

      return ShoppingItem(
          itemName: item.itemName
              .replaceAll(emojiRegex, '')
              .trim()
              .replaceAll(RegExp(' {2,}'), ' '),
          emoji: emojiFound,
          addedAt: item.addedAt,
          count: item.count);
    }

    EmojiDictionaryEng().dictionary.forEach((key, value) {
      if (item.itemName.toLowerCase().contains(key)) {
        emojiFound = value;
      }
    });

    return ShoppingItem(
        itemName: item.itemName.replaceAll(RegExp(' {2,}'), ' '),
        emoji: emojiFound == '' ? '🛒' : emojiFound,
        addedAt: item.addedAt,
        count: item.count);
  }

  void setItemToChecked(ShoppingItem item) {
    setState(() {
      item.isChecked = !item.isChecked;
    });
    storeShoppingItems(shoppingList);
  }

  Future<void> initShoppingList() async {
    List<ShoppingItem> retrievedItems = await retrieveShoppingItems();
    setState(() {
      shoppingList = retrievedItems;
    });
  }

  Future<void> initUsername() async {
    String retrievedUsername = await retrieveUsername();
    setState(() {
      username = retrievedUsername;
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

  TextEditingController updatecontroller = TextEditingController();
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
                controller: updatecontroller,
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
                      if (updatecontroller.text.isNotEmpty) {
                        item = updateItem(item, editedText);
                        updatecontroller.text = '';

                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          content: const Text("Item name unchanged ❌",
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
            itemName: editedText,
            emoji: '',
            addedAt: item.addedAt,
            count: item.count)))
        .emoji;
    item.itemName = editedText;

    return item;
  }

  TextEditingController usernamecontroller = TextEditingController();
  void setUsernameDialog() {
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
              title: const Text('Edit Username 🤔'),
              content: TextField(
                controller: usernamecontroller,
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
                      if (usernamecontroller.text.isNotEmpty) {
                        username = editedText;
                        usernamecontroller.text = '';
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          content: const Text("Username unchanged ❌",
                              style: TextStyle(
                                  fontFamily: "Manrope",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900)),
                        ));
                      }
                    });
                    storeUsername(username);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
