import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  static const String key = 'themeMode';

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, mode.toString().split('.').last);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(key);

    if (themeStr == null) {
      // Eğer hiç tema seçilmemişse varsayılan olarak light başlat
      return ThemeMode.light;
    }

    switch (themeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light; // system varsa bile light'a sabitle
    }
  }
}
