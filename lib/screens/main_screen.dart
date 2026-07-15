import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:is_shopping/database/emoji_database.dart';
import 'package:is_shopping/item_storage.dart';
import 'package:is_shopping/shopping_item.dart';
import 'package:is_shopping/user_storage.dart';
import 'package:is_shopping/utils/dialog_helper.dart';
import 'package:is_shopping/utils/emoji_helper.dart';
import 'package:is_shopping/widgets/add_item_dialog.dart';
import 'package:is_shopping/widgets/edit_item_dialog.dart';
import 'package:is_shopping/widgets/edit_username_dialog.dart';
import 'package:is_shopping/widgets/shopping_item_tile.dart';

class MainScreenDisplayer extends StatefulWidget {
  const MainScreenDisplayer({super.key});

  @override
  MainScreen createState() => MainScreen();
}

class MainScreen extends State<MainScreenDisplayer> {
  List<ShoppingItem> shoppingList = [];
  String username = "";
  bool _isLoaded = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Offset _longPressPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    initShoppingList();
    initUsername();

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        FlutterDisplayMode.setHighRefreshRate();
      }
    }
  }

  Widget shoppingItemTemplate(BuildContext context, ShoppingItem shoppingItem,
      Animation<double> animation) {
    return ShoppingItemTile(
      shoppingItem: shoppingItem,
      animation: animation,
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
    );
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
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
                onPressed: () {
                  setState(() {
                    for (int i = shoppingList.length - 1; i >= 0; i--) {
                      if (shoppingList[i].isChecked) {
                        final removedItem = shoppingList[i];
                        shoppingList.removeAt(i);
                        _listKey.currentState?.removeItem(
                          i,
                          (context, animation) => shoppingItemTemplate(
                              context, removedItem, animation),
                          duration: const Duration(milliseconds: 200),
                        );
                      }
                    }
                    storeShoppingItems(shoppingList);
                  });
                },
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
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
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
                                child: Text(
                                  'Shopping List',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                            if (!_isLoaded)
                              const Center(child: CircularProgressIndicator())
                            else
                              AnimatedList(
                                key: _listKey,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                initialItemCount: shoppingList.length,
                                itemBuilder: (context, index, animation) {
                                  return shoppingItemTemplate(
                                      context, shoppingList[index], animation);
                                },
                              ),
                          ],
                        ),
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

  void showAddDialog() {
    showAnimatedDialog(
      context,
      AddItemDialog(
        onAdd: (itemName, quantity, emoji) {
          addItemToList(
            ShoppingItem(
              itemName: itemName,
              emoji: emoji,
              addedAt: DateTime.now(),
              quantity: quantity,
            ),
          );
        },
      ),
    );
  }

  void addItemToList(ShoppingItem item) {
    setState(() {
      item = checkItemForEmoji(item);
      shoppingList.add(item);
    });
    _listKey.currentState?.insertItem(
      shoppingList.length - 1,
      duration: const Duration(milliseconds: 200),
    );
    storeShoppingItems(shoppingList);
  }

  void setItemToChecked(ShoppingItem item) {
    setState(() {
      item.isChecked = !item.isChecked;
    });
    storeShoppingItems(shoppingList);
  }

  Future<void> initShoppingList() async {
    await EmojiDatabase.init();
    List<ShoppingItem> retrievedItems = await retrieveShoppingItems();
    setState(() {
      shoppingList = retrievedItems;
      _isLoaded = true;
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

    if (!context.mounted) return;

    if (selectedOption == 'edit') {
      showAnimatedDialog(
        context,
        EditItemDialog(
          initialName: shoppingItem.itemName,
          initialQuantity: shoppingItem.quantity,
          initialEmoji: shoppingItem.emoji,
          onSave: (newName, newQuantity, newEmoji) {
            setState(() {
              ShoppingItem updatedItem = checkItemForEmoji(ShoppingItem(
                  itemName: newName,
                  emoji: newEmoji,
                  addedAt: shoppingItem.addedAt,
                  quantity: shoppingItem.quantity));

              shoppingItem.itemName = updatedItem.itemName;
              shoppingItem.quantity = newName.isEmpty ? null : newQuantity;
              shoppingItem.emoji = updatedItem.emoji;
            });
            storeShoppingItems(shoppingList);
          },
        ),
      );
    } else if (selectedOption == 'delete') {
      final index = shoppingList.indexOf(shoppingItem);
      if (index != -1) {
        setState(() {
          shoppingList.removeAt(index);
        });
        _listKey.currentState?.removeItem(
          index,
          (context, animation) =>
              shoppingItemTemplate(context, shoppingItem, animation),
          duration: const Duration(milliseconds: 200),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Item Deleted 💥",
            ),
          ),
        );
        storeShoppingItems(shoppingList);
      }
    }
  }

  void setUsernameDialog() {
    showAnimatedDialog(
      context,
      EditUsernameDialog(
        initialUsername: username,
        onSave: (newUsername) {
          setState(() {
            username = newUsername;
          });
          storeUsername(username);
        },
      ),
    );
  }
}
