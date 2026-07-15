import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EmojiDatabase {
  static Map<String, String> _customPairings = {};

  static Map<String, String> get customPairings => _customPairings;

  // Seeded defaults (English & Hungarian cuz...im hungarian lol)
  static const Map<String, String> seededDefaults = {
    // English defaults
    'your mom': '😳',
    'ice cream': '🍦',
    'ketchup': '🍅',
    'tea': '🍵',
    'coffee': '☕',
    'chicken': '🐔',
    'pasta': '🍝',
    'cheese': '🧀',
    'pizza': '🍕',
    'milk': '🐄',
    'pork': '🐖',
    'beef': '🐄',
    'gum': '🫧',
    'boba': '🧋',
    'fish': '🐟',
    'sushi': '🍣',
    'salt': '🧂',
    'burger': '🍔',
    'bacon': '🥓',
    'meat': '🥩',
    'fruit': '🍎',
    'beer': '🍺',
    'rice': '🍚',
    'tp': '🧻',
    'monster': '⚡',
    'hell': '⚡',
    'energy': '⚡',
    'redbull': '⚡',
    'snacks': '🍿',
    'beans': '🫘',
    'corn': '🌽',
    'chips': '🥔',
    'sugar': '💎',
    'butter': '🧈',
    'bread': '🍞',
    'burrito': '🌯',
    'cookie': '🍪',
    'candy': '🍬',
    'chocolate': '🍫',
    'wine': '🍷',
    'watermelon': '🍉',
    'strawberry': '🍓',
    'cherry': '🍒',
    'peach': '🍑',
    'banana': '🍌',
    'carrot': '🥕',
    'steak': '🥩',
    'honey': '🐝',
    'paper towel': '🧻',
    'candle': '🕯️',
    'lemon': '🍋',
    'cereal': '🥣',
    'apple': '🍎',
    'orange': '🍊',
    'grape': '🍇',
    'melon': '🍈',
    'pineapple': '🍍',
    'pear': '🍐',
    'egg': '🥚',
    'onion': '🧅',
    'garlic': '🧄',
    'potato': '🥔',
    'tomato': '🍅',
    'broccoli': '🥦',
    'lettuce': '🥬',
    'spinach': '🥬',
    'cucumber': '🥒',
    'avocado': '🥑',
    'eggplant': '🍆',
    'mushroom': '🍄',
    'peanut': '🥜',
    'croissant': '🥐',
    'waffle': '🧇',
    'pancake': '🥞',
    'donut': '🍩',
    'cake': '🍰',
    'juice': '🧃',
    'soda': '🥤',
    'water': '💧',
    'yogurt': '🥛',
    'oil': '🛢️',
    'shampoo': '🧴',
    'soap': '🧼',
    'sponge': '🧽',
    'toothpaste': '🪥',
    'brush': '🪥',

    // Hungarian defaults
    'tej': '🥛',
    'kenyér': '🍞',
    'vaj': '🧈',
    'sajt': '🧀',
    'tojás': '🥚',
    'víz': '💧',
    'kávé': '☕',
    'hús': '🥩',
    'csirke': '🐔',
    'sertés': '🐖',
    'marha': '🐄',
    'hal': '🐟',
    'alma': '🍎',
    'körte': '🍐',
    'narancs': '🍊',
    'citrom': '🍋',
    'eper': '🍓',
    'barack': '🍑',
    'szőlő': '🍇',
    'dinnye': '🍉',
    'krumpli': '🥔',
    'burgonya': '🥔',
    'hagyma': '🧅',
    'fokhagyma': '🧄',
    'paradicsom': '🍅',
    'paprika': '🫑',
    'répa': '🥕',
    'sárgarépa': '🥕',
    'uborka': '🥒',
    'saláta': '🥬',
    'rizs': '🍚',
    'tészta': '🍝',
    'sör': '🍺',
    'bor': '🍷',
    'csoki': '🍫',
    'csokoládé': '🍫',
    'cukor': '💎',
    'só': '🧂',
    'szappan': '🧼',
    'sampon': '🧴',
    'fogkrém': '🪥',
    'vécépapír': '🧻',
    'papírtörlő': '🧻',
  };

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = prefs.getString('custom_emoji_pairings');
    if (serialized != null) {
      try {
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        _customPairings = decoded.map((key, value) => MapEntry(key, value.toString()));
      } catch (_) {
        _customPairings = {};
      }
    }
  }

  static String? getEmoji(String query) {
    final lowercaseQuery = query.trim().toLowerCase();

    if (_customPairings.containsKey(lowercaseQuery)) {
      return _customPairings[lowercaseQuery];
    }

    if (seededDefaults.containsKey(lowercaseQuery)) {
      return seededDefaults[lowercaseQuery];
    }

    return null;
  }

  static Future<void> savePairing(String key, String emoji) async {
    final lowercaseKey = key.trim().toLowerCase();
    _customPairings[lowercaseKey] = emoji;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_emoji_pairings', jsonEncode(_customPairings));
  }
}
