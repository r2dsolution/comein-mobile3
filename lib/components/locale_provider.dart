import 'package:thecomein/helper/logger.dart';
import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  bool isTH = true;
  Locale _locale = const Locale("th", "TH");
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    Logger.log("change locale");
    if (isTH) {
      _locale = const Locale("en");
      isTH = false;
    } else {
      _locale = const Locale("th", "TH");
      isTH = true;
    }

    notifyListeners();
  }
}
