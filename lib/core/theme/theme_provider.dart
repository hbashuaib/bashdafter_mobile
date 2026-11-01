import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final darkMode = prefs.getBool('dark_mode') ?? false;

    themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> toggleTheme(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('dark_mode', darkMode);

    themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
