import 'package:flutter/material.dart';
import 'package:is_shopping/screens/main_screen.dart';
import 'package:is_shopping/themes.dart';

void main() => runApp(MaterialApp(
      home: const MainScreenDisplayer(),
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.system,
    ));
