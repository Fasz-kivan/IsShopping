import 'package:flutter/material.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: false,
      fontFamily: 'Segoe UI',
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff5fd068), // used for accent colors
        onPrimary: Color(0xff1e1e1e), // used for text color
        secondary: Color(0xffFd5d6a), // used for checkbox color
        onSecondary: Color(0xff808080), // used for alt text color
        error: Color(0x00000000), // unused
        onError: Color(0x00000000), // unused
        background: Color(0xfff6fbf4), // used for list background
        onBackground: Color(0xfff3f3f3), // used for emoji container
        surface: Color(0xffffffff), // used for navbar color
        onSurface: Color(0xff404040), // used for input background
        tertiary: Color(0xffffffff), // used for card background
      ));

  static ThemeData darkTheme = ThemeData(
      useMaterial3: false,
      fontFamily: 'Segoe UI',
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xff48854c), // used for accent colors
        onPrimary: Color(0xffffffff), // used for text color
        secondary: Color(0xffb84049), // used for checkbox color
        onSecondary: Color(0xff999999), // used for alt text
        error: Color(0x00000000), // unused
        onError: Color(0x00000000), // unused
        background: Color(0xff303030), // used for list background
        onBackground: Color(0xff383838), // used for emoji container
        surface: Color(0xff424242), // used for navbar color
        onSurface: Color(0xffcfcfcf), // used for modal borders
        tertiary: Color(0xff4b4b4b), // used for card background
      ));
}
