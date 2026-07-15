import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  final Function(String itemName, String quantity) onAdd;

  const AddItemDialog({super.key, required this.onAdd});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  @override
  void dispose() {
    itemController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                    minimumSize:
                        const WidgetStatePropertyAll(Size(110, 50))),
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
                    minimumSize:
                        const WidgetStatePropertyAll(Size(110, 50))),
                onPressed: () {
                  if (itemController.text.isNotEmpty) {
                    widget.onAdd(itemController.text, qtyController.text);
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
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
