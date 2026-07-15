// ignore_for_file: valid_regexps

import 'package:dart_emoji/dart_emoji.dart';
import 'package:is_shopping/emoji_dictionary_eng.dart';
import 'package:is_shopping/shopping_item.dart';

final RegExp emojiRegex = RegExp(
  r'(?:\p{Regional_Indicator}{2})|(?:\p{Emoji_Presentation}|\p{Emoji}\u{FE0F})(?:\u{200D}(?:\p{Emoji_Presentation}|\p{Emoji}\u{FE0F})|[\u{1F3FB}-\u{1F3FF}])*',
  unicode: true,
);

ShoppingItem checkItemForEmoji(ShoppingItem item) {
  var emojiFound = '';

  if (item.emoji != '🛒' || item.emoji == '') {
    emojiFound = item.emoji;
  }

  if (item.itemName.contains(emojiRegex)) {
    for (var match in emojiRegex.allMatches(item.itemName)) {
      emojiFound = match.group(0).toString();
    }

    return ShoppingItem(
        itemName: item.itemName
            .replaceAll(emojiRegex, '')
            .trim()
            .replaceAll(RegExp(' {2,}'), ' '),
        emoji: emojiFound,
        addedAt: item.addedAt,
        quantity: item.quantity);
  }

  EmojiDictionaryEng().dictionary.forEach((key, value) {
    if (item.itemName.toLowerCase().contains(key)) {
      emojiFound = value;
    }
  });

  if (emojiFound == '') {
    var emoji = EmojiParser().info(item.itemName.toLowerCase()).code;
    emojiFound = emoji;
  }

  return ShoppingItem(
      itemName: item.itemName.replaceAll(RegExp(' {2,}'), ' '),
      emoji: emojiFound == '' ? '🛒' : emojiFound,
      addedAt: item.addedAt,
      quantity: item.quantity);
}
