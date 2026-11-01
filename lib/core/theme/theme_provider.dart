import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(bool darkMode) {
    themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
