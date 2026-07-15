// ignore_for_file: valid_regexps

import 'package:dart_emoji/dart_emoji.dart';
import 'package:is_shopping/database/emoji_database.dart';
import 'package:is_shopping/shopping_item.dart';

final RegExp emojiRegex = RegExp(
  r'(?:\p{Regional_Indicator}{2})|(?:\p{Emoji_Presentation}|\p{Emoji}\u{FE0F})(?:\u{200D}(?:\p{Emoji_Presentation}|\p{Emoji}\u{FE0F})|[\u{1F3FB}-\u{1F3FF}])*',
  unicode: true,
);

ShoppingItem checkItemForEmoji(ShoppingItem item) {
  var emojiFound = '';

  if (item.emoji != '🛒' && item.emoji != '') {
    emojiFound = item.emoji;
    if (item.itemName.isNotEmpty) {
      EmojiDatabase.savePairing(item.itemName.trim().toLowerCase(), emojiFound);
    }
  }

  if (item.itemName.contains(emojiRegex)) {
    for (var match in emojiRegex.allMatches(item.itemName)) {
      emojiFound = match.group(0).toString();
    }

    final cleanName = item.itemName
        .replaceAll(emojiRegex, '')
        .trim()
        .replaceAll(RegExp(' {2,}'), ' ');

    if (emojiFound.isNotEmpty && cleanName.isNotEmpty) {
      EmojiDatabase.savePairing(cleanName.toLowerCase(), emojiFound);
    }

    return ShoppingItem(
        itemName: cleanName,
        emoji: emojiFound,
        addedAt: item.addedAt,
        quantity: item.quantity);
  }

  // Look up emoji in the database
  // Custom pairings take absolute priority over seeded defaults
  String? foundCustom;
  EmojiDatabase.customPairings.forEach((key, value) {
    if (item.itemName.toLowerCase().contains(key)) {
      foundCustom = value;
    }
  });

  if (foundCustom != null) {
    emojiFound = foundCustom!;
  } else {
    String? foundSeeded;
    EmojiDatabase.seededDefaults.forEach((key, value) {
      if (item.itemName.toLowerCase().contains(key)) {
        foundSeeded = value;
      }
    });
    if (foundSeeded != null) {
      emojiFound = foundSeeded!;
    }
  }

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

String detectEmoji(String name) {
  var emojiFound = '';

  if (name.contains(emojiRegex)) {
    for (var match in emojiRegex.allMatches(name)) {
      emojiFound = match.group(0).toString();
    }
    return emojiFound;
  }

  String? foundCustom;
  EmojiDatabase.customPairings.forEach((key, value) {
    if (name.toLowerCase().contains(key)) {
      foundCustom = value;
    }
  });

  if (foundCustom != null) {
    return foundCustom!;
  }

  String? foundSeeded;
  EmojiDatabase.seededDefaults.forEach((key, value) {
    if (name.toLowerCase().contains(key)) {
      foundSeeded = value;
    }
  });
  if (foundSeeded != null) {
    return foundSeeded!;
  }

  var emoji = EmojiParser().info(name.toLowerCase()).code;
  if (emoji != '') {
    return emoji;
  }

  return '🛒';
}
