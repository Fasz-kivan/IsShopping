import 'package:flutter/material.dart';

class EditUsernameDialog extends StatefulWidget {
  final String initialUsername;
  final Function(String username) onSave;

  const EditUsernameDialog({
    super.key,
    required this.initialUsername,
    required this.onSave,
  });

  @override
  State<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  late final TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.initialUsername);
  }

  @override
  void dispose() {
    usernameController.dispose();
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
        child: Text("✏️ Edit username",
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
                  hintText: "Username 🤔",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              controller: usernameController,
              style: const TextStyle(fontFamily: "Manrope"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  usernameController.text = '';
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
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
                  if (usernameController.text.isNotEmpty) {
                    widget.onSave(usernameController.text);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Username can't be empty ❌",
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
    );
  }
}
