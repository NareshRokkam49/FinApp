import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController with ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (type == Locale("en")) {
      await sp.setString("language_code", "el");
    } else {
      await sp.setString("language_code", "es");
    }
    notifyListeners();
  }
}
