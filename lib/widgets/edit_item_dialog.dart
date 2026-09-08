import 'package:flutter/material.dart';
import 'package:is_shopping/utils/emoji_helper.dart';
import 'package:is_shopping/widgets/emoji_picker_sheet.dart';

class EditItemDialog extends StatefulWidget {
  final String initialName;
  final String? initialQuantity;
  final String initialEmoji;
  final Function(String itemName, String quantity, String emoji) onSave;

  const EditItemDialog({
    super.key,
    required this.initialName,
    required this.initialQuantity,
    required this.initialEmoji,
    required this.onSave,
  });

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController itemController;
  late final TextEditingController qtyController;
  late String selectedEmoji;
  bool isManuallySelected = false;

  @override
  void initState() {
    super.initState();
    itemController = TextEditingController(text: widget.initialName);
    qtyController = TextEditingController(text: widget.initialQuantity ?? '');
    selectedEmoji = widget.initialEmoji;
    itemController.addListener(_onItemNameChanged);
  }

  void _onItemNameChanged() {
    if (itemController.text.isEmpty) {
      setState(() {
        selectedEmoji = '🛒';
        isManuallySelected = false;
      });
    } else if (!isManuallySelected) {
      setState(() {
        selectedEmoji = detectEmoji(itemController.text);
      });
    }
  }

  @override
  void dispose() {
    itemController.removeListener(_onItemNameChanged);
    itemController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 350 ? screenWidth - 40 : 310.0;

    return SizedBox(
      width: dialogWidth,
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 5, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("✏️ Edit item",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (context) => EmojiPickerSheet(
                      onEmojiSelected: (emoji) {
                        setState(() {
                          selectedEmoji = emoji;
                          isManuallySelected = true;
                        });
                      },
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, 2),
                    child: Center(
                      child: Text(
                        selectedEmoji,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.onSurface,
                    hintText: "Item name 🛒",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                controller: itemController,
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
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintText: "Quantiy 💯",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                controller: qtyController,
                style: const TextStyle(fontFamily: "Manrope"),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.secondary),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      textStyle: const WidgetStatePropertyAll(TextStyle(
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w900,
                          fontSize: 15)),
                      minimumSize: const WidgetStatePropertyAll(Size(110, 50))),
                  onPressed: () {
                    itemController.text = '';
                    qtyController.text = '';
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width < 350 ? 5 : 20),
                ElevatedButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      textStyle: const WidgetStatePropertyAll(TextStyle(
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w900,
                          fontSize: 15)),
                      minimumSize: const WidgetStatePropertyAll(Size(110, 50))),
                  onPressed: () {
                    if (itemController.text.isNotEmpty) {
                      widget.onSave(itemController.text, qtyController.text,
                          selectedEmoji);
                      itemController.text = '';
                      qtyController.text = '';
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
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
