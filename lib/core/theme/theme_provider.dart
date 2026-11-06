import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final darkMode =
        prefs.getBool('dark_mode') ?? false;

    _themeMode = darkMode
        ? ThemeMode.dark
        : ThemeMode.light;

    notifyListeners();
  }

  Future<void> toggleTheme(
    bool darkMode,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'dark_mode',
      darkMode,
    );

    _themeMode = darkMode
        ? ThemeMode.dark
        : ThemeMode.light;

    notifyListeners();
  }
}