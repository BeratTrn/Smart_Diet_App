import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageHelper {
  static const _languageCodeKey = 'languageCode';

  // Dil kaydet
  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
  }

  // Kayıtlı dili getir (yoksa varsayılan 'tr')
  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageCodeKey) ?? 'tr';
    return Locale(code);
  }
}
