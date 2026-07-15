import 'package:flutter/material.dart';

class EmojiPickerSheet extends StatelessWidget {
  final Function(String emoji) onEmojiSelected;

  const EmojiPickerSheet({super.key, required this.onEmojiSelected});

  static const Map<String, List<String>> emojiCategories = {
    'Produce 🥦': [
      '🍎', '🍏', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐', '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍐', '🍅', '🍆', '🥑', '🥦', '🥬', '🥒', '🫑', '🌶️', '🌽', '🥕', '🧄', '🧅', '🥔', '🍠', '🍄', '🥜', '🫘', '🌰'
    ],
    'Bakery & Grains 🍞': [
      '🍞', '🥐', '🥖', '🫓', '🥨', '🥯', '🥞', '🧇', '🍚', '🍝', '🍜', '🥣', '🥟', '🥡', '🍱', '🌾'
    ],
    'Dairy & Eggs 🥛': [
      '🥛', '🍼', '🧀', '🥚', '🧈', '🍦', '🍧', '🍨', '🧊'
    ],
    'Meat & Seafood 🥩': [
      '🥩', '🍖', '🍗', '🥓', '🍔', '🌭', '🍕', '🥪', '🌮', '🌯', '🍤', '🍣', '🐟', '🐙', '🦑', '🦀', '🦞', '🦐'
    ],
    'Drinks & Sweets ☕': [
      '☕', '🍵', '🥤', '🧃', '🧋', '🍺', '🍻', '🍷', '🥂', '🥃', '🍹', '🍸', '🧉', '🍾', '🍿', '🍩', '🍪', '🎂', '🍰', '🧁', '🥧', '🍫', '🍬', '🍭', '🍮', '🍯'
    ],
    'Household & Pharmacy 🧼': [
      '🧼', '🧽', '🧴', '🪥', '🧻', '🕯️', '⚡', '💧', '🗑️', '🛒', '🛍️', '📦', '🔥', '✨', '🩹', '💊', '💉', '🔑', '🔒', '🔋', '🔌', '🔨', '🔧', '✂️', '🖊️', '📓', '✉️'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Emoji 🎨",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: emojiCategories.length,
              itemBuilder: (context, index) {
                final category = emojiCategories.keys.elementAt(index);
                final emojis = emojiCategories[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: emojis.map((emoji) {
                        return GestureDetector(
                          onTap: () {
                            onEmojiSelected(emoji);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: ShapeDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
